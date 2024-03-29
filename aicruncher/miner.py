import numpy as np
import pyopencl as cl
import pyopencl.tools
import pyopencl.array
import base64
import hashlib
import time
import os, sys, inspect
import requests
import threading
import logging
import json
import hashlib
import socket
import traceback
import uuid
import queue
from sha256 import SHA256

mf = cl.mem_flags
logger = logging.getLogger()
logger.setLevel(logging.INFO)
start_time = time.time()

# Config
batchSize = 512 * 64
repeats = 1
internal_iterations = 500000
threads = 1
double_ring = False
shipName = socket.gethostname()
shipId = str(uuid.uuid4())

# Resolve unique id
if os.path.isfile('state.json'):
    with open('state.json', 'r') as json_file:
        data = json.load(json_file)
        shipId = data['id']
else:
    with open('state.json', 'w') as json_file:
        json.dump({'id': shipId}, json_file)

# Resolve config
if os.path.isfile('config.json'):
    with open('config.json') as json_file:
        data = json.load(json_file)
        shipName = data.get('name', shipName)
        shipId = data.get('id', shipId)

logger.info("Starting miner...")
logger.info("ID: " + shipId)
logger.info("Name: " + shipName)

# Mining config
def load_config():
    while True:
        try:
            resp = requests.get("http://64.225.102.108:3000/params", timeout=5)
            data = resp.json()
            key = data['id']
            ref = data['ref']
            header = b'\x00\xF2' + base64.b64decode(data['header'])
            seed = base64.b64decode(data['seed'])
            random = base64.b64decode(data['random'])
            data = header + random + seed + random
            data_padded = data + b'\x00\x00\x00\x00\x00'
            return {'key': key, 'header': header, 'ref': ref, 'seed': seed, 'random': random, 'data': data_padded, 'source': data, 'offset':0, 'lock': threading.Lock()}
        except Exception as e:
            logger.error(traceback.format_exc())
            logger.warn("Config load error");
            time.sleep(5)
            continue
        break
    

def validate(config, random, value):
    m = hashlib.sha256()
    m.update(config['header'] + random + config['seed'] + random)
    local_digest = m.digest()
    if m.digest().hex() != value.hex():
        return False
    else:
        return True

def apply_speed(src, value):
    src.append(value)
    if len(src) > 5:
        del src[0]

def resolve_speed(src):
    if len(src) == 0:
        return 0
    res = 0
    for i in range(0, len(src)):
        res = res + src[i]
    res = res / len(src)
    return res


reportQueue = queue.Queue()
def report(key, ref, seed, random, value, rate):
    global shipId
    global shipName
    while True:
        try:
            requests.post("http://64.225.102.108:3000/report", json = {
                'key':key, 
                'ref': ref, 
                'seed': seed.hex(), 
                'random':random.hex(),
                'hash': value.hex(),
                'ship-id': shipId, 
                'ship-name': shipName,
                'ship-rate': rate
            }, timeout=5)
        except Exception as e:
            logger.error(traceback.format_exc())
            logger.warn("Reporting error");
            time.sleep(5)
            continue
        break
def reportQueueJob():
    while True:
        try:
            item = reportQueue.get()
            report(item['key'], item['ref'], item['seed'], item['random'], item['value'], item['rate'])
            reportQueue.task_done()
        except Exception as e:
            logging.warn(traceback.format_exc())
            logging.warn("Monitoring error");
            time.sleep(5)
            continue
def startReportQueue():
    threading.Thread(target=reportQueueJob).start()

def postReport(key, ref, seed, random, value, rate):
    reportQueue.put({'key': key, 'ref': ref, 'seed': seed, 'random': random, 'value': value, 'rate': rate})

# Code
platforms = cl.get_platforms()
devices = cl.get_platforms()[0].get_devices()
ctx = cl.Context(devices)
src = ''
# with open(os.path.join(os.path.dirname(__file__),"kernels/sha256_util.cl"), "r") as rf:
#     src += rf.read()
# src += '\n'    
# with open(os.path.join(os.path.dirname(__file__),"kernels/sha256_impl.cl"), "r") as rf:
#     src += rf.read()    
# src += '\n'
# with open(os.path.join(os.path.dirname(__file__),"kernels/miner.cl"), "r") as rf:
#     src += rf.read()
with open(os.path.join(os.path.dirname(__file__),"kernels/miner2.cl"), "r") as rf:
    src += rf.read()
program = cl.Program(ctx, src).build()

queue = []
for i in range(0, len(devices)):
    queue.append(cl.CommandQueue(ctx, devices[i]))
def compare(a, b):
    i = 0
    while (i < 32):
        if (a[i] != b[i]):
            if a[i] < b[i]:
                return -1
            else:
                return 1
        i += 1
    return 0


#
# Config
#

logging.info("Loading initial config...")
latest_config = load_config()
logging.info("Config loaded")

def config_refresh_job():
    global latest_config
    latest_config = load_config()

#
# Mining
#

mined = 0
mined_dev = {}
rate = 0
speed_average = []
speed_average_dev = {}
def miner_job(index, deviceId):
    global mined
    global mined_dev
    global repeats
    global latest_config
    global speed_average
    
    config = latest_config
    start = time.time()
    # logging.info("[" + str(index) + "/"+str(deviceId)+"]: Job started")
    # random = os.urandom(32)
    random = bytes(np.random.bytes(32))
    data = np.frombuffer(config['header'] + random + config['seed'] + random + b'\x80\x00\x00\x00\x00', dtype=np.uint32)
    m = SHA256()
    m.update(bytes(data[0:16]))
    initial_vector = m._h

    output_1 = np.zeros((batchSize, 32), dtype=np.uint8)
    output_1_random = np.zeros((batchSize, 32), dtype=np.uint8)
    output_2 = np.zeros((batchSize, 32), dtype=np.uint8)
    output_2_random = np.zeros((batchSize, 32), dtype=np.uint8)
    res = None
    res_random = None
    cl_data = cl.Buffer(ctx, cl.mem_flags.COPY_HOST_PTR, hostbuf=data)
    cl_output_1 = cl.Buffer(ctx, cl.mem_flags.WRITE_ONLY, output_1.nbytes)
    cl_output_1_random = cl.Buffer(ctx, cl.mem_flags.WRITE_ONLY, output_1_random.nbytes)
    cl_output_2 = cl.Buffer(ctx, cl.mem_flags.WRITE_ONLY, output_2.nbytes)
    cl_output_2_random = cl.Buffer(ctx, cl.mem_flags.WRITE_ONLY, output_2_random.nbytes)
    for i in range(0, repeats):
        # print("[" + str(index) +"/"+str(deviceId)+ "]: Iteration " + str(i))
        
        
        # Assign offset
        config['lock'].acquire()
        offset = config['offset']
        config['offset'] += internal_iterations * batchSize
        config['lock'].release()
        
        event1 = program.do_work(queue[deviceId], (batchSize,), None, 
            np.uint32(initial_vector[0]),
            np.uint32(initial_vector[1]),
            np.uint32(initial_vector[2]),
            np.uint32(initial_vector[3]),
            np.uint32(initial_vector[4]),
            np.uint32(initial_vector[5]),
            np.uint32(initial_vector[6]),
            np.uint32(initial_vector[7]),
            cl_data,
            cl_output_1,
            cl_output_1_random,
            np.uint64(offset),
            np.uint32(internal_iterations)
        )
        
        # event1.wait()
        # elapsed = 1e-9*(event1.profile.end - event1.profile.start)
        # logging.info("[" + str(index) + "/"+str(deviceId)+"]: Elapsed  " + str(elapsed))
        if double_ring:

            # Assign offset
            config['lock'].acquire()
            offset = config['offset']
            config['offset'] += internal_iterations * batchSize
            config['lock'].release()

            event2 = program.do_work(queue[deviceId], (batchSize,), None, 
                np.uint32(initial_vector[0]),
                np.uint32(initial_vector[1]),
                np.uint32(initial_vector[2]),
                np.uint32(initial_vector[3]),
                np.uint32(initial_vector[4]),
                np.uint32(initial_vector[5]),
                np.uint32(initial_vector[6]),
                np.uint32(initial_vector[7]),
                cl_data, 
                cl_output_2, 
                cl_output_2_random,
                np.uint64(offset), 
                np.uint32(internal_iterations))
        wait_start = time.time()
        # event1.wait()
        # logging.info("[" + str(index) + "/"+str(deviceId)+"]: Waited (1) " + str(( time.time() - wait_start)))
        # wait_start = time.time()
        read1 = cl.enqueue_copy(queue[deviceId], output_1, cl_output_1, is_blocking=False)
        read2 = cl.enqueue_copy(queue[deviceId], output_1_random, cl_output_1_random, is_blocking=False)
        read1.wait()
        read2.wait()
        mined += internal_iterations * batchSize
        mined_dev[str(deviceId)] = mined_dev.get(str(deviceId),0) + internal_iterations * batchSize
        logging.info("[" + str(index) + "/"+str(deviceId)+"]: Processed in " + str(( time.time() - wait_start)))

        if double_ring:
            wait_start = time.time()
            event2.wait()
            # logging.info("[" + str(index) + "/"+str(deviceId)+"]: Waited (2) " + str(( time.time() - wait_start)))
            wait_start = time.time()
            cl.enqueue_copy(queue[deviceId], output_2, cl_output_2)
            cl.enqueue_copy(queue[deviceId], output_2_random, cl_output_2_random)
            # logging.info("[" + str(index) + "/"+str(deviceId)+"]: Read (2) " + str(( time.time() - wait_start)))
            mined += internal_iterations * batchSize
            mined_dev[str(deviceId)] = mined_dev.get(str(deviceId),0) + internal_iterations * batchSize
    
        found_new = False
        if res is None:
            res = bytes(output_1[0])
            res_random = bytes(output_1_random[0])
            found_new = True
        for i in range(0, batchSize):
            if compare(bytes(output_1[i]), res) < 0:
                found_new = True
                res = bytes(output_1[i])
                res_random = bytes(output_1_random[i])
        if double_ring:
            for i in range(0, batchSize):
                if compare(bytes(output_2[i]), res) < 0:
                    found_new = True
                    res = bytes(output_2[i])
                    res_random = bytes(output_2_random[i])
#        if found_new:
#            print("[" + str(index) +"/"+str(deviceId)+ "]: Intermediate result: " + res.hex())
    cl_data.release()
    cl_output_1.release()
    cl_output_1_random.release()
    cl_output_2.release()
    cl_output_2_random.release()
    logging.info("[" + str(index) +"/"+str(deviceId)+ "]: Job result: " + res.hex())
    if not validate(config, res_random, res):
        logging.info("[" + str(index) +"/"+str(deviceId)+ "]: Invalid job result")
    else:
        postReport(config['key'], config['ref'], config['seed'], res_random, res, rate)
    # logging.info("[" + str(index) +"/"+str(deviceId)+ "]: Job ended")

def buildHash(data):
    m = hashlib.sha256()
    m.update(data)
    return m.digest()

def miner_thread(index, deviceId):
    logging.info("[" + str(index) + "/"+str(deviceId)+"]: Thread started")
    while True:
        try:
            miner_job(index, deviceId)
        except:
            logging.warn(traceback.format_exc())
            logging.info("[" + str(index) + "/"+str(deviceId)+"]: Miner error")
            time.sleep(5)
            continue
        
def start_miner_thread(index, deviceId):
    threading.Thread(target=miner_thread, args=(index,deviceId)).start()

def miner_config_thread():
    while True:
        time.sleep(1)
        try:
            config_refresh_job()
            # logging.info("Config updated")
        except Exception as e:
            logging.warn(traceback.format_exc())
            logging.warn("Config error");
            time.sleep(5)
            continue
def start_miner_config_thread():
    threading.Thread(target=miner_config_thread).start()

def miner_mon(count):
    global mined
    global mined_dev
    global rate
    global speed_average
    global speed_average_dev

    # Start Timer
    start = time.time()

    # Reset mined state
    mined = 0
    for i in range(0, count):
        mined_dev[str(i)] = 0
        speed_average_dev[str(i)] = []
    
    while True:
        time.sleep(10)
        try:

            # Resolve time
            time_delta = time.time() - start
            start = time.time()

            # Resolve speed
            delta = mined / (time_delta * 1000 * 1000)
            mined = 0

            # Update average speed
            apply_speed(speed_average, delta)
            total_average = resolve_speed(speed_average)
            rate = total_average

            # Calculate thread speed
            rates = []
            for i in range(0, count):

                # Resolve speed
                dev_delta = mined_dev.get(str(i), 0) / (time_delta * 1000 * 1000)
                mined_dev[str(i)] = 0

                # Update average speed
                apply_speed(speed_average_dev[str(i)], dev_delta)
                rates.append(resolve_speed(speed_average_dev[str(i)]))

            # Logging
            logging.info("Performance " + str(total_average) + " MH/s")          

            # Persisting
            with open('stats.json', 'w') as json_file:
                json.dump({
                    'total': total_average * 1000, # in khs
                    'rates': rates,
                    'uptime': time.time() - start_time
                }, json_file)
        except Exception as e:
            logging.warn(traceback.format_exc())
            logging.warn("Monitoring error");
            time.sleep(5)
            continue

def start_miner_mon(count):
    threading.Thread(target=miner_mon, args=(count,)).start()

#
# Start
#

# Start monitoring
start_miner_mon(len(devices))

# Start config loader
start_miner_config_thread()

# Start reporting queue
startReportQueue()

# Start miners
for i in range(0, len(devices)):
    for t in range(0, threads):
        start_miner_thread(i * threads + t, i)

logger.info("Miner started")