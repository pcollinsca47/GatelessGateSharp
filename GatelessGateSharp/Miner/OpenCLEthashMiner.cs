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
using HashLib;



namespace GatelessGateSharp
{
    class OpenCLEthashMiner : OpenCLMiner
    {
        const int EPOCH_LENGTH = 30000;

        private ComputeProgram mProgram;
        private ComputeKernel mDAGKernel;
        private ComputeKernel mSearchKernel;
        private NiceHashEthashStratum mStratum;
        private Thread mMinerThread = null;
        private long mLocalWorkSize = 256;
        private long mGlobalWorkSize;

        public OpenCLEthashMiner(ComputeDevice aDevice, int aDeviceIndex, NiceHashEthashStratum aStratum)
            : base(aDevice, aDeviceIndex)
        {
            mStratum = aStratum;
            mGlobalWorkSize = 1024 * mLocalWorkSize * Device.MaxComputeUnits;

            mProgram = new ComputeProgram(this.Context, System.IO.File.ReadAllText(@"Kernels\ethash.cl"));
            MainForm.Logger("Loaded ethash program for Device #" + aDeviceIndex + ".");
            List<ComputeDevice> deviceList = new List<ComputeDevice>();
            deviceList.Add(Device);
            mProgram.Build(deviceList, "-DWORKSIZE=" + mLocalWorkSize, null, IntPtr.Zero);
            MainForm.Logger("Built ethash program for Device #" + aDeviceIndex + ".");
            mDAGKernel = mProgram.CreateKernel("GenerateDAG");
            MainForm.Logger("Created DAG kernel for Device #" + aDeviceIndex + ".");
            mSearchKernel = mProgram.CreateKernel("search");
            MainForm.Logger("Created search kernel for Device #" + aDeviceIndex + ".");

            mMinerThread = new Thread(new ThreadStart(MinerThread));
            mMinerThread.IsBackground = true;
            mMinerThread.Start();
        }

        unsafe public void MinerThread()
        {
            MainForm.Logger("Miner thread for Device #" + DeviceIndex + " started.");

            // Wait for the first job to arrive.
            int timePassed = 0;
            while (mStratum.CurrentJob == null && timePassed < 5000)
            {
                Thread.Sleep(10);
                timePassed += 10;
            }
            if (mStratum.CurrentJob == null)
                throw new TimeoutException("Stratum server failed to send a new job.");

            NiceHashEthashStratum.Work work;
            int epoch = -1;
            long DAGSize = 0;
            ComputeMemory DAGBuffer = null;
            ComputeBuffer<UInt32> outputBuffer = new ComputeBuffer<UInt32>(Context, ComputeMemoryFlags.ReadWrite, 255);
            ComputeBuffer<byte> headerBuffer = new ComputeBuffer<byte>(Context, ComputeMemoryFlags.ReadOnly, 32);
            UInt32[] output = new UInt32[255];
            byte[] extranonceByteArray = Utilities.StringToByteArray(mStratum.Extranonce);
            UInt64 startNonce = 0;
            for (int i = 0; i < extranonceByteArray.Length; ++i)
                startNonce |= (UInt64)extranonceByteArray[i] << (8 * (7 - i));
            while ((work = mStratum.GetWork()) != null)
            {
                String jobID = work.CurrentJob.ID;
                fixed (byte* p = Utilities.StringToByteArray(work.CurrentJob.Headerhash))
                    Queue.Write<byte>(headerBuffer, true, 0, 32, (IntPtr)p, null);

                if (epoch != work.CurrentJob.Epoch)
                {
                    if (DAGBuffer != null)
                    {
                        DAGBuffer.Dispose();
                        DAGBuffer = null;
                    }
                    epoch = work.CurrentJob.Epoch;
                    DAGCache cache = new DAGCache(work.CurrentJob.Epoch, work.CurrentJob.Seedhash);
                    DAGSize = Utilities.GetDAGSize(epoch);

                    ComputeMemory DAGCacheBuffer;
                    fixed (byte* p = cache.Data())
                        DAGCacheBuffer = new ComputeBuffer<byte>(Context, ComputeMemoryFlags.ReadOnly | ComputeMemoryFlags.CopyHostPointer, cache.Data().Length, (IntPtr)p);
                    DAGBuffer = new ComputeBuffer<byte>(Context, ComputeMemoryFlags.ReadWrite, DAGSize);

                    mDAGKernel.SetValueArgument<UInt32>(0, 0);
                    mDAGKernel.SetMemoryArgument(1, DAGCacheBuffer);
                    mDAGKernel.SetMemoryArgument(2, DAGBuffer);
                    mDAGKernel.SetValueArgument<UInt32>(3, (UInt32)cache.Data().Length / 64);
                    mDAGKernel.SetValueArgument<UInt32>(4, 1);

                    System.Diagnostics.Stopwatch sw = new System.Diagnostics.Stopwatch();
                    sw.Start();
                    Queue.Execute(mDAGKernel, new long[] { 0 }, new long[] { DAGSize / 64 }, new long[] { mLocalWorkSize }, null);
                    Queue.Finish();
                    sw.Stop();
                    MainForm.Logger("Generated DAG for Epoch #" + epoch + " (" + (long)sw.Elapsed.TotalMilliseconds + "ms).");

                    DAGCacheBuffer.Dispose();

                    startNonce = 0;
                }

                while (jobID == work.CurrentJob.ID)
                {
                    mSearchKernel.SetMemoryArgument(0, outputBuffer); // g_output
                    mSearchKernel.SetMemoryArgument(1, headerBuffer); // g_header
                    mSearchKernel.SetMemoryArgument(2, DAGBuffer); // _g_dag
                    mSearchKernel.SetValueArgument<UInt32>(3, (UInt32)DAGSize / 128); // DAG_SIZE
                    mSearchKernel.SetValueArgument<UInt64>(4, startNonce); // start_nonce
                    mSearchKernel.SetValueArgument<UInt64>(5, (UInt64)(0x00000000ffffffffUL / mStratum.Difficulty)); // target
                    mSearchKernel.SetValueArgument<UInt32>(6, 1); // isolate

                    System.Diagnostics.Stopwatch sw = new System.Diagnostics.Stopwatch();
                    sw.Start();
                    fixed (UInt32* p = output)
                    {
                        output[0] = 0;
                        Queue.Write<UInt32>(outputBuffer, true, 0, 1, (IntPtr)p, null);
                        Queue.Execute(mSearchKernel, new long[] { 0 }, new long[] { mGlobalWorkSize }, new long[] { mLocalWorkSize }, null);
                        Queue.Read<UInt32>(outputBuffer, true, 0, 255, (IntPtr)p, null);
                    }
                    sw.Stop();
                    //MainForm.Logger("Speed: " + ((double)mGlobalWorkSize) / sw.Elapsed.TotalSeconds / (1000000));
                    if (output[0] > 0)
                        MainForm.Logger("Share found.");
                    startNonce += (UInt64)mGlobalWorkSize;
                }

                headerBuffer.Dispose();
            }

            if (DAGBuffer != null)
            {
                DAGBuffer.Dispose();
                DAGBuffer = null;
            }
        }
    }
}
