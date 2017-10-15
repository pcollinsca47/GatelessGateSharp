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
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Cloo;



namespace GatelessGateSharp
{
    class OpenCLEthashMiner : OpenCLMiner
    {
        private ComputeProgram mProgram;
        private ComputeKernel mDAGKernel;
        private ComputeKernel mSearchKernel;
        private NiceHashEthashStratum mStratum;
        private Thread mMinerThread = null;

        public OpenCLEthashMiner(ComputeDevice aDevice, int aDeviceIndex, NiceHashEthashStratum aStratum)
            : base(aDevice, aDeviceIndex)
        {
            mStratum = aStratum;

            mProgram = new ComputeProgram(this.Context, System.IO.File.ReadAllText(@"Kernels\ethash.cl"));
            MainForm.Logger("Loaded ethash program for Device #" + aDeviceIndex + ".");
            List<ComputeDevice> deviceList = new List<ComputeDevice>();
            deviceList.Add(Device);
            mProgram.Build(deviceList, "-DWORKSIZE=256", null, IntPtr.Zero);
            MainForm.Logger("Built ethash program for Device #" + aDeviceIndex + ".");
            mDAGKernel = mProgram.CreateKernel("GenerateDAG");
            MainForm.Logger("Created DAG kernel for Device #" + aDeviceIndex + ".");
            mSearchKernel = mProgram.CreateKernel("search");
            MainForm.Logger("Created search kernel for Device #" + aDeviceIndex + ".");

            mMinerThread = new Thread(new ThreadStart(MinerThread));
            mMinerThread.IsBackground = true;
            mMinerThread.Start();
        }

        public void MinerThread()
        {
            int timePassed = 0;
            while (mStratum.CurrentJob == null && timePassed < 5000)
            {
                Thread.Sleep(10);
                timePassed += 10;
            }
            if (mStratum.CurrentJob == null)
                throw new TimeoutException("Stratum server failed to send a new job.");
            MainForm.Logger("Miner received a new job.");
        }
    }
}
