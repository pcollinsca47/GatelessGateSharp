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
            private Job mJob;

            public Job CurrentJob { get { return mJob; } }

            public Work(Job aJob)
            {
                mJob = aJob;
            }
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
        public double Difficulty { get { return mDifficulty; } }
        public String Extranonce { get { return mExtranonce; } }

        private void StreamReaderThread()
        {
            string line;

            while ((line = mStreamReader.ReadLine()) != null)
            {
                Dictionary<String, Object> response = JsonConvert.DeserializeObject<Dictionary<string, Object>>(line);
                if (response.ContainsKey("method") && response.ContainsKey("params"))
                {
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
                        MainForm.Logger("Received new job (ID: " + parameters[0] + ").");
                        //MainForm.Logger("Seedhash: " + parameters[1]);
                        //MainForm.Logger("Headerhash: " + parameters[2]);
                    }
                    else if (method.Equals("mining.set_extranonce"))
                    {
                        mMutex.WaitOne();
                        mExtranonce = (String)parameters[0];
                        mMutex.ReleaseMutex();
                        MainForm.Logger("Received new extranonce: " + parameters[0]);
                    }
                    else if (method.Equals("client.reconnect"))
                    {
                        break;
                    }
                    else
                    {
                        MainForm.Logger("Unknown stratum method: " + line);
                    }
                }   
                else if (response.ContainsKey("id") && response.ContainsKey("result"))
                {
                    var ID = response["id"];
                    bool result = (bool)response["result"];

                    if (result) {
                        MainForm.Logger("Share #" + ID + " accepted.");
                    } else {
                        MainForm.Logger("Share #" + ID + " rejected: " + (String)(((JArray)response["error"])[1]));
                    }
                }
                else
                {
                    MainForm.Logger("Unknown JSON message: " + line);
                }
            }

            MainForm.Logger("Connection terminated. Reconnecting...");
            Thread reconnectThread = new Thread(new ThreadStart(Connect));
            reconnectThread.IsBackground = true;
            reconnectThread.Start();
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
            //MainForm.Logger("Subsciption ID: " + mSubsciptionID);
            //MainForm.Logger("Protocol Version: " + ((JArray)(((JArray)(response["result"]))[0]))[2]); // TODO: Check this.
            //MainForm.Logger("Extranonce: " + mExtranonce);

            // mining.extranonce.subscribe
            mStreamWriter.Write(JsonConvert.SerializeObject(new Dictionary<string, Object> {
                { "id", mJsonRPCMessageID++ },
                { "method", "mining.extranonce.subscribe" },
                { "params", new List<string> {
            }}}));
            mStreamWriter.Write("\n");
            mStreamWriter.Flush();
            response = JsonConvert.DeserializeObject<Dictionary<string, Object>>(mStreamReader.ReadLine());
            //MainForm.Logger("mining.extranonce.subscribe: " + response["result"]); // TODO
            
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
                throw new Exception("Authorization failed.");
            }

            mMutex.ReleaseMutex();

            mStreamReaderThread = new Thread(new ThreadStart(StreamReaderThread));
            mStreamReaderThread.IsBackground = true;
            mStreamReaderThread.Start();
        }

        public void Submit(String jobID, UInt64 output)
        {
            mMutex.WaitOne();
            try
            {
                String stringNonce
                      = ((Extranonce.Length == 2) ? (String.Format("{6:x2}{5:x2}{4:x2}{3:x2}{2:x2}{1:x2}{0:x2}", ((output >> 0) & 0xff), ((output >> 8) & 0xff), ((output >> 16) & 0xff), ((output >> 24) & 0xff), ((output >> 32) & 0xff), ((output >> 40) & 0xff), ((output >> 48) & 0xff))) :
                         (Extranonce.Length == 4) ? (String.Format("{5:x2}{4:x2}{3:x2}{2:x2}{1:x2}{0:x2}", ((output >> 0) & 0xff), ((output >> 8) & 0xff), ((output >> 16) & 0xff), ((output >> 24) & 0xff), ((output >> 32) & 0xff), ((output >> 40) & 0xff))) :
                                                    (String.Format("{4:x2}{3:x2}{2:x2}{1:x2}{0:x2}", ((output >> 0) & 0xff), ((output >> 8) & 0xff), ((output >> 16) & 0xff), ((output >> 24) & 0xff), ((output >> 32) & 0xff))));
                //      = ((Extranonce.Length == 2) ? (String.Format("{0:x2}{1:x2}{2:x2}{3:x2}{4:x2}{5:x2}{6:x2}", ((output >> 0) & 0xff), ((output >> 8) & 0xff), ((output >> 16) & 0xff), ((output >> 24) & 0xff), ((output >> 32) & 0xff), ((output >> 40) & 0xff), ((output >> 48) & 0xff))) :
                //         (Extranonce.Length == 4) ? (String.Format("{0:x2}{1:x2}{2:x2}{3:x2}{4:x2}{5:x2}",       ((output >> 0) & 0xff), ((output >> 8) & 0xff), ((output >> 16) & 0xff), ((output >> 24) & 0xff), ((output >> 32) & 0xff), ((output >> 40) & 0xff))) :
                //                                    (String.Format("{0:x2}{1:x2}{2:x2}{3:x2}{4:x2}",             ((output >> 0) & 0xff), ((output >> 8) & 0xff), ((output >> 16) & 0xff), ((output >> 24) & 0xff), ((output >> 32) & 0xff))));
                String message = JsonConvert.SerializeObject(new Dictionary<string, Object> {
                    { "id", mJsonRPCMessageID++ },
                    { "method", "mining.submit" },
                    { "params", new List<string> {
                        mUsername,
                        jobID,
                        stringNonce
                }}});
                mStreamWriter.Write(message + "\n");
                mStreamWriter.Flush();
                //MainForm.Logger("message: " + message);
            }
            catch (Exception ex)
            {
                MainForm.Logger("Failed to submit share: " + ex.Message);
            }
            mMutex.ReleaseMutex();
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
            return new Work(mJob);
        }
    }
}
