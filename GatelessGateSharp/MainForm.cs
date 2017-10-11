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


namespace GatelessGateSharp
{
    public partial class MainForm : Form
    {
        [DllImport("phymem_wrapper.dll")]
        extern public static int LoadPhyMemDriver();
        [DllImport("phymem_wrapper.dll")]
        extern public static void UnloadPhyMemDriver();

        [DllImport("phymem_wrapper.dll")]
        extern public static int ADL_Main_Control_Create_Wrapper(int i);
        [DllImport("atiadlxx.dll")]
        extern public static int ADL_Main_Control_Destroy();
        [DllImport("atiadlxx.dll")]
        extern public static int ADL_Adapter_NumberOfAdapters_Get(ref Int32 num);
        /*
        ttypedef int(*ADL_ADAPTER_NUMBEROFADAPTERS_GET) (int*);
        typedef int(*ADL_ADAPTER_ADAPTERINFO_GET) (LPAdapterInfo, int);
        typedef int(*ADL_ADAPTER_ACTIVE_GET) (int, int*);
        typedef int(*ADL_OVERDRIVE_CAPS) (int iAdapterIndex, int *iSupported, int *iEnabled, int *iVersion);
        typedef int(*ADL_OVERDRIVE5_THERMALDEVICES_ENUM) (int iAdapterIndex, int iThermalControllerIndex, ADLThermalControllerInfo *lpThermalControllerInfo);
        typedef int(*ADL_OVERDRIVE5_ODPARAMETERS_GET) (int  iAdapterIndex, ADLODParameters *  lpOdParameters);
        typedef int(*ADL_OVERDRIVE5_TEMPERATURE_GET) (int iAdapterIndex, int iThermalControllerIndex, ADLTemperature *lpTemperature);
        typedef int(*ADL_OVERDRIVE5_FANSPEED_GET) (int iAdapterIndex, int iThermalControllerIndex, ADLFanSpeedValue *lpFanSpeedValue);
        typedef int(*ADL_OVERDRIVE5_FANSPEEDINFO_GET) (int iAdapterIndex, int iThermalControllerIndex, ADLFanSpeedInfo *lpFanSpeedInfo);
        typedef int(*ADL_OVERDRIVE5_FANSPEEDTODEFAULT_SET)(int iAdapterIndex, int  iThermalControllerIndex);
        typedef int(*ADL_OVERDRIVE5_ODPERFORMANCELEVELS_GET) (int iAdapterIndex, int iDefault, ADLODPerformanceLevels *lpOdPerformanceLevels);
        typedef int(*ADL_OVERDRIVE5_ODPARAMETERS_GET) (int iAdapterIndex, ADLODParameters *lpOdParameters);
        typedef int(*ADL_OVERDRIVE5_CURRENTACTIVITY_GET) (int iAdapterIndex, ADLPMActivity *lpActivity);
        typedef int(*ADL_OVERDRIVE5_FANSPEED_SET)(int iAdapterIndex, int iThermalControllerIndex, ADLFanSpeedValue *lpFanSpeedValue);
        typedef int(*ADL_OVERDRIVE5_ODPERFORMANCELEVELS_SET) (int iAdapterIndex, ADLODPerformanceLevels *lpOdPerformanceLevels);
        typedef int(*ADL_OVERDRIVE5_POWERCONTROL_CAPS)(int iAdapterIndex, int *lpSupported);
        typedef int(*ADL_OVERDRIVE5_POWERCONTROLINFO_GET)(int iAdapterIndex, ADLPowerControlInfo *lpPowerControlInfo);
        typedef int(*ADL_OVERDRIVE5_POWERCONTROL_GET)(int iAdapterIndex, int *lpCurrentValue, int *lpDefaultValue);
        typedef int(*ADL_OVERDRIVE5_POWERCONTROL_SET)(int iAdapterIndex, int iValue);
        */
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

        public MainForm()
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

            if (ADL_Main_Control_Create_Wrapper(1) == 0)
            {
                Logger("Successfully initialized AMD Display Library.");
                ADLInitialized = true;
                Int32 num = 0;
                if (ADL_Adapter_NumberOfAdapters_Get(ref num) == 0)
                    Logger("# of ADL Adapters: " + num);
            }
            else
            {
                Logger("Failed to initialize AMD Display Library.");
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
            if (ADLInitialized)
            {
                ADL_Main_Control_Destroy();
                ADLInitialized = false;
            }
        }
    }
}
