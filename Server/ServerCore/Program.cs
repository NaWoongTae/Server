using System;
using System.Threading;
using System.Threading.Tasks;
using System.Linq;

namespace ServerCore
{
    class Program
    {
        // 특정 순간에만 lock
        // writeLock이 걸리지 않는다면 ReadLock이 없는것처럼 작동한다.
        static ReaderWriterLockSlim _lock4 = new ReaderWriterLockSlim();

        class Reward { }
        static Reward GetRewardById(int id)
        {
            _lock4.EnterReadLock();
            // 행동
            _lock4.ExitReadLock();

            return null;
        }

        void AddReward(Reward reward)
        {
            _lock4.EnterWriteLock();

            _lock4.ExitWriteLock();
        }

        static void Main(string[] args)
        {

        }
    }
}
