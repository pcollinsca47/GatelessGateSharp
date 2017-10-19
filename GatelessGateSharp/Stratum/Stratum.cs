using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GatelessGateSharp
{
    class Stratum
    {
        public class Job
        {
        }

        public class Work
        {
        }

        protected Work GetWork()
        {
            return null;
        }

        private bool mStopped = false;

        public bool Stopped { get { return mStopped; } }

        public void Stop()
        {
            mStopped = true;
        }
    }
}
