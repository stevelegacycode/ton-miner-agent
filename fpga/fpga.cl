#define DECLSPEC  __inline static
#define SHA256C00 0x428a2f98u
#define SHA256C01 0x71374491u
#define SHA256C02 0xb5c0fbcfu
#define SHA256C03 0xe9b5dba5u
#define SHA256C04 0x3956c25bu
#define SHA256C05 0x59f111f1u
#define SHA256C06 0x923f82a4u
#define SHA256C07 0xab1c5ed5u
#define SHA256C08 0xd807aa98u
#define SHA256C09 0x12835b01u
#define SHA256C0a 0x243185beu
#define SHA256C0b 0x550c7dc3u
#define SHA256C0c 0x72be5d74u
#define SHA256C0d 0x80deb1feu
#define SHA256C0e 0x9bdc06a7u
#define SHA256C0f 0xc19bf174u
#define SHA256C10 0xe49b69c1u
#define SHA256C11 0xefbe4786u
#define SHA256C12 0x0fc19dc6u
#define SHA256C13 0x240ca1ccu
#define SHA256C14 0x2de92c6fu
#define SHA256C15 0x4a7484aau
#define SHA256C16 0x5cb0a9dcu
#define SHA256C17 0x76f988dau
#define SHA256C18 0x983e5152u
#define SHA256C19 0xa831c66du
#define SHA256C1a 0xb00327c8u
#define SHA256C1b 0xbf597fc7u
#define SHA256C1c 0xc6e00bf3u
#define SHA256C1d 0xd5a79147u
#define SHA256C1e 0x06ca6351u
#define SHA256C1f 0x14292967u
#define SHA256C20 0x27b70a85u
#define SHA256C21 0x2e1b2138u
#define SHA256C22 0x4d2c6dfcu
#define SHA256C23 0x53380d13u
#define SHA256C24 0x650a7354u
#define SHA256C25 0x766a0abbu
#define SHA256C26 0x81c2c92eu
#define SHA256C27 0x92722c85u
#define SHA256C28 0xa2bfe8a1u
#define SHA256C29 0xa81a664bu
#define SHA256C2a 0xc24b8b70u
#define SHA256C2b 0xc76c51a3u
#define SHA256C2c 0xd192e819u
#define SHA256C2d 0xd6990624u
#define SHA256C2e 0xf40e3585u
#define SHA256C2f 0x106aa070u
#define SHA256C30 0x19a4c116u
#define SHA256C31 0x1e376c08u
#define SHA256C32 0x2748774cu
#define SHA256C33 0x34b0bcb5u
#define SHA256C34 0x391c0cb3u
#define SHA256C35 0x4ed8aa4au
#define SHA256C36 0x5b9cca4fu
#define SHA256C37 0x682e6ff3u
#define SHA256C38 0x748f82eeu
#define SHA256C39 0x78a5636fu
#define SHA256C3a 0x84c87814u
#define SHA256C3b 0x8cc70208u
#define SHA256C3c 0x90befffau
#define SHA256C3d 0xa4506cebu
#define SHA256C3e 0xbef9a3f7u
#define SHA256C3f 0xc67178f2u 

__constant uint k_sha256[64] =
{
  SHA256C00, SHA256C01, SHA256C02, SHA256C03,
  SHA256C04, SHA256C05, SHA256C06, SHA256C07,
  SHA256C08, SHA256C09, SHA256C0a, SHA256C0b,
  SHA256C0c, SHA256C0d, SHA256C0e, SHA256C0f,
  SHA256C10, SHA256C11, SHA256C12, SHA256C13,
  SHA256C14, SHA256C15, SHA256C16, SHA256C17,
  SHA256C18, SHA256C19, SHA256C1a, SHA256C1b,
  SHA256C1c, SHA256C1d, SHA256C1e, SHA256C1f,
  SHA256C20, SHA256C21, SHA256C22, SHA256C23,
  SHA256C24, SHA256C25, SHA256C26, SHA256C27,
  SHA256C28, SHA256C29, SHA256C2a, SHA256C2b,
  SHA256C2c, SHA256C2d, SHA256C2e, SHA256C2f,
  SHA256C30, SHA256C31, SHA256C32, SHA256C33,
  SHA256C34, SHA256C35, SHA256C36, SHA256C37,
  SHA256C38, SHA256C39, SHA256C3a, SHA256C3b,
  SHA256C3c, SHA256C3d, SHA256C3e, SHA256C3f,
};

#define SHA256M_A 0x6a09e667U
#define SHA256M_B 0xbb67ae85U
#define SHA256M_C 0x3c6ef372U
#define SHA256M_D 0xa54ff53aU
#define SHA256M_E 0x510e527fU
#define SHA256M_F 0x9b05688cU
#define SHA256M_G 0x1f83d9abU
#define SHA256M_H 0x5be0cd19U

typedef unsigned int u32;
typedef unsigned long u64;
typedef unsigned char u8;

typedef struct sha256_ctx
{
  u32 h[8];

  u32 w0[4];
  u32 w1[4];
  u32 w2[4];
  u32 w3[4];

  int len;

} sha256_ctx_t;

#define SHA256_F0(x,y,z)  (((x) & (y)) | ((z) & ((x) ^ (y))))
#define SHA256_F1(x,y,z)  ((z) ^ ((x) & ((y) ^ (z))))
                                       
#define SHA256_F0o(x,y,z) (bitselect ((x), (y), ((x) ^ (z))))
#define SHA256_F1o(x,y,z) (bitselect ((z), (y), (x)))

#define SHIFT_RIGHT_32(x,n) ((x) >> (n))

#define SHA256_S0_S(x) (hc_rotl32_S ((x), 25u) ^ hc_rotl32_S ((x), 14u) ^ SHIFT_RIGHT_32 ((x),  3u))
#define SHA256_S1_S(x) (hc_rotl32_S ((x), 15u) ^ hc_rotl32_S ((x), 13u) ^ SHIFT_RIGHT_32 ((x), 10u))
#define SHA256_S2_S(x) (hc_rotl32_S ((x), 30u) ^ hc_rotl32_S ((x), 19u) ^ hc_rotl32_S ((x), 10u))
#define SHA256_S3_S(x) (hc_rotl32_S ((x), 26u) ^ hc_rotl32_S ((x), 21u) ^ hc_rotl32_S ((x),  7u))

#define SHA256_S0(x) (hc_rotl32 ((x), 25u) ^ hc_rotl32 ((x), 14u) ^ SHIFT_RIGHT_32 ((x),  3u))
#define SHA256_S1(x) (hc_rotl32 ((x), 15u) ^ hc_rotl32 ((x), 13u) ^ SHIFT_RIGHT_32 ((x), 10u))
#define SHA256_S2(x) (hc_rotl32 ((x), 30u) ^ hc_rotl32 ((x), 19u) ^ hc_rotl32 ((x), 10u))
#define SHA256_S3(x) (hc_rotl32 ((x), 26u) ^ hc_rotl32 ((x), 21u) ^ hc_rotl32 ((x),  7u))

#define SHA256_STEP_S(F0,F1,a,b,c,d,e,f,g,h,x,K)  \
{                                                 \
  h = hc_add3_S (h, K, x);                        \
  h = hc_add3_S (h, SHA256_S3_S (e), F1 (e,f,g)); \
  d += h;                                         \
  h = hc_add3_S (h, SHA256_S2_S (a), F0 (a,b,c)); \
}

#define SHA256_EXPAND_S(x,y,z,w) (SHA256_S1_S (x) + y + SHA256_S0_S (z) + w)

#define SHA256_STEP(F0,F1,a,b,c,d,e,f,g,h,x,K)    \
{                                                 \
  h = hc_add3 (h, K, x);                          \
  h = hc_add3 (h, SHA256_S3 (e), F1 (e,f,g));     \
  d += h;                                         \
  h = hc_add3 (h, SHA256_S2 (a), F0 (a,b,c));     \
}

#define SHA256_EXPAND(x,y,z,w) (SHA256_S1 (x) + y + SHA256_S0 (z) + w)

DECLSPEC u32 hc_add3_S (const u32 a, const u32 b, const u32 c)
{
  return a + b + c;
}
                                       
DECLSPEC u32 hc_rotl32_S (const u32 a, const int n)
{
  #if   defined _CPU_OPENCL_EMU_H
  return rotl32 (a, n);
  #elif defined IS_CUDA || defined IS_HIP
  return rotl32_S (a, n);
  #else
  #ifdef USE_ROTATE
  return rotate (a, (u32) (n));
  #else
  return ((a << n) | (a >> (32 - n)));
  #endif
  #endif
}
                   
DECLSPEC void append_helper_1x4_S (u32 *r, const u32 v, const u32 *m)
{
  r[0] |= v & m[0];
  r[1] |= v & m[1];
  r[2] |= v & m[2];
  r[3] |= v & m[3];
}

DECLSPEC void set_mark_1x4_S (u32 *v, const u32 offset)
{
  const u32 c = (offset & 15) / 4;
  const u32 r = 0xff << ((offset & 3) * 8);

  v[0] = (c == 0) ? r : 0;
  v[1] = (c == 1) ? r : 0;
  v[2] = (c == 2) ? r : 0;
  v[3] = (c == 3) ? r : 0;
}

DECLSPEC void append_0x80_4x4_S (u32 *w0, u32 *w1, u32 *w2, u32 *w3, const u32 offset)
{
  u32 v[4];

  set_mark_1x4_S (v, offset);

  const u32 offset16 = offset / 16;

  append_helper_1x4_S (w0, ((offset16 == 0) ? 0x80808080 : 0), v);
  append_helper_1x4_S (w1, ((offset16 == 1) ? 0x80808080 : 0), v);
  append_helper_1x4_S (w2, ((offset16 == 2) ? 0x80808080 : 0), v);
  append_helper_1x4_S (w3, ((offset16 == 3) ? 0x80808080 : 0), v);
}

DECLSPEC u32 hc_swap32_S (const u32 v)
{
  u32 r;

  #ifdef _CPU_OPENCL_EMU_H
  r = byte_swap_32 (v);
  #else
  #if   (defined IS_AMD || defined IS_HIP) && HAS_VPERM == 1
  __asm__ __volatile__ ("V_PERM_B32 %0, 0, %1, %2;" : "=v"(r) : "v"(v), "v"(0x00010203));
  #elif defined IS_NV  && HAS_PRMT  == 1
  asm volatile ("prmt.b32 %0, %1, 0, 0x0123;" : "=r"(r) : "r"(v));
  #else
  #ifdef USE_SWIZZLE
  r = as_uint (as_uchar4 (v).s3210);
  #else
  r = ((v & 0xff000000) >> 24)
    | ((v & 0x00ff0000) >>  8)
    | ((v & 0x0000ff00) <<  8)
    | ((v & 0x000000ff) << 24);
  #endif
  #endif
  #endif

  return r;
}

DECLSPEC void sha256_init (sha256_ctx_t *ctx)
{
  ctx->h[0] = SHA256M_A;
  ctx->h[1] = SHA256M_B;
  ctx->h[2] = SHA256M_C;
  ctx->h[3] = SHA256M_D;
  ctx->h[4] = SHA256M_E;
  ctx->h[5] = SHA256M_F;
  ctx->h[6] = SHA256M_G;
  ctx->h[7] = SHA256M_H;

  ctx->w0[0] = 0;
  ctx->w0[1] = 0;
  ctx->w0[2] = 0;
  ctx->w0[3] = 0;
  ctx->w1[0] = 0;
  ctx->w1[1] = 0;
  ctx->w1[2] = 0;
  ctx->w1[3] = 0;
  ctx->w2[0] = 0;
  ctx->w2[1] = 0;
  ctx->w2[2] = 0;
  ctx->w2[3] = 0;
  ctx->w3[0] = 0;
  ctx->w3[1] = 0;
  ctx->w3[2] = 0;
  ctx->w3[3] = 0;

  ctx->len = 0;
}

DECLSPEC void sha256_transform (const u32 *w0, const u32 *w1, const u32 *w2, const u32 *w3, u32 *digest)
{
  u32 a = digest[0];
  u32 b = digest[1];
  u32 c = digest[2];
  u32 d = digest[3];
  u32 e = digest[4];
  u32 f = digest[5];
  u32 g = digest[6];
  u32 h = digest[7];

  u32 w0_t = w0[0];
  u32 w1_t = w0[1];
  u32 w2_t = w0[2];
  u32 w3_t = w0[3];
  u32 w4_t = w1[0];
  u32 w5_t = w1[1];
  u32 w6_t = w1[2];
  u32 w7_t = w1[3];
  u32 w8_t = w2[0];
  u32 w9_t = w2[1];
  u32 wa_t = w2[2];
  u32 wb_t = w2[3];
  u32 wc_t = w3[0];
  u32 wd_t = w3[1];
  u32 we_t = w3[2];
  u32 wf_t = w3[3];

  #define ROUND_EXPAND_S()                            \
  {                                                   \
    w0_t = SHA256_EXPAND_S (we_t, w9_t, w1_t, w0_t);  \
    w1_t = SHA256_EXPAND_S (wf_t, wa_t, w2_t, w1_t);  \
    w2_t = SHA256_EXPAND_S (w0_t, wb_t, w3_t, w2_t);  \
    w3_t = SHA256_EXPAND_S (w1_t, wc_t, w4_t, w3_t);  \
    w4_t = SHA256_EXPAND_S (w2_t, wd_t, w5_t, w4_t);  \
    w5_t = SHA256_EXPAND_S (w3_t, we_t, w6_t, w5_t);  \
    w6_t = SHA256_EXPAND_S (w4_t, wf_t, w7_t, w6_t);  \
    w7_t = SHA256_EXPAND_S (w5_t, w0_t, w8_t, w7_t);  \
    w8_t = SHA256_EXPAND_S (w6_t, w1_t, w9_t, w8_t);  \
    w9_t = SHA256_EXPAND_S (w7_t, w2_t, wa_t, w9_t);  \
    wa_t = SHA256_EXPAND_S (w8_t, w3_t, wb_t, wa_t);  \
    wb_t = SHA256_EXPAND_S (w9_t, w4_t, wc_t, wb_t);  \
    wc_t = SHA256_EXPAND_S (wa_t, w5_t, wd_t, wc_t);  \
    wd_t = SHA256_EXPAND_S (wb_t, w6_t, we_t, wd_t);  \
    we_t = SHA256_EXPAND_S (wc_t, w7_t, wf_t, we_t);  \
    wf_t = SHA256_EXPAND_S (wd_t, w8_t, w0_t, wf_t);  \
  }

  #define ROUND_STEP_S(i)                                                                   \
  {                                                                                         \
    SHA256_STEP_S (SHA256_F0o, SHA256_F1o, a, b, c, d, e, f, g, h, w0_t, k_sha256[i +  0]); \
    SHA256_STEP_S (SHA256_F0o, SHA256_F1o, h, a, b, c, d, e, f, g, w1_t, k_sha256[i +  1]); \
    SHA256_STEP_S (SHA256_F0o, SHA256_F1o, g, h, a, b, c, d, e, f, w2_t, k_sha256[i +  2]); \
    SHA256_STEP_S (SHA256_F0o, SHA256_F1o, f, g, h, a, b, c, d, e, w3_t, k_sha256[i +  3]); \
    SHA256_STEP_S (SHA256_F0o, SHA256_F1o, e, f, g, h, a, b, c, d, w4_t, k_sha256[i +  4]); \
    SHA256_STEP_S (SHA256_F0o, SHA256_F1o, d, e, f, g, h, a, b, c, w5_t, k_sha256[i +  5]); \
    SHA256_STEP_S (SHA256_F0o, SHA256_F1o, c, d, e, f, g, h, a, b, w6_t, k_sha256[i +  6]); \
    SHA256_STEP_S (SHA256_F0o, SHA256_F1o, b, c, d, e, f, g, h, a, w7_t, k_sha256[i +  7]); \
    SHA256_STEP_S (SHA256_F0o, SHA256_F1o, a, b, c, d, e, f, g, h, w8_t, k_sha256[i +  8]); \
    SHA256_STEP_S (SHA256_F0o, SHA256_F1o, h, a, b, c, d, e, f, g, w9_t, k_sha256[i +  9]); \
    SHA256_STEP_S (SHA256_F0o, SHA256_F1o, g, h, a, b, c, d, e, f, wa_t, k_sha256[i + 10]); \
    SHA256_STEP_S (SHA256_F0o, SHA256_F1o, f, g, h, a, b, c, d, e, wb_t, k_sha256[i + 11]); \
    SHA256_STEP_S (SHA256_F0o, SHA256_F1o, e, f, g, h, a, b, c, d, wc_t, k_sha256[i + 12]); \
    SHA256_STEP_S (SHA256_F0o, SHA256_F1o, d, e, f, g, h, a, b, c, wd_t, k_sha256[i + 13]); \
    SHA256_STEP_S (SHA256_F0o, SHA256_F1o, c, d, e, f, g, h, a, b, we_t, k_sha256[i + 14]); \
    SHA256_STEP_S (SHA256_F0o, SHA256_F1o, b, c, d, e, f, g, h, a, wf_t, k_sha256[i + 15]); \
  }

  ROUND_STEP_S (0);
  for (int i = 16; i < 64; i += 16)
  {
    ROUND_EXPAND_S ();
    ROUND_STEP_S (i);
  }

  #undef ROUND_EXPAND_S
  #undef ROUND_STEP_S

  digest[0] += a;
  digest[1] += b;
  digest[2] += c;
  digest[3] += d;
  digest[4] += e;
  digest[5] += f;
  digest[6] += g;
  digest[7] += h;
}

DECLSPEC void sha256_update_64 (sha256_ctx_t *ctx, u32 *w0, u32 *w1, u32 *w2, u32 *w3, const int len)
{
  if (len == 0) return;

  const int pos = ctx->len & 63;

  ctx->len += len;

  // if (pos == 0) // Always 0
    ctx->w0[0] = w0[0];
    ctx->w0[1] = w0[1];
    ctx->w0[2] = w0[2];
    ctx->w0[3] = w0[3];
    ctx->w1[0] = w1[0];
    ctx->w1[1] = w1[1];
    ctx->w1[2] = w1[2];
    ctx->w1[3] = w1[3];
    ctx->w2[0] = w2[0];
    ctx->w2[1] = w2[1];
    ctx->w2[2] = w2[2];
    ctx->w2[3] = w2[3];
    ctx->w3[0] = w3[0];
    ctx->w3[1] = w3[1];
    ctx->w3[2] = w3[2];
    ctx->w3[3] = w3[3];

    if (len == 64)
    {
      sha256_transform (ctx->w0, ctx->w1, ctx->w2, ctx->w3, ctx->h);

      ctx->w0[0] = 0;
      ctx->w0[1] = 0;
      ctx->w0[2] = 0;
      ctx->w0[3] = 0;
      ctx->w1[0] = 0;
      ctx->w1[1] = 0;
      ctx->w1[2] = 0;
      ctx->w1[3] = 0;
      ctx->w2[0] = 0;
      ctx->w2[1] = 0;
      ctx->w2[2] = 0;
      ctx->w2[3] = 0;
      ctx->w3[0] = 0;
      ctx->w3[1] = 0;
      ctx->w3[2] = 0;
      ctx->w3[3] = 0;
    }
}

DECLSPEC void sha256_update (sha256_ctx_t *ctx, __const u32 *w, const int len)
{
  u32 w0[4];
  u32 w1[4];
  u32 w2[4];
  u32 w3[4];
  int pos4 = 0;
  w0[0] = w[pos4 +  0];
  w0[1] = w[pos4 +  1];
  w0[2] = w[pos4 +  2];
  w0[3] = w[pos4 +  3];
  w1[0] = w[pos4 +  4];
  w1[1] = w[pos4 +  5];
  w1[2] = w[pos4 +  6];
  w1[3] = w[pos4 +  7];
  w2[0] = w[pos4 +  8];
  w2[1] = w[pos4 +  9];
  w2[2] = w[pos4 + 10];
  w2[3] = w[pos4 + 11];
  w3[0] = w[pos4 + 12];
  w3[1] = w[pos4 + 13];
  w3[2] = w[pos4 + 14];
  w3[3] = w[pos4 + 15];

  sha256_update_64 (ctx, w0, w1, w2, w3, len);
}

DECLSPEC void sha256_final (sha256_ctx_t *ctx)
{
  const int pos = ctx->len & 63;

  append_0x80_4x4_S (ctx->w0, ctx->w1, ctx->w2, ctx->w3, pos ^ 3);

  if (pos >= 56)
  {
    sha256_transform (ctx->w0, ctx->w1, ctx->w2, ctx->w3, ctx->h);

    ctx->w0[0] = 0;
    ctx->w0[1] = 0;
    ctx->w0[2] = 0;
    ctx->w0[3] = 0;
    ctx->w1[0] = 0;
    ctx->w1[1] = 0;
    ctx->w1[2] = 0;
    ctx->w1[3] = 0;
    ctx->w2[0] = 0;
    ctx->w2[1] = 0;
    ctx->w2[2] = 0;
    ctx->w2[3] = 0;
    ctx->w3[0] = 0;
    ctx->w3[1] = 0;
    ctx->w3[2] = 0;
    ctx->w3[3] = 0;
  }

  ctx->w3[2] = 0;
  ctx->w3[3] = ctx->len * 8;

  sha256_transform (ctx->w0, ctx->w1, ctx->w2, ctx->w3, ctx->h);
}

#define RANDOM_SIZE 32
#define SEED_SIZE 16
#define OFFSET_1 0
#define OFFSET_2 12

void data_init(__global __const u32 *data, u32 *head, u32 *tail) {
  for(int i = 0; i<16; i++) {
    head[i] = hc_swap32_S(data[i]);
  }
  for(int i = 0; i<16; i++) {
    tail[i] = hc_swap32_S(data[i+16]);
  }
}

void data_export_random(u32 *tail, __global u8 *random) {
  u8 *tail_8 = (u8*)tail;
  for(int i = 0; i < RANDOM_SIZE; i++) {
    random[i] = tail_8[i + 27];
  }
}

void data_finalize(u32 *tail, u64 index) {
  u32 index_a = index & 0xffffffff;
  u32 index_b = (index >> 4) & 0xffffffff;
  tail[OFFSET_1] = tail[OFFSET_1] ^ index_a;
  tail[OFFSET_1+1] = tail[OFFSET_1+1] ^ index_b;
  tail[OFFSET_2] = tail[OFFSET_2] ^ index_a;
  tail[OFFSET_2+1] = tail[OFFSET_2+1] ^ index_b;

  for(int i = 0; i < 16; i++) {
    tail[i] = hc_swap32_S(tail[i]);
  }
}

sha256_ctx_t miner_init(u32 *head) {
  sha256_ctx_t ctx;
  sha256_init(&ctx);
  sha256_update(&ctx, head, 64);
  return ctx;
}

sha256_ctx_t miner_apply(sha256_ctx_t ctx, u32 *tail, u64 index) {
  u32 index_a = index & 0xffffffff;
  u32 index_b = (index >> 4) & 0xffffffff;

  tail[OFFSET_1] = tail[OFFSET_1] ^ index_a;
  tail[OFFSET_1+1] = tail[OFFSET_1+1] ^ index_b;
  tail[OFFSET_2] = tail[OFFSET_2] ^ index_a;
  tail[OFFSET_2+1] = tail[OFFSET_2+1] ^ index_b;

  sha256_update(&ctx, tail, 59);
  sha256_final(&ctx);

  tail[OFFSET_1] = tail[OFFSET_1] ^ index_a;
  tail[OFFSET_1+1] = tail[OFFSET_1+1] ^ index_b;
  tail[OFFSET_2] = tail[OFFSET_2] ^ index_a;
  tail[OFFSET_2+1] = tail[OFFSET_2+1] ^ index_b;

  return ctx;
}

int memcmp (const u32 *a, const u32 *b, int count) {
  const uchar *s1 = (uchar *)a;
  const uchar *s2 = (uchar *)b;
  while (count-- > 0) {
   if (*s1++ != *s2++)
     return s1[-1] < s2[-1] ? -1 : 1;
  }
  return 0;
}

__kernel void do_work(__global __const u32 *data, __global u32 *output, __global u8 *output_random, u64 offset, u32 iterations) {
  u32 current_id = get_global_id(0);

  // Prepare data
  u32 head[16];
  u32 tail[16];
  data_init(data, head, tail);

  // Latest
  u32 latest[8];
  u64 latest_index;
  latest[0] = 4294967294;
  latest[1] = 4294967294;
  latest[2] = 4294967294;
  latest[3] = 4294967294;
  latest[4] = 4294967294;
  latest[5] = 4294967294;
  latest[6] = 4294967294;
  latest[7] = 4294967294;
  u32 current[8];
  u64 index = offset + ((u64)current_id) * ((u64)iterations);

  // Prepare
  sha256_ctx_t ctx0 = miner_init(head);

  for(int i = 0; i<iterations; i++) {
          
    // Mine
    sha256_ctx_t ctx = miner_apply(ctx0, tail, index);

    // Output
    current[0] = hc_swap32_S(ctx.h[0]);
    current[1] = hc_swap32_S(ctx.h[1]);
    current[2] = hc_swap32_S(ctx.h[2]);
    current[3] = hc_swap32_S(ctx.h[3]);
    current[4] = hc_swap32_S(ctx.h[4]);
    current[5] = hc_swap32_S(ctx.h[5]);
    current[6] = hc_swap32_S(ctx.h[6]);
    current[7] = hc_swap32_S(ctx.h[7]);

    if (memcmp(current, latest, 32) < 0) {
      latest_index = index;
      latest[0] = current[0];
      latest[1] = current[1];
      latest[2] = current[2];
      latest[3] = current[3];
      latest[4] = current[4];
      latest[5] = current[5];
      latest[6] = current[6];
      latest[7] = current[7];
    }

    index++;
  }
  
  // Export output
  output[current_id * 8 + 0] = latest[0];
  output[current_id * 8 + 1] = latest[1];
  output[current_id * 8 + 2] = latest[2];
  output[current_id * 8 + 3] = latest[3];
  output[current_id * 8 + 4] = latest[4];
  output[current_id * 8 + 5] = latest[5];
  output[current_id * 8 + 6] = latest[6];
  output[current_id * 8 + 7] = latest[7];

  // Preprocess data
  data_finalize(tail, latest_index);
  
  // Export random
  data_export_random(tail, output_random + current_id * RANDOM_SIZE);
}

__kernel void do_work_debug(__global __const u32 *data, __global u32 *output, __global u8 *output_random, __global u32 *output_data, __global u32 *output_debug, u32 iter) {

  // Latest
  u32 latest[8];
  u64 latest_index;
  u32 current[8];
  u64 index = 5000000000;

  latest[0] = 4294967294;
  latest[1] = 4294967294;
  latest[2] = 4294967294;
  latest[3] = 4294967294;
  latest[4] = 4294967294;
  latest[5] = 4294967294;
  latest[6] = 4294967294;
  latest[7] = 4294967294;

  // Copy data
  u32 head[16];
  u32 tail[16];
  data_init(data, head, tail);

  // SHA256
  sha256_ctx_t ctx0 = miner_init(head);

  for(int i = 0; i<iter; i++) {

    // Mine
    sha256_ctx_t ctx = miner_apply(ctx0, tail, index);
    
    // Output
    current[0] = hc_swap32_S(ctx.h[0]);
    current[1] = hc_swap32_S(ctx.h[1]);
    current[2] = hc_swap32_S(ctx.h[2]);
    current[3] = hc_swap32_S(ctx.h[3]);
    current[4] = hc_swap32_S(ctx.h[4]);
    current[5] = hc_swap32_S(ctx.h[5]);
    current[6] = hc_swap32_S(ctx.h[6]);
    current[7] = hc_swap32_S(ctx.h[7]);

    output_debug[i * 8 + 0] = current[0];
    output_debug[i * 8 + 1] = current[1];
    output_debug[i * 8 + 2] = current[2];
    output_debug[i * 8 + 3] = current[3];
    output_debug[i * 8 + 4] = current[4];
    output_debug[i * 8 + 5] = current[5];
    output_debug[i * 8 + 6] = current[6];
    output_debug[i * 8 + 7] = current[7];

    if (memcmp(current, latest, 32) < 0) {
      latest_index = index;
      latest[0] = current[0];
      latest[1] = current[1];
      latest[2] = current[2];
      latest[3] = current[3];
      latest[4] = current[4];
      latest[5] = current[5];
      latest[6] = current[6];
      latest[7] = current[7];
    }

    // Update index
    index++;
  }
  
  output[0] = latest[0];
  output[1] = latest[1];
  output[2] = latest[2];
  output[3] = latest[3];
  output[4] = latest[4];
  output[5] = latest[5];
  output[6] = latest[6];
  output[7] = latest[7];

  // Prepocess data
  data_finalize(tail, latest_index);
  
  // Export Random
  data_export_random(tail, output_random);
  
  // Export data
  for(int i = 0; i < 16; i++){
    output_data[i] = hc_swap32_S(head[i]);
  }
  for(int i = 0; i < 16; i++){
    output_data[16+i] = tail[i]; // Already swapped
  }
}