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
    class OpenEthereumPoolEthashStratum : EthashStratum
    {
        public new class Work
        {
            private Job mJob;
            private byte mLocalExtranonce;

            public Job CurrentJob { get { return mJob; } }
            public byte LocalExtranonce { get { return mLocalExtranonce; } }

            public Work(Job aJob)
            {
                mJob = aJob;
                mLocalExtranonce = mJob.GetNewLocalExtranonce();
            }
        }

        public new class Job : EthashStratum.Job
        {
            private byte mExtranonce = 0;
            public byte Extranonce { get { return mExtranonce; } }

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
                if (line == "")
                    continue;

                Dictionary<String, Object> response = JsonConvert.DeserializeObject<Dictionary<string, Object>>(line);
                if (response.ContainsKey("result")
                    && response["result"] == null
                    && response.ContainsKey("error") && response["error"].GetType() == typeof(String))
                {
                    MainForm.Logger("Stratum server responded: " + (String)response["error"]);
                }
                else if (response.ContainsKey("result")
                    && response["result"] == null
                    && response.ContainsKey("error") && response["error"].GetType() == typeof(Newtonsoft.Json.Linq.JObject))
                {
                    MainForm.Logger("Stratum server responded: " + ((JContainer)response["error"])["message"]);
                }
                else if (response.ContainsKey("result")
                     && response["result"] == null)
                {
                    MainForm.Logger("Share #" + response["id"].ToString() + " rejected.");
                }
                else if (response.ContainsKey("result")
                    && response["result"] != null
                    && response["result"].GetType() == typeof(bool))
                {
                    if ((bool)response["result"])
                    {
                        MainForm.Logger("Share #" + response["id"].ToString() + " accepted.");
                    }
                    else if (response.ContainsKey("error") && response["error"].GetType() == typeof(String))
                    {
                        MainForm.Logger("Share #" + response["id"].ToString() + " rejected: " + (String)response["error"]);
                    }
                    else if (response.ContainsKey("error") && response["error"].GetType() == typeof(JArray))
                    {
                        MainForm.Logger("Share #" + response["id"].ToString() + " rejected: " + ((JArray)response["error"])["message"]);
                    }
                    else
                    {
                        MainForm.Logger("Unknown JSON message: " + line);
                    }
                }
                else if (response.ContainsKey("result")
                         && response["result"] != null
                         && response["result"].GetType() == typeof(JArray))
                {
                    var ID = response["id"];
                    JArray result = (JArray)response["result"];
                    mMutex.WaitOne();
                    System.Text.RegularExpressions.Regex regex = new System.Text.RegularExpressions.Regex(@"^0x");
                    mJob = (EthashStratum.Job)(new Job(
                        regex.Replace((string)result[0], ""), // Use headerhash as job ID.
                        regex.Replace((string)result[1], ""),
                        regex.Replace((string)result[0], "")));
                    regex = new System.Text.RegularExpressions.Regex(@"^0x(.*)................................................$");
                    mDifficulty = (double)0xffff0000U / (double)Convert.ToUInt64(regex.Replace((string)result[2], "$1"), 16);
                    mMutex.ReleaseMutex();
                    MainForm.Logger("Received new job: " + mJob.ID);
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
            mMutex.WaitOne();

            mClient = new TcpClient(ServerAddress, ServerPort);
            mStream = mClient.GetStream();
            mStreamReader = new StreamReader(mStream, System.Text.Encoding.ASCII, false);
            mStreamWriter = new StreamWriter(mStream, System.Text.Encoding.ASCII);
            mJsonRPCMessageID = 1;

            mStreamWriter.Write(Newtonsoft.Json.JsonConvert.SerializeObject(new Dictionary<string, Object> {
                { "id", mJsonRPCMessageID++ },
                { "jsonrpc", "2.0" },
                { "method", "eth_submitLogin" },
                { "params", new List<string> {
                    Username
            }}}));
            mStreamWriter.Write("\n");
            mStreamWriter.Flush();

            var response = JsonConvert.DeserializeObject<Dictionary<string, Object>>(mStreamReader.ReadLine());
            if (response["result"] == null)
            {
                mMutex.ReleaseMutex();
                throw new Exception("Authorization failed.");
            }
            
            mStreamWriter.Write(Newtonsoft.Json.JsonConvert.SerializeObject(new Dictionary<string, Object> {
                { "id", mJsonRPCMessageID++ },
                { "jsonrpc", "2.0" },
                { "method", "eth_getWork" }
            }));
            mStreamWriter.Write("\n");
            mStreamWriter.Flush();

            mMutex.ReleaseMutex();

            mStreamReaderThread = new Thread(new ThreadStart(StreamReaderThread));
            mStreamReaderThread.IsBackground = true;
            mStreamReaderThread.Start();
        }

        public override void Submit(EthashStratum.Job job, UInt64 output)
        {
            mMutex.WaitOne();
            try
            {
                String stringNonce
                      = String.Format("{7:x2}{6:x2}{5:x2}{4:x2}{3:x2}{2:x2}{1:x2}{0:x2}",
                                      ((output >> 0) & 0xff),
                                      ((output >> 8) & 0xff),
                                      ((output >> 16) & 0xff),
                                      ((output >> 24) & 0xff),
                                      ((output >> 32) & 0xff),
                                      ((output >> 40) & 0xff),
                                      ((output >> 48) & 0xff),
                                      ((output >> 56) & 0xff));
                String message = JsonConvert.SerializeObject(new Dictionary<string, Object> {
                    { "id", mJsonRPCMessageID++ },
                    { "jsonrpc", "2.0" },
                    { "method", "eth_submitWork" },
                    { "params", new List<string> {
                        "0x" + stringNonce,
                        "0x" + job.Headerhash, // The header's pow-hash (256 bits)
                        "0x" + job.GetMixHash(output) // mix digest
                }}});
                mStreamWriter.Write(message + "\n");
                mStreamWriter.Flush();
            }
            catch (Exception ex)
            {
                MainForm.Logger("Failed to submit share: " + ex.Message + ex.StackTrace);
            }
            mMutex.ReleaseMutex();
        }

        public OpenEthereumPoolEthashStratum(String aServerAddress, int aServerPort, String aUsername, String aPassword, String aPoolName)
            : base(aServerAddress, aServerPort, aUsername, aPassword, aPoolName)
        {
        }
    }
}
