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
using System.Threading.Tasks;
using Cloo;



namespace GatelessGateSharp
{
    class OpenCLMiner : Miner
    {
        private ComputeDevice mDevice;
        private ComputeContext mContext = null;
        private ComputeCommandQueue mQueue = null;

        public ComputeDevice Device { get { return mDevice; } }
        public ComputeContext Context { get { return mContext; } }
        public ComputeCommandQueue Queue { get { return mQueue; } }

        protected OpenCLMiner(ComputeDevice aDevice, int aDeviceIndex) : base(aDeviceIndex)
        {
            mDevice = aDevice;
            List<ComputeDevice> deviceList = new List<ComputeDevice>();
            deviceList.Add(mDevice);
            ComputeContextPropertyList properties = new ComputeContextPropertyList(mDevice.Platform);
            mContext = new ComputeContext(deviceList, properties, null, IntPtr.Zero);
            mQueue = new ComputeCommandQueue(mContext, mDevice, ComputeCommandQueueFlags.None);
        }

        ~OpenCLMiner()
        {
            if (mQueue != null) mQueue.Dispose();
            if (mContext != null) mContext.Dispose();
        }
    }
}
