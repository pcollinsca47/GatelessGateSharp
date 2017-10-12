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


namespace GatelessGateSharp
{
    unsafe public partial class MainForm : Form
    {
        [DllImport("phymem_wrapper.dll")]
        extern public static int LoadPhyMemDriver();
        [DllImport("phymem_wrapper.dll")]
        extern public static void UnloadPhyMemDriver();

        static public int ADL_MAX_PATH = 256;
        [StructLayout(LayoutKind.Sequential)]
        public unsafe struct AdapterInfo {
            public int iSize;
            public int iAdapterIndex;
            fixed char strUDID[256];
            public int iBusNumber;
            public int iDeviceNumber;
            public int iFunctionNumber;
            public int iVendorID;
            public fixed char strAdapterName[256];
            public fixed char strDisplayName[256];
            public int iPresent;

            public int iExist;
            public fixed char strDriverPath[256];
            public fixed char strDriverPathExt[256];
            public fixed char strPNPString[256];
            public int iOSDisplayIndex;
        }
        public static String appName = "Gateless Gate #";
        String databaseFileName = "GatelessGateSharp.sqlite";
        String logFileName = "GatelessGateSharp.log";
        const int richTextBoxLogMaxLines = 65536;
        private System.Threading.Mutex loggerMutex = new System.Threading.Mutex();
        private Control[] labelGPUVendorArray;
        private Control[] labelGPUNameArray;
        private Control[] labelGPUIDArray;
        private Control[] labelGPUSpeedArray;
        private Control[] labelGPUTempArray;
        private Control[] labelGPUActivityArray;
        private Control[] labelGPUFanArray;
        private Control[] checkBoxGPUEnabledArray;
        private ComputeDevice[] computeDeviceArray;
        private const int computeDeviceArrayMaxLength = 8; // This depends on MainForm.
        private Boolean ADLInitialized = false;
        private Int32 numADLAdapters = 0;

        public void Logger(String lines)
        {
            loggerMutex.WaitOne();
            System.IO.StreamWriter file = new System.IO.StreamWriter(logFileName, true);
            file.WriteLine(lines);
            file.Close();
            richTextBoxLog.Text += lines + "\n";
            if (richTextBoxLog.Lines.Length > richTextBoxLogMaxLines)
            {
                richTextBoxLog.Select(0, richTextBoxLog.Text.IndexOf('\n') + 1);
                richTextBoxLog.SelectedRtf = "{\\rtf1\\ansi\\ansicpg1252\\deff0\\deflang1053\\uc1 }";
            }
            loggerMutex.ReleaseMutex();
        }

        unsafe public MainForm()
        {
            InitializeComponent();
            Logger(appName + " started.");
            labelGPUVendorArray = new Control[] { labelGPU0Vendor, labelGPU1Vendor, labelGPU2Vendor, labelGPU3Vendor, labelGPU4Vendor, labelGPU5Vendor, labelGPU6Vendor, labelGPU7Vendor };
            labelGPUNameArray = new Control[] { labelGPU0Name, labelGPU1Name, labelGPU2Name, labelGPU3Name, labelGPU4Name, labelGPU5Name, labelGPU6Name, labelGPU7Name };
            labelGPUIDArray = new Control[] { labelGPU0ID, labelGPU1ID, labelGPU2ID, labelGPU3ID, labelGPU4ID, labelGPU5ID, labelGPU6ID, labelGPU7ID };
            labelGPUTempArray = new Control[] { labelGPU0Temp, labelGPU1Temp, labelGPU2Temp, labelGPU3Temp, labelGPU4Temp, labelGPU5Temp, labelGPU6Temp, labelGPU7Temp };
            labelGPUActivityArray = new Control[] { labelGPU0Activity, labelGPU1Activity, labelGPU2Activity, labelGPU3Activity, labelGPU4Activity, labelGPU5Activity, labelGPU6Activity, labelGPU7Activity };
            labelGPUFanArray = new Control[] { labelGPU0Fan, labelGPU1Fan, labelGPU2Fan, labelGPU3Fan, labelGPU4Fan, labelGPU5Fan, labelGPU6Fan, labelGPU7Fan };
            labelGPUSpeedArray = new Control[] { labelGPU0Speed, labelGPU1Speed, labelGPU2Speed, labelGPU3Speed, labelGPU4Speed, labelGPU5Speed, labelGPU6Speed, labelGPU7Speed };
            checkBoxGPUEnabledArray = new Control[] { checkBoxGPU0Enabled, checkBoxGPU1Enabled, checkBoxGPU2Enabled, checkBoxGPU3Enabled, checkBoxGPU4Enabled, checkBoxGPU5Enabled, checkBoxGPU6Enabled, checkBoxGPU7Enabled };

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
                checkBoxGPUEnabledArray[index].Visible = false;
            }

            int ADLRet = -1;
            int NumberOfAdapters = 0;
 
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
                Logger("Number Of ADL Adapters: " + NumberOfAdapters.ToString());

                if (0 < NumberOfAdapters)
                {
                }
            }
            else
            {
                Logger("Failed to initialize AMD Display Library.");
            }
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
    }
}
