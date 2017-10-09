using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Runtime.InteropServices;


namespace GatelessGateSharp
{
    static class Program
    {
        [DllImport("kernel32.dll", SetLastError = true)]
        static extern bool AllocConsole();

        [DllImport("kernel32.dll", SetLastError = true)]
        static extern bool FreeConsole();

        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            bool runningWin32NT = (Environment.OSVersion.Platform == PlatformID.Win32NT);
            bool consoleAllocated = false;
            int allocError = 0;
            bool runApp = true;

            if (false && runningWin32NT)
            {
                consoleAllocated = AllocConsole();
                if (!consoleAllocated)
                {
                    allocError = Marshal.GetLastWin32Error();
                    if (allocError != 0)
                        runApp = (DialogResult.Yes == MessageBox.Show("Could not allocate console (error code: " + allocError + ").\nRunning the application on the AMD APP OpenCL platform might fail.\nContinue anyway?", "Error", MessageBoxButtons.YesNo, MessageBoxIcon.Warning));
                }
            }

            if (runApp)
            {
                Application.EnableVisualStyles();
                Application.SetCompatibleTextRenderingDefault(false);
                Application.Run(new MainForm());
            }
        }
    }
}
