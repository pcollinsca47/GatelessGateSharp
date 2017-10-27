using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.IO;
using System.Net;
using System.Net.Sockets;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using HashLib;


namespace GatelessGateSharp
{
    class EthashStratum : Stratum
    {
        public new class Work : Stratum.Work
        {
            private Job mJob;

            public new Job GetJob() { return mJob; }

            public Work(Job aJob)
                : base(aJob)
            {
                mJob = aJob;
            }
        }

        public const int WORD_BYTES = 4;                   // bytes in word
        public const int DATASET_BYTES_INIT = 1073741824;  // bytes in dataset at genesis
        public const int DATASET_BYTES_GROWTH = 8388608;   // dataset growth per epoch
        public const int CACHE_BYTES_INIT = 16777216;      // bytes in cache at genesis
        public const int CACHE_BYTES_GROWTH = 131072;      // cache growth per epoch
        public const int CACHE_MULTIPLIER = 1024;          // size of the DAG relative to the cache
        public const int EPOCH_LENGTH = 30000;             // blocks per epoch
        public const int MIX_BYTES = 128;                  // width of mix
        public const int HASH_BYTES = 64;                  // hash length in bytes
        public const int DATASET_PARENTS = 256;            // number of parents of each dataset element
        public const int CACHE_ROUNDS = 3;                 // number of rounds in cache production
        public const int ACCESSES = 64;                    // number of accesses in hashimoto loop

        public new class Job : Stratum.Job
        {
            private string mID;
            private string mSeedhash;
            private string mHeaderhash;

            public string ID { get { return mID; } }
            public string Seedhash { get { return mSeedhash; } }
            public string Headerhash { get { return mHeaderhash; } }

            public Job(string aID, string aSeedhash, string aHeaderhash) 
            {
                mID = aID;
                mSeedhash = aSeedhash;
                mHeaderhash = aHeaderhash;
            }

            public int Epoch
            {
                get
                {
                    byte[] seedhashArray = Utilities.StringToByteArray(Seedhash);
                    byte[] s = new byte[] { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
                    IHash hash = HashFactory.Crypto.SHA3.CreateKeccak256();
                    int i;
                    for (i = 0; i < 2048; ++i)
                    {
                        if (s.SequenceEqual(seedhashArray))
                            break;
                        s = hash.ComputeBytes(s).GetBytes();
                    }
                    if (i >= 2048)
                        throw new Exception("Invalid seedhash.");
                    return i;
                }
            }

            public static UInt32 FNV(UInt32 v1, UInt32 v2)
            {
                return (UInt32)((((UInt64)v1 * 0x01000193u) ^ v2) & 0xffffffffu);
            }

            public static byte[] CalculateDatasetItem(byte[] cache, int i)
            {
                // n = len(cache)
                int n = cache.Length / 64;
                // r = HASH_BYTES // WORD_BYTES
                int r = HASH_BYTES / WORD_BYTES;
                // # initialize the mix
                // mix = copy.copy(cache[i % n])
                byte[] mix = new byte[64];
                Buffer.BlockCopy(cache, i % n * 64, mix, 0, 64);
                // mix[0] ^= i
                mix[0] = (byte)((UInt32)mix[0] ^ (((UInt32)i >> 0) & 0xff));
                mix[1] = (byte)((UInt32)mix[1] ^ (((UInt32)i >> 8) & 0xff));
                mix[2] = (byte)((UInt32)mix[2] ^ (((UInt32)i >> 16) & 0xff));
                mix[3] = (byte)((UInt32)mix[3] ^ (((UInt32)i >> 24) & 0xff));
                // mix = sha3_512(mix)
                IHash hash = HashFactory.Crypto.SHA3.CreateKeccak512();
                mix = hash.ComputeBytes(mix).GetBytes();
                // # fnv it with a lot of random cache nodes based on i
                // for j in range(DATASET_PARENTS):
                for (int j = 0; j < DATASET_PARENTS; ++j)
                {
                    //     cache_index = fnv(i ^ j, mix[j % r])
                    UInt32 v1 = (UInt32)i ^ (UInt32)j;
                    int mixIndex = j % r * 4;
                    UInt32 v2 = ((UInt32)mix[mixIndex + 0] << 0) | ((UInt32)mix[mixIndex + 1] << 8) | ((UInt32)mix[mixIndex + 2] << 16) | ((UInt32)mix[mixIndex + 3] << 24);
                    UInt32 cacheIndex = (UInt32)FNV(v1, v2);
                    //     mix = map(fnv, mix, cache[cache_index % n])
                    for (int k = 0; k < 64; k += 4)
                    {
                        v1 = ((UInt32)mix[k + 0] << 0) | ((UInt32)mix[k + 1] << 8) | ((UInt32)mix[k + 2] << 16) | ((UInt32)mix[k + 3] << 24);
                        v2 = ((UInt32)cache[cacheIndex % n * 64 + k + 0] << 0)
                             | ((UInt32)cache[cacheIndex % n * 64 + k + 1] << 8)
                             | ((UInt32)cache[cacheIndex % n * 64 + k + 2] << 16)
                             | ((UInt32)cache[cacheIndex % n * 64 + k + 3] << 24);
                        UInt32 result = FNV(v1, v2);
                        for (int l = 0; l < 4; ++l)
                            mix[k + l] = (byte)((result >> (l * 8)) & 0xff);
                    }
                }
                // return sha3_512(mix)
                return hash.ComputeBytes(mix).GetBytes();
            }

            public String GetMixHash(UInt64 nonce)
            {
                IHash hash = HashFactory.Crypto.SHA3.CreateKeccak512();
                byte[] data;

                System.Diagnostics.Stopwatch sw = new System.Diagnostics.Stopwatch();
                sw.Start();

                // def hashimoto(header, nonce, full_size, dataset_lookup):
                int epoch = Epoch;
                byte[] seedhashArray = Utilities.StringToByteArray(Seedhash);
                byte[] headerhashArray = Utilities.StringToByteArray(Headerhash);                   
                DAGCache cache = new DAGCache(epoch, Seedhash);
                data = cache.GetData();
                long fullSize = Utilities.GetDAGSize(epoch);
                //     n = full_size / HASH_BYTES
                int n = (int)(fullSize / HASH_BYTES);
                //     w = MIX_BYTES // WORD_BYTES
                int w = MIX_BYTES / WORD_BYTES;
                //     mixhashes = MIX_BYTES / HASH_BYTES
                int mixhashes = MIX_BYTES / HASH_BYTES;
                //     # combine header+nonce into a 64 byte seed
                //     s = sha3_512(header + nonce[::-1])
                byte[] combined = new byte[headerhashArray.Length + sizeof(UInt64)];
                Buffer.BlockCopy(headerhashArray, 0, combined, 0, headerhashArray.Length);
                for (int i = 0; i < 8; ++i)
                    combined[headerhashArray.Length + i] = (byte)((nonce >> (i * 8)) & 0xff);
                byte[] s = hash.ComputeBytes(combined).GetBytes();
                //     # start the mix with replicated s
                //     mix = []
                //     for _ in range(MIX_BYTES / HASH_BYTES):
                //         mix.extend(s)
                byte[] mix = new byte[s.Length * mixhashes];
                for (int i = 0; i < mixhashes; ++i)
                    Buffer.BlockCopy(s, 0, mix, i * s.Length, s.Length);
                //     # mix in random dataset nodes
                //     for i in range(ACCESSES):
                for (int i = 0; i < ACCESSES; ++i)
                {
                    //         p = fnv(i ^ s[0], mix[i % w]) % (n // mixhashes) * mixhashes
                    UInt32 v1 = ((UInt32)s[0] ^ (UInt32)i) | ((UInt32)s[1] << 8) | ((UInt32)s[2] << 16) | ((UInt32)s[3] << 24);
                    int mixIndex = (i % w) * 4;
                    UInt32 v2 = ((UInt32)mix[mixIndex + 0] << 0) | ((UInt32)mix[mixIndex + 1] << 8) | ((UInt32)mix[mixIndex + 2] << 16) | ((UInt32)mix[mixIndex + 3] << 24);
                    int p = (int)(FNV(v1, v2) % (n / mixhashes) * mixhashes);
                    //         newdata = []
                    //         for j in range(MIX_BYTES / HASH_BYTES):
                    //             newdata.extend(dataset_lookup(p + j))
                    byte[] newData = new byte[s.Length * mixhashes];
                    for (int j = 0; j < mixhashes; ++j)
                    {
                        Buffer.BlockCopy(CalculateDatasetItem(data, p + j), 0, newData, j * (int)s.Length, (int)s.Length);
                    }
                    //         mix = map(fnv, mix, newdata)
                    for (int j = 0; j < s.Length * mixhashes; j += 4)
                    {
                        v1 = ((UInt32)mix[j + 0] << 0) | ((UInt32)mix[j + 1] << 8) | ((UInt32)mix[j + 2] << 16) | ((UInt32)mix[j + 3] << 24);
                        v2 = ((UInt32)newData[j + 0] << 0) | ((UInt32)newData[j + 1] << 8) | ((UInt32)newData[j + 2] << 16) | ((UInt32)newData[j + 3] << 24);
                        UInt32 result = FNV(v1, v2);
                        for (int k = 0; k < 4; ++k)
                            mix[j + k] = (byte)((result >> (k * 8)) & 0xff);
                    }

                }
                //     # compress mix
                //     cmix = []
                //     for i in range(0, len(mix), 4):
                //         cmix.append(fnv(fnv(fnv(mix[i], mix[i+1]), mix[i+2]), mix[i+3]))
                byte[] cmix = new byte[mix.Length / 4];
                for (int i = 0; i < mix.Length / 4; i += 4)
                {
                    UInt32 v1 = ((UInt32)mix[i * 4 + 0] << 0) | ((UInt32)mix[i * 4 + 1] << 8) | ((UInt32)mix[i * 4 + 2] << 16) | ((UInt32)mix[i * 4 + 3] << 24);
                    for (int j = 1; j < 4; ++j)
                    {
                        UInt32 v2 = ((UInt32)mix[(i + j) * 4 + 0] << 0) | ((UInt32)mix[(i + j) * 4 + 1] << 8) | ((UInt32)mix[(i + j) * 4 + 2] << 16) | ((UInt32)mix[(i + j) * 4 + 3] << 24);
                        v1 = FNV(v1, v2);
                    }
                    for (int j = 0; j < 4; ++j)
                        cmix[i + j] = (byte)((v1 >> (j * 8)) & 0xff);
                }
                //     return {
                //         "mix digest": serialize_hash(cmix),
                //         "result": serialize_hash(sha3_256(s+cmix))
                //     }
                sw.Stop();
                MainForm.Logger("Generated mix hash (" + (long)sw.Elapsed.TotalMilliseconds + "ms).");
                return Utilities.ByteArrayToString(cmix);
            }

            public bool Equals(Job aJob)
            {
                return (mID.Equals(aJob.mID));
            }
        }

        protected Job mJob = null;

        public Job CurrentJob { get { return mJob; } }

        public new Work GetWork()
        {
            return new Work(mJob);
        }

        public EthashStratum(String aServerAddress, int aServerPort, String aUsername, String aPassword) // "daggerhashimoto.usa.nicehash.com", 3353
            : base(aServerAddress, aServerPort, aUsername, aPassword)
        {
        }

        public virtual void Submit(Job job, UInt64 output) { }
    }
}
