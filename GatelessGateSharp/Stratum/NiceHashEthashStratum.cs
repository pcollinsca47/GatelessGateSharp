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
    class NiceHashEthashStratum : EthashStratum
    {
        public new class Work : EthashStratum.Work
        {
            private Job mJob;

            public Job GetJob() { return mJob; }

            public Work(Job aJob)
                : base(aJob)
            {
                mJob = aJob;
            }
        }

        public new class Job : EthashStratum.Job
        {
            public Job(string aID, string aSeedhash, string aHeaderhash) 
                : base(aID, aSeedhash, aHeaderhash)
            {
            }
        }

        TcpClient mClient;
        NetworkStream mStream;
        StreamReader mStreamReader;
        StreamWriter mStreamWriter;
        Thread mStreamReaderThread;
        int mJsonRPCMessageID = 1;
        string mSubsciptionID;
        private Mutex mMutex = new Mutex();

        private void StreamReaderThread()
        {
            string line;

            while (!Stopped)
            {
                try
                {
                    if ((line = mStreamReader.ReadLine()) == null)
                        throw new Exception("Disconnected from stratum server.");
                }
                catch (Exception ex)
                {
                    MainForm.Logger("Failed to receive data from stratum server: " + ex.Message);
                    break;
                }
                if (Stopped)
                    break;

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
                        mJob = (EthashStratum.Job)(new Job((string)parameters[0], (string)parameters[1], (string)parameters[2]));
                        mMutex.ReleaseMutex();
                        MainForm.Logger("Received new job: " + parameters[0]);
                    }
                    else if (method.Equals("mining.set_extranonce"))
                    {
                        mMutex.WaitOne();
                        mPoolExtranonce = (String)parameters[0];
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

            if (Stopped)
            {
                try
                {
                    mClient.Close();
                }
                catch (Exception ex) { }
            }
            else
            {
                MainForm.Logger("Connection terminated. Reconnecting...");
                Thread reconnectThread = new Thread(new ThreadStart(Connect));
                reconnectThread.IsBackground = true;
                reconnectThread.Start();
            }
        }

        override protected void Connect()
        {
            if (Stopped)
                return;

            mMutex.WaitOne();

            mClient = new TcpClient(ServerAddress, ServerPort);
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
            mPoolExtranonce = (string)(((JArray)(response["result"]))[1]);
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
                    Username,
                    Password
            }}}));
            mStreamWriter.Write("\n");
            mStreamWriter.Flush();
            response = JsonConvert.DeserializeObject<Dictionary<string, Object>>(mStreamReader.ReadLine());
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

        public override void Submit(EthashStratum.Job job, UInt64 output)
        {
            if (Stopped)
                return;

            mMutex.WaitOne();
            try
            {
                String stringNonce
                      = ((PoolExtranonce.Length == 0) ? (String.Format("{7:x2}{6:x2}{5:x2}{4:x2}{3:x2}{2:x2}{1:x2}{0:x2}", ((output >> 0) & 0xff), ((output >> 8) & 0xff), ((output >> 16) & 0xff), ((output >> 24) & 0xff), ((output >> 32) & 0xff), ((output >> 40) & 0xff), ((output >> 48) & 0xff), ((output >> 56) & 0xff))) :
                         (PoolExtranonce.Length == 2) ? (String.Format("{6:x2}{5:x2}{4:x2}{3:x2}{2:x2}{1:x2}{0:x2}", ((output >> 0) & 0xff), ((output >> 8) & 0xff), ((output >> 16) & 0xff), ((output >> 24) & 0xff), ((output >> 32) & 0xff), ((output >> 40) & 0xff), ((output >> 48) & 0xff))) :
                         (PoolExtranonce.Length == 4) ? (String.Format("{5:x2}{4:x2}{3:x2}{2:x2}{1:x2}{0:x2}", ((output >> 0) & 0xff), ((output >> 8) & 0xff), ((output >> 16) & 0xff), ((output >> 24) & 0xff), ((output >> 32) & 0xff), ((output >> 40) & 0xff))) :
                                                        (String.Format("{4:x2}{3:x2}{2:x2}{1:x2}{0:x2}", ((output >> 0) & 0xff), ((output >> 8) & 0xff), ((output >> 16) & 0xff), ((output >> 24) & 0xff), ((output >> 32) & 0xff))));
                //      = ((Extranonce.Length == 2) ? (String.Format("{0:x2}{1:x2}{2:x2}{3:x2}{4:x2}{5:x2}{6:x2}", ((output >> 0) & 0xff), ((output >> 8) & 0xff), ((output >> 16) & 0xff), ((output >> 24) & 0xff), ((output >> 32) & 0xff), ((output >> 40) & 0xff), ((output >> 48) & 0xff))) :
                //         (Extranonce.Length == 4) ? (String.Format("{0:x2}{1:x2}{2:x2}{3:x2}{4:x2}{5:x2}",       ((output >> 0) & 0xff), ((output >> 8) & 0xff), ((output >> 16) & 0xff), ((output >> 24) & 0xff), ((output >> 32) & 0xff), ((output >> 40) & 0xff))) :
                //                                    (String.Format("{0:x2}{1:x2}{2:x2}{3:x2}{4:x2}",             ((output >> 0) & 0xff), ((output >> 8) & 0xff), ((output >> 16) & 0xff), ((output >> 24) & 0xff), ((output >> 32) & 0xff))));
                String message = JsonConvert.SerializeObject(new Dictionary<string, Object> {
                    { "id", mJsonRPCMessageID++ },
                    { "method", "mining.submit" },
                    { "params", new List<string> {
                        Username,
                        job.ID,
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

        public NiceHashEthashStratum(String aServerAddress, int aServerPort, String aUsername, String aPassword, String aPoolName) // "daggerhashimoto.usa.nicehash.com", 3353
            : base(aServerAddress, aServerPort, aUsername, aPassword, aPoolName)
        {
        }
    }
}
