using System;
using System.Threading;
using System.Threading.Tasks;
using System.Linq;

namespace ServerCore
{
    class Program
    {
        // 근성 spinlock
        // 양보 sleep, yield
        // 갑질 AutoResetEvent

        static object _lock = new object();

        // 사실 내부적으로 구현되어있음
        // 근성으로 버티지만 너무 오랜시간 대기할경우 간헐적으로 yield를 시행한다.
        static SpinLock _lock2 = new SpinLock();
        
        // 오래 걸림
        // 별도의 프로그램끼리도 동기화가 가능함
        static Mutex _lock3 = new Mutex();

        static void Main(string[] args)
        {
            // ex) _lock
            lock (_lock) // 내부적으로는 Monitor를 사용함
            {
                
            }

            // ex) _lock2
            bool lockTaken = false;
            try
            {
                _lock2.Enter(ref lockTaken);
            }
            finally 
            {
                if (lockTaken)
                    _lock2.Exit();
            }
        }
    }
}
