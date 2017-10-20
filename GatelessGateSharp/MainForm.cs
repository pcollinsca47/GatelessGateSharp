// Copyright 2017 Yurio Miyazawa (a.k.a zawawa)
//
// This file is part of Gateless Gate #.
//
// Gateless Gate # is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Gateless Gate # is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Gateless Gate #.  If not, see <http://www.gnu.org/licenses/>.



using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SQLite;
using System.Collections;
using System.Runtime.InteropServices;
using Cloo;
using ATI.ADL;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;



namespace GatelessGateSharp
{
    unsafe public partial class MainForm : Form
    {
        [DllImport("phymem_wrapper.dll")]
        extern public static int LoadPhyMemDriver();
        [DllImport("phymem_wrapper.dll")]
        extern public static void UnloadPhyMemDriver();

        private static MainForm instance;
        public static String appName = "Gateless Gate #";
        private static String databaseFileName = "GatelessGateSharp.sqlite";
        private static String logFileName = "GatelessGateSharp.log";
        private System.Threading.Mutex loggerMutex = new System.Threading.Mutex();
        private Control[] labelGPUVendorArray;
        private Control[] labelGPUNameArray;
        private Control[] labelGPUIDArray;
        private Control[] labelGPUSpeedArray;
        private Control[] labelGPUTempArray;
        private Control[] labelGPUActivityArray;
        private Control[] labelGPUFanArray;
        private Control[] labelGPUCoreClockArray;
        private Control[] labelGPUMemoryClockArray;
        private ComputeDevice[] computeDeviceArray;
        private const int computeDeviceArrayMaxLength = 8; // This depends on MainForm.
        private Boolean ADLInitialized = false;
        private Int32[] ADLAdapterIndexArray;
        private System.Threading.Mutex ADLMutex = new System.Threading.Mutex();

        public static MainForm Instance { get { return instance; }}

        public static void Logger(String lines)
        {
            Instance.loggerMutex.WaitOne();
            System.IO.StreamWriter file = new System.IO.StreamWriter(logFileName, true);
            file.WriteLine(lines);
            file.Close();
            Instance.loggerMutex.ReleaseMutex();

            Instance.richTextBoxLog.Invoke((MethodInvoker)delegate
            {
                Instance.loggerMutex.WaitOne();
                Instance.richTextBoxLog.SelectionLength = 0;
                Instance.richTextBoxLog.SelectionStart = Instance.richTextBoxLog.Text.Length;
                Instance.richTextBoxLog.ScrollToCaret();
                if (Instance.richTextBoxLog.Text != "")
                    Instance.richTextBoxLog.Text += "\n";
                Instance.richTextBoxLog.Text += lines;
                Instance.richTextBoxLog.SelectionLength = 0;
                Instance.richTextBoxLog.SelectionStart = Instance.richTextBoxLog.Text.Length;
                Instance.richTextBoxLog.ScrollToCaret();
                Instance.loggerMutex.ReleaseMutex();
            });
        }

        unsafe public MainForm()
        {
            instance = this;

            InitializeComponent();
        }
        
        private void CreateNewDatabase()
        {
            SQLiteConnection.CreateFile(databaseFileName);
            SQLiteConnection conn = new SQLiteConnection("Data Source=" + databaseFileName + ";Version=3;");
            conn.Open();
            String sql = "create table wallet_addresses (coin varchar(128), address varchar(128));";
            SQLiteCommand command = new SQLiteCommand(sql, conn);
            command.ExecuteNonQuery();
            conn.Close();
        }

        private void LoadDatabase()
        {
            SQLiteConnection conn = new SQLiteConnection("Data Source=" + databaseFileName + ";Version=3;");
            conn.Open();
            String sql = "select * from wallet_addresses";
            SQLiteCommand command = new SQLiteCommand(sql, conn);
            SQLiteDataReader reader = command.ExecuteReader();
            while (reader.Read())
            {
                if ((String)reader["coin"] == "bitcoin")
                {
                    textBoxBitcoinAddress.Text = (String)reader["address"];
                }
                else if ((String)reader["coin"] == "ethereum")
                {
                    textBoxEthereumAddress.Text = (String)reader["address"];
                }
                else if ((String)reader["coin"] == "monero")
                {
                    textBoxMoneroAddress.Text = (String)reader["address"];
                }
                else if ((String)reader["coin"] == "zcash")
                {
                    textBoxZcashAddress.Text = (String)reader["address"];
                }
            }
            conn.Close();
        }

        private void UpdateDatabase()
        {
            SQLiteConnection conn = new SQLiteConnection("Data Source=" + databaseFileName + ";Version=3;");
            conn.Open();
            String sql = "delete from wallet_addresses";
            SQLiteCommand command = new SQLiteCommand(sql, conn);
            command.ExecuteNonQuery();

            sql = "insert into wallet_addresses (coin, address) values (@coin, @address)";
            command = new SQLiteCommand(sql, conn);
            command.Parameters.AddWithValue("@coin", "bitcoin");
            command.Parameters.AddWithValue("@address", textBoxBitcoinAddress.Text);
            command.ExecuteNonQuery();
            command = new SQLiteCommand(sql, conn);
            command.Parameters.AddWithValue("@coin", "ethereum");
            command.Parameters.AddWithValue("@address", textBoxEthereumAddress.Text);
            command.ExecuteNonQuery();
            command = new SQLiteCommand(sql, conn);
            command.Parameters.AddWithValue("@coin", "monero");
            command.Parameters.AddWithValue("@address", textBoxMoneroAddress.Text);
            command.ExecuteNonQuery();
            command = new SQLiteCommand(sql, conn);
            command.Parameters.AddWithValue("@coin", "zcash");
            command.Parameters.AddWithValue("@address", textBoxZcashAddress.Text);
            command.ExecuteNonQuery();
            
            conn.Close();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            Logger(appName + " started.");
            labelGPUVendorArray = new Control[] { labelGPU0Vendor, labelGPU1Vendor, labelGPU2Vendor, labelGPU3Vendor, labelGPU4Vendor, labelGPU5Vendor, labelGPU6Vendor, labelGPU7Vendor };
            labelGPUNameArray = new Control[] { labelGPU0Name, labelGPU1Name, labelGPU2Name, labelGPU3Name, labelGPU4Name, labelGPU5Name, labelGPU6Name, labelGPU7Name };
            labelGPUIDArray = new Control[] { labelGPU0ID, labelGPU1ID, labelGPU2ID, labelGPU3ID, labelGPU4ID, labelGPU5ID, labelGPU6ID, labelGPU7ID };
            labelGPUTempArray = new Control[] { labelGPU0Temp, labelGPU1Temp, labelGPU2Temp, labelGPU3Temp, labelGPU4Temp, labelGPU5Temp, labelGPU6Temp, labelGPU7Temp };
            labelGPUActivityArray = new Control[] { labelGPU0Activity, labelGPU1Activity, labelGPU2Activity, labelGPU3Activity, labelGPU4Activity, labelGPU5Activity, labelGPU6Activity, labelGPU7Activity };
            labelGPUFanArray = new Control[] { labelGPU0Fan, labelGPU1Fan, labelGPU2Fan, labelGPU3Fan, labelGPU4Fan, labelGPU5Fan, labelGPU6Fan, labelGPU7Fan };
            labelGPUSpeedArray = new Control[] { labelGPU0Speed, labelGPU1Speed, labelGPU2Speed, labelGPU3Speed, labelGPU4Speed, labelGPU5Speed, labelGPU6Speed, labelGPU7Speed };
            labelGPUCoreClockArray = new Control[] { labelGPU0CoreClock, labelGPU1CoreClock, labelGPU2CoreClock, labelGPU3CoreClock, labelGPU4CoreClock, labelGPU5CoreClock, labelGPU6CoreClock, labelGPU7CoreClock };
            labelGPUMemoryClockArray = new Control[] { labelGPU0MemoryClock, labelGPU1MemoryClock, labelGPU2MemoryClock, labelGPU3MemoryClock, labelGPU4MemoryClock, labelGPU5MemoryClock, labelGPU6MemoryClock, labelGPU7MemoryClock };

            if (LoadPhyMemDriver() != 0)
            {
                Logger("Successfully loaded phymem.");
            }
            else
            {
                Logger("Failed to load phymem.");
                MessageBox.Show("Failed to load phymem.", appName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                System.Environment.Exit(1);
            }

            if (!System.IO.File.Exists(databaseFileName))
                CreateNewDatabase();
            LoadDatabase();
            InitializeDevices();
        }

        private void InitializeDevices()
        {
            ArrayList computeDeviceArrayList = new ArrayList();

            foreach (ComputePlatform platform in ComputePlatform.Platforms)
            {
                IList<ComputeDevice> devices = platform.Devices;
                ComputeContextPropertyList properties = new ComputeContextPropertyList(platform);
                ComputeContext context = new ComputeContext(devices, properties, null, IntPtr.Zero);

                foreach (ComputeDevice device in context.Devices)
                {
                    if (device.Vendor == "Intel Corporation"
                        || device.Vendor == "GenuineIntel"
                        || device.Type == ComputeDeviceTypes.Cpu)
                        continue;
                    computeDeviceArrayList.Add(device);
                }
            }
            computeDeviceArray = Array.ConvertAll(computeDeviceArrayList.ToArray(), item => (Cloo.ComputeDevice)item);
            Logger("Number of Devices: " + computeDeviceArray.Length);

            int index = 0;
            foreach (ComputeDevice device in computeDeviceArray)
            {
                labelGPUVendorArray[index].Text = (device.Vendor == "Advanced Micro Devices, Inc.") ? "AMD" :
                                                  (device.Vendor == "NVIDIA Corporation") ? "NVIDIA" :
                                                  (device.Vendor == "Intel Corporation") ? "Intel" :
                                                  (device.Vendor == "GenuineIntel") ? "Intel" :
                                                  device.Vendor;
                labelGPUNameArray[index].Text = device.Name;

                labelGPUSpeedArray[index].Text = "-";
                labelGPUActivityArray[index].Text = "-";
                labelGPUTempArray[index].Text = "-";
                labelGPUFanArray[index].Text = "-";
 
                ++index;
            }

            for (; index < computeDeviceArrayMaxLength; ++index)
            {
                labelGPUVendorArray[index].Visible = false;
                labelGPUNameArray[index].Visible = false;
                labelGPUIDArray[index].Visible = false;
                labelGPUSpeedArray[index].Visible = false;
                labelGPUActivityArray[index].Visible = false;
                labelGPUTempArray[index].Visible = false;
                labelGPUFanArray[index].Visible = false;
                labelGPUCoreClockArray[index].Visible = false;
                labelGPUMemoryClockArray[index].Visible = false;
            }

            int ADLRet = -1;
            int NumberOfAdapters = 0;
            ADLAdapterIndexArray = new Int32[computeDeviceArray.Length];
            for (int i = 0; i < computeDeviceArray.Length; i++)
                ADLAdapterIndexArray[i] = -1;
            if (null != ADL.ADL_Main_Control_Create)
                ADLRet = ADL.ADL_Main_Control_Create(ADL.ADL_Main_Memory_Alloc, 1);
            if (ADL.ADL_SUCCESS == ADLRet)
            {
                Logger("Successfully initialized AMD Display Library.");
                ADLInitialized = true;
                if (null != ADL.ADL_Adapter_NumberOfAdapters_Get)
                {
                    ADL.ADL_Adapter_NumberOfAdapters_Get(ref NumberOfAdapters);
                }
                Logger("Number of ADL Adapters: " + NumberOfAdapters.ToString());

                if (0 < NumberOfAdapters)
                {
                    ADLAdapterInfoArray OSAdapterInfoData;
                    OSAdapterInfoData = new ADLAdapterInfoArray();

                    if (null != ADL.ADL_Adapter_AdapterInfo_Get)
                    {
                        IntPtr AdapterBuffer = IntPtr.Zero;
                        int size = Marshal.SizeOf(OSAdapterInfoData);
                        AdapterBuffer = Marshal.AllocCoTaskMem((int)size);
                        Marshal.StructureToPtr(OSAdapterInfoData, AdapterBuffer, false);

                        if (null != ADL.ADL_Adapter_AdapterInfo_Get)
                        {
                            ADLRet = ADL.ADL_Adapter_AdapterInfo_Get(AdapterBuffer, size);
                            if (ADL.ADL_SUCCESS == ADLRet)
                            {
                                OSAdapterInfoData = (ADLAdapterInfoArray)Marshal.PtrToStructure(AdapterBuffer, OSAdapterInfoData.GetType());
                                int IsActive = 0;

                                int deviceIndex = 0;
                                foreach (ComputeDevice device in computeDeviceArray)
                                {
                                    if (device.Vendor == "Advanced Micro Devices, Inc.")
                                    {
                                        ComputeDevice.cl_device_topology_amd topology = device.TopologyAMD;
                                        for (int i = 0; i < NumberOfAdapters; i++)
                                        {
                                            if (null != ADL.ADL_Adapter_Active_Get)
                                                ADLRet = ADL.ADL_Adapter_Active_Get(OSAdapterInfoData.ADLAdapterInfo[i].AdapterIndex, ref IsActive);
                                            if (OSAdapterInfoData.ADLAdapterInfo[i].BusNumber == topology.bus
                                                && (ADLAdapterIndexArray[deviceIndex] < 0 || IsActive != 0))
                                            {
                                                ADLAdapterIndexArray[deviceIndex] = OSAdapterInfoData.ADLAdapterInfo[i].AdapterIndex;
                                                String adapterName = OSAdapterInfoData.ADLAdapterInfo[i].AdapterName;
                                                adapterName = adapterName.Replace("(TM)", "");
                                                adapterName = adapterName.Replace(" Series", "");
                                                labelGPUNameArray[deviceIndex].Text = adapterName;
                                            }
                                        }
                                    }
                                    ++deviceIndex;
                                }
                            }
                            else
                            {
                                Logger("ADL_Adapter_AdapterInfo_Get() returned error code " + ADLRet.ToString());
                            }
                        }
                        // Release the memory for the AdapterInfo structure
                        if (IntPtr.Zero != AdapterBuffer)
                            Marshal.FreeCoTaskMem(AdapterBuffer);
                    } 
                }
            }
            else
            {
                Logger("Failed to initialize AMD Display Library.");
            }

            UpdateDeviceStatus();
            timerDeviceStatusUpdates.Enabled = true;
            UpdateCurrencyStats();
            timerCurrencyStatUpdates.Enabled = true;
        }

        private void UpdateCurrencyStats()
        {
            double balance = 0;
            try
            {
                var client = new System.Net.WebClient();
                String jsonString = client.DownloadString("https://api.nicehash.com/api?method=stats.provider&addr=" + textBoxBitcoinAddress.Text);
                var response = JsonConvert.DeserializeObject<Dictionary<string, Object>>(jsonString);
                var result = (JContainer)(response["result"]);
                var stats = (JArray)(result["stats"]);
                foreach (JContainer item in stats)
                    balance += Double.Parse((String)item["balance"]);

                jsonString = client.DownloadString("https://blockchain.info/ticker");
                response = JsonConvert.DeserializeObject<Dictionary<string, Object>>(jsonString);
                var USD = (JContainer)(response["USD"]);
                var rate = (double)(USD["15m"]);

                labelBalance.Text = balance.ToString() + " BTC (" + String.Format("{0:N2}", (balance * rate)) + " USD)";
            }
            catch (Exception _)
            {
                labelBalance.Text = "-";
            }
        }

        private void UpdateDeviceStatus()
        {
            double totalSpeed = 0;
            if (mMiners != null)
                foreach (Miner miner in mMiners)
                    totalSpeed += miner.Speed;
            labelCurrentSpeed.Text = (appState != ApplicationGlobalState.Mining) ? "-" : String.Format("{0:N2} Mh/s", totalSpeed / 1000000);

            ADLMutex.WaitOne();
            int deviceIndex = 0;
            foreach (ComputeDevice device in computeDeviceArray)
            {
                double speed = 0;
                if (mMiners != null)
                    foreach (Miner miner in mMiners)
                        if (miner.DeviceIndex == deviceIndex)
                            speed += miner.Speed;
                labelGPUSpeedArray[deviceIndex].Text = (appState != ApplicationGlobalState.Mining) ? "-" : String.Format("{0:N2} Mh/s", speed / 1000000);

                if (ADLAdapterIndexArray[deviceIndex] >= 0)
                {
                    // temperature
                    ADLTemperature OSADLTemperatureData;
                    OSADLTemperatureData = new ADLTemperature();
                    IntPtr tempBuffer = IntPtr.Zero;
                    int size = Marshal.SizeOf(OSADLTemperatureData);
                    tempBuffer = Marshal.AllocCoTaskMem((int)size);
                    Marshal.StructureToPtr(OSADLTemperatureData, tempBuffer, false);

                    if (null != ADL.ADL_Overdrive5_Temperature_Get)
                    {
                        int ADLRet = ADL.ADL_Overdrive5_Temperature_Get(ADLAdapterIndexArray[deviceIndex], 0, tempBuffer);
                        if (ADL.ADL_SUCCESS == ADLRet)
                        {
                            OSADLTemperatureData = (ADLTemperature)Marshal.PtrToStructure(tempBuffer, OSADLTemperatureData.GetType());
                            labelGPUTempArray[deviceIndex].Text = (OSADLTemperatureData.Temperature / 1000).ToString() + "℃";
                            labelGPUTempArray[deviceIndex].ForeColor = (OSADLTemperatureData.Temperature >= 80000) ? Color.Red :
                                                                       (OSADLTemperatureData.Temperature >= 60000) ? Color.Purple :
                                                                                                                     Color.Blue;
                        }
                    }

                    // activity
                    ADLPMActivity OSADLPMActivityData;
                    OSADLPMActivityData = new ADLPMActivity();
                    IntPtr activityBuffer = IntPtr.Zero;
                    size = Marshal.SizeOf(OSADLPMActivityData);
                    activityBuffer = Marshal.AllocCoTaskMem((int)size);
                    Marshal.StructureToPtr(OSADLPMActivityData, activityBuffer, false);

                    if (null != ADL.ADL_Overdrive5_CurrentActivity_Get)
                    {
                        int ADLRet = ADL.ADL_Overdrive5_CurrentActivity_Get(ADLAdapterIndexArray[deviceIndex], activityBuffer);
                        if (ADL.ADL_SUCCESS == ADLRet)
                        {
                            OSADLPMActivityData = (ADLPMActivity)Marshal.PtrToStructure(activityBuffer, OSADLPMActivityData.GetType());
                            labelGPUActivityArray[deviceIndex].Text = OSADLPMActivityData.iActivityPercent.ToString() + "%";
                            labelGPUCoreClockArray[deviceIndex].Text = (OSADLPMActivityData.iEngineClock / 100).ToString() + " MHz";
                            labelGPUMemoryClockArray[deviceIndex].Text = (OSADLPMActivityData.iMemoryClock / 100).ToString() + " MHz";
                        }
                    }

                    // fan speed
                    ADLFanSpeedValue OSADLFanSpeedValueData;
                    OSADLFanSpeedValueData = new ADLFanSpeedValue();
                    IntPtr fanSpeedValueBuffer = IntPtr.Zero;
                    size = Marshal.SizeOf(OSADLFanSpeedValueData);
                    OSADLFanSpeedValueData.iSpeedType = 1;
                    fanSpeedValueBuffer = Marshal.AllocCoTaskMem((int)size);
                    Marshal.StructureToPtr(OSADLFanSpeedValueData, fanSpeedValueBuffer, false);

                    if (null != ADL.ADL_Overdrive5_FanSpeed_Get)
                    {
                        int ADLRet = ADL.ADL_Overdrive5_FanSpeed_Get(ADLAdapterIndexArray[deviceIndex], 0, fanSpeedValueBuffer);
                        if (ADL.ADL_SUCCESS == ADLRet)
                        {
                            OSADLFanSpeedValueData = (ADLFanSpeedValue)Marshal.PtrToStructure(fanSpeedValueBuffer, OSADLFanSpeedValueData.GetType());
                            labelGPUFanArray[deviceIndex].Text = OSADLFanSpeedValueData.iFanSpeed.ToString() + "%";
                        }
                    }
                }
                ++deviceIndex;
            }
            ADLMutex.ReleaseMutex();
        }

        private void DumpADLInfo()
        {
            int ADLRet = -1;
            int NumberOfAdapters = 0;
            int NumberOfDisplays = 0;

            if (null != ADL.ADL_Adapter_NumberOfAdapters_Get)
            {
                ADL.ADL_Adapter_NumberOfAdapters_Get(ref NumberOfAdapters);
            }

            // Get OS adpater info from ADL
            ADLAdapterInfoArray OSAdapterInfoData;
            OSAdapterInfoData = new ADLAdapterInfoArray();

            if (null != ADL.ADL_Adapter_AdapterInfo_Get)
            {
                IntPtr AdapterBuffer = IntPtr.Zero;
                int size = Marshal.SizeOf(OSAdapterInfoData);
                AdapterBuffer = Marshal.AllocCoTaskMem((int)size);
                Marshal.StructureToPtr(OSAdapterInfoData, AdapterBuffer, false);

                if (null != ADL.ADL_Adapter_AdapterInfo_Get)
                {
                    ADLRet = ADL.ADL_Adapter_AdapterInfo_Get(AdapterBuffer, size);
                    if (ADL.ADL_SUCCESS == ADLRet)
                    {
                        OSAdapterInfoData = (ADLAdapterInfoArray)Marshal.PtrToStructure(AdapterBuffer, OSAdapterInfoData.GetType());
                        int IsActive = 0;

                        for (int i = 0; i < NumberOfAdapters; i++)
                        {
                            // Check if the adapter is active
                            if (null != ADL.ADL_Adapter_Active_Get)
                                ADLRet = ADL.ADL_Adapter_Active_Get(OSAdapterInfoData.ADLAdapterInfo[i].AdapterIndex, ref IsActive);

                            if (ADL.ADL_SUCCESS == ADLRet)
                            {
                                Logger("Adapter is   : " + (0 == IsActive ? "DISABLED" : "ENABLED"));
                                Logger("Adapter Index: " + OSAdapterInfoData.ADLAdapterInfo[i].AdapterIndex.ToString());
                                Logger("Adapter UDID : " + OSAdapterInfoData.ADLAdapterInfo[i].UDID);
                                Logger("Bus No       : " + OSAdapterInfoData.ADLAdapterInfo[i].BusNumber.ToString());
                                Logger("Driver No    : " + OSAdapterInfoData.ADLAdapterInfo[i].DriverNumber.ToString());
                                Logger("Function No  : " + OSAdapterInfoData.ADLAdapterInfo[i].FunctionNumber.ToString());
                                Logger("Vendor ID    : " + OSAdapterInfoData.ADLAdapterInfo[i].VendorID.ToString());
                                Logger("Adapter Name : " + OSAdapterInfoData.ADLAdapterInfo[i].AdapterName);
                                Logger("Display Name : " + OSAdapterInfoData.ADLAdapterInfo[i].DisplayName);
                                Logger("Present      : " + (0 == OSAdapterInfoData.ADLAdapterInfo[i].Present ? "No" : "Yes"));
                                Logger("Exist        : " + (0 == OSAdapterInfoData.ADLAdapterInfo[i].Exist ? "No" : "Yes"));
                                Logger("Driver Path  : " + OSAdapterInfoData.ADLAdapterInfo[i].DriverPath);
                                Logger("Driver Path X: " + OSAdapterInfoData.ADLAdapterInfo[i].DriverPathExt);
                                Logger("PNP String   : " + OSAdapterInfoData.ADLAdapterInfo[i].PNPString);

                                // Obtain information about displays
                                ADLDisplayInfo oneDisplayInfo = new ADLDisplayInfo();

                                if (null != ADL.ADL_Display_DisplayInfo_Get)
                                {
                                    IntPtr DisplayBuffer = IntPtr.Zero;
                                    int j = 0;

                                    // Force the display detection and get the Display Info. Use 0 as last parameter to NOT force detection
                                    ADLRet = ADL.ADL_Display_DisplayInfo_Get(OSAdapterInfoData.ADLAdapterInfo[i].AdapterIndex, ref NumberOfDisplays, out DisplayBuffer, 1);
                                    if (ADL.ADL_SUCCESS == ADLRet)
                                    {
                                        List<ADLDisplayInfo> DisplayInfoData = new List<ADLDisplayInfo>();
                                        for (j = 0; j < NumberOfDisplays; j++)
                                        {
                                            oneDisplayInfo = (ADLDisplayInfo)Marshal.PtrToStructure(new IntPtr(DisplayBuffer.ToInt64() + j * Marshal.SizeOf(oneDisplayInfo)), oneDisplayInfo.GetType());
                                            DisplayInfoData.Add(oneDisplayInfo);
                                        }
                                        Logger("\nTotal Number of Displays supported: " + NumberOfDisplays.ToString());
                                        Logger("\nDispID  AdpID  Type OutType  CnctType Connected  Mapped  InfoValue DisplayName ");

                                        for (j = 0; j < NumberOfDisplays; j++)
                                        {
                                            int InfoValue = DisplayInfoData[j].DisplayInfoValue;
                                            string StrConnected = (1 == (InfoValue & 1)) ? "Yes" : "No ";
                                            string StrMapped = (2 == (InfoValue & 2)) ? "Yes" : "No ";
                                            int AdpID = DisplayInfoData[j].DisplayID.DisplayLogicalAdapterIndex;
                                            string StrAdpID = (AdpID < 0) ? "--" : AdpID.ToString("d2");

                                            Logger(DisplayInfoData[j].DisplayID.DisplayLogicalIndex.ToString() + "        " +
                                                                 StrAdpID + "      " +
                                                                 DisplayInfoData[j].DisplayType.ToString() + "      " +
                                                                 DisplayInfoData[j].DisplayOutputType.ToString() + "      " +
                                                                 DisplayInfoData[j].DisplayConnector.ToString() + "        " +
                                                                 StrConnected + "        " +
                                                                 StrMapped + "      " +
                                                                 InfoValue.ToString("x4") + "   " +
                                                                 DisplayInfoData[j].DisplayName.ToString());
                                        }
                                        Logger("");
                                    }
                                    else
                                    {
                                        Logger("ADL_Display_DisplayInfo_Get() returned error code " + ADLRet.ToString());
                                    }
                                    // Release the memory for the DisplayInfo structure
                                    if (IntPtr.Zero != DisplayBuffer)
                                        Marshal.FreeCoTaskMem(DisplayBuffer);
                                }
                            }
                        }
                    }
                    else
                    {
                        Logger("ADL_Adapter_AdapterInfo_Get() returned error code " + ADLRet.ToString());
                    }
                }
                // Release the memory for the AdapterInfo structure
                if (IntPtr.Zero != AdapterBuffer)
                    Marshal.FreeCoTaskMem(AdapterBuffer);
            }
        }

        private void textBoxBitcoinAddress_TextChanged(object sender, EventArgs e)
        {
        }

        private void textBoxEthereumAddress_TextChanged(object sender, EventArgs e)
        {
        }

        private void textBoxMoneroAddress_TextChanged(object sender, EventArgs e)
        {
        }

        private void textBoxZcashAddress_TextChanged(object sender, EventArgs e)
        {
        }

        private void MainForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            UpdateDatabase();
            UnloadPhyMemDriver();
            if (ADLInitialized && null != ADL.ADL_Main_Control_Destroy)
                ADL.ADL_Main_Control_Destroy();
        }

        private void timerDeviceStatusUpdates_Tick(object sender, EventArgs e)
        {
            UpdateDeviceStatus();
        }

        NiceHashEthashStratum mStratum;
        List<Miner> mMiners = null;
        enum ApplicationGlobalState
        {
            Idle = 0,
            Mining = 1,
            Benchmarking = 2
        };
        ApplicationGlobalState appState = ApplicationGlobalState.Idle;

        private void buttonStart_Click(object sender, EventArgs e)
        {
            this.Enabled = false;

            if (appState == ApplicationGlobalState.Idle)
            {
                try
                {
                    Logger("Launching miners...");
                    // TODO: Check the value of the textbox.
                    mStratum = new NiceHashEthashStratum("daggerhashimoto.usa.nicehash.com", 3353, textBoxBitcoinAddress.Text, "x");
                    mMiners = new List<Miner>();
                    for (int deviceIndex = 0; deviceIndex < computeDeviceArray.Length; ++deviceIndex)
                        mMiners.Add(new OpenCLEthashMiner(computeDeviceArray[deviceIndex], deviceIndex, mStratum));
                    appState = ApplicationGlobalState.Mining;
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Failed to launch miner(s):\n" + ex.Message, appName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                    // TODO
                    mStratum = null;
                    mMiners = null;
                }
            }
            else if (appState == ApplicationGlobalState.Mining) {
                try
                {
                    Logger("Stopping miners...");
                    foreach (Miner miner in mMiners)
                        miner.Stop();
                    System.Threading.Thread.Sleep(1000);
                    mMiners = null;
                    mStratum.Stop();
                    System.Threading.Thread.Sleep(1000);
                    mStratum = null;
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Failed to stop miner(s):\n" + ex.Message, appName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                    mStratum = null;
                    mMiners = null;
                }
                appState = ApplicationGlobalState.Idle;
            }

            UpdateControls();
        }

        private void UpdateControls()
        {
            buttonStart.Text = (appState == ApplicationGlobalState.Mining) ? "Stop" : "Start";
            buttonBenchmark.Enabled = false;

            groupBoxCoinsToMine.Enabled = (appState == ApplicationGlobalState.Idle);
            textBoxBitcoinAddress.Enabled = (appState == ApplicationGlobalState.Idle);
            textBoxEthereumAddress.Enabled = (appState == ApplicationGlobalState.Idle);
            textBoxMoneroAddress.Enabled = (appState == ApplicationGlobalState.Idle);
            textBoxZcashAddress.Enabled = (appState == ApplicationGlobalState.Idle);

            this.Enabled = true;
        }

        private void timerCurrencyStatUpdates_Tick(object sender, EventArgs e)
        {
            UpdateCurrencyStats();
        }
    }
}
