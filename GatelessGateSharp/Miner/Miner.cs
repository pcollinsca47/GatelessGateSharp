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
    class Miner
    {
        private int mDeviceIndex;
        private bool mStopped = false;

        public int DeviceIndex { get { return mDeviceIndex; } }
        public bool Stopped { get { return mStopped; } }

        protected Miner(int aDeviceIndex)
        {
            mDeviceIndex = aDeviceIndex;
        }

        public void Stop()
        {
            mStopped = true;
        }
    }
}
