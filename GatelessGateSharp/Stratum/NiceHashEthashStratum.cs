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
    class NiceHashEthashStratum : Stratum
    {
        public new class Work : Stratum.Work
        {
        }

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

            public static string ByteArrayToString(byte[] ba)
            {
                StringBuilder hex = new StringBuilder(ba.Length * 2);
                foreach (byte b in ba)
                    hex.AppendFormat("{0:x2}", b);
                return hex.ToString();
            }

            public static byte[] StringToByteArray(String hex)
            {
                int NumberChars = hex.Length;
                byte[] bytes = new byte[NumberChars / 2];
                for (int i = 0; i < NumberChars; i += 2)
                    bytes[i / 2] = Convert.ToByte(hex.Substring(i, 2), 16);
                return bytes;
            }

            public int Epoch {
                get {
                    byte[] seedhashArray = StringToByteArray(Seedhash);
                    byte[] s = new byte[] { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
                    IHash hash = HashFactory.Crypto.SHA3.CreateKeccak256();
                    int i;
                    for (i = 0; i < 2048; ++i)
                    {
                        s = hash.ComputeBytes(s).GetBytes();
                        if (s.SequenceEqual(seedhashArray))
                            break;
                    }
                    if (i >= 2048)
                        throw new Exception("Invalid seedhash.");
                    return i + 1;
                }
            }
 
            public bool Equals(Job aJob)
            {
                return (mID.Equals(aJob.mID));
            }
        }

        String mServerAddress;
        int mServerPort;
        String mUsername;
        String mPassword;
        TcpClient mClient;
        NetworkStream mStream;
        StreamReader mStreamReader;
        StreamWriter mStreamWriter;
        Thread mStreamReaderThread;
        int mJsonRPCMessageID = 1;
        double mDifficulty = 1.0;
        string mSubsciptionID;
        string mExtranonce;
        Job mJob = null;
        private Mutex mMutex = new Mutex();

        public Job CurrentJob { get { return mJob; } }

        private void StreamReaderThread()
        {
            string line;

            while ((line = mStreamReader.ReadLine()) != null)
            {
                Dictionary<String, Object> response = JsonConvert.DeserializeObject<Dictionary<string, Object>>(line);
                string method = (string)response["method"];
                JArray parameters = (JArray)response["params"];
                if (method.Equals("mining.set_difficulty"))
                {
                    mMutex.WaitOne();
                    mDifficulty = (double)parameters[0];
                    mMutex.ReleaseMutex();
                    MainForm.Logger("Difficulty set to " + (double)parameters[0] + ".");
                }
                else if (method.Equals("mining.notify"))
                {
                    mMutex.WaitOne();
                    mJob = new Job((string)parameters[0], (string)parameters[1], (string)parameters[2]);
                    mMutex.ReleaseMutex();
                    MainForm.Logger("Job ID: " + parameters[0]);
                    MainForm.Logger("Seedhash: " + parameters[1]);
                    MainForm.Logger("Headerhash: " + parameters[2]);
                }
                else if (method.Equals("mining.reconnect"))
                {
                    Connect();
                }
                else
                {
                    MainForm.Logger("Unknown stratum method: " + line);
                }
            }
            MainForm.Logger("Connection terminated.");
        }

        public void Connect()
        {
            mMutex.WaitOne();

            mClient = new TcpClient(mServerAddress, mServerPort);
            mStream = mClient.GetStream();
            mStreamReader = new StreamReader(mStream, System.Text.Encoding.ASCII, false);
            mStreamWriter = new StreamWriter(mStream, System.Text.Encoding.ASCII);
            mJsonRPCMessageID = 1;

            mStreamWriter.Write(Newtonsoft.Json.JsonConvert.SerializeObject(new Dictionary<string, Object> {
                { "id", mJsonRPCMessageID++ },
                { "method", "mining.subscribe" },
                { "params", new List<string> {
                    "GatelessGateSharp/0.0.1",
                    "EthereumStratum/1.0.0"
            }}}));
            mStreamWriter.Write("\n");
            mStreamWriter.Flush();

            Dictionary<String, Object> response = JsonConvert.DeserializeObject<Dictionary<string, Object> >(mStreamReader.ReadLine());
            mSubsciptionID = (string)(((JArray)(((JArray)(response["result"]))[0]))[1]);
            mExtranonce = (string)(((JArray)(response["result"]))[1]);
            MainForm.Logger("Subsciption ID: " + mSubsciptionID);
            MainForm.Logger("Protocol Version: " + ((JArray)(((JArray)(response["result"]))[0]))[2]); // TODO: Check this.
            MainForm.Logger("Extranonce: " + mExtranonce);

            mStreamWriter.Write(JsonConvert.SerializeObject(new Dictionary<string, Object> {
                { "id", mJsonRPCMessageID++ },
                { "method", "mining.authorize" },
                { "params", new List<string> {
                    mUsername,
                    mPassword
            }}}));
            mStreamWriter.Write("\n");
            mStreamWriter.Flush();

            response = JsonConvert.DeserializeObject<Dictionary<string, Object>>(mStreamReader.ReadLine());
            MainForm.Logger("Authorized: " + response["result"]); // TODO
            if (!(bool)response["result"])
            {
                mMutex.ReleaseMutex();
                throw new Exception("Authentication failed.");
            }

            mMutex.ReleaseMutex();

            mStreamReaderThread = new Thread(new ThreadStart(StreamReaderThread));
            mStreamReaderThread.IsBackground = true;
            mStreamReaderThread.Start();
        }

        public NiceHashEthashStratum(String aServerAddress, int aServerPort, String aUsername, String aPassword) // "daggerhashimoto.usa.nicehash.com", 3353
        {
            mServerAddress = aServerAddress;
            mServerPort = aServerPort;
            mUsername = aUsername;
            mPassword = aPassword;

            Connect();
        }

        public new Work GetWork()
        {
            return null;
        }
    }
}
