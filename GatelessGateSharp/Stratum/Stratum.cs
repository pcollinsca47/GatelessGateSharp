using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GatelessGateSharp
{
    class Stratum
    {
        public class Job
        {
            private System.Threading.Mutex mMutex = new System.Threading.Mutex();
            private byte mLocalExtranonce = 0;

            public byte GetNewLocalExtranonce()
            {
                mMutex.WaitOne();
                byte ret = mLocalExtranonce++;
                mMutex.ReleaseMutex();
                return ret;
            }
        }

        public class Work
        {
            private Job mJob;
            private byte mLocalExtranonce;
            public byte LocalExtranonce { get { return mLocalExtranonce; } }
            public Job GetJob() { return mJob; }

            protected Work(Job aJob)
            {
                mJob = aJob;
                mLocalExtranonce = aJob.GetNewLocalExtranonce();
            }
        }

        protected Work GetWork()
        {
            return null;
        }

        private System.Threading.Mutex mMutex = new System.Threading.Mutex();
        private bool mStopped = false;
        String mServerAddress;
        int mServerPort;
        String mUsername;
        String mPassword;
        protected double mDifficulty = 1.0;
        protected String mPoolExtranonce = "";

        public bool Stopped { get { return mStopped; } }
        public String ServerAddress { get { return mServerAddress; } }
        public int ServerPort { get { return mServerPort; } }
        public String Username { get { return mUsername; } }
        public String Password { get { return mPassword; } }
        public String PoolExtranonce { get { return mPoolExtranonce; } }
        public double Difficulty { get { return mDifficulty; } }

        public void Stop()
        {
            mStopped = true;
        }

        public Stratum(String aServerAddress, int aServerPort, String aUsername, String aPassword) // "daggerhashimoto.usa.nicehash.com", 3353
        {
            mServerAddress = aServerAddress;
            mServerPort = aServerPort;
            mUsername = aUsername;
            mPassword = aPassword;

            Connect();
        }

        protected virtual void Connect() { }
    }
}
