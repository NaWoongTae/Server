using System;
using System.Threading;
using System.Threading.Tasks;
using System.Linq;

namespace ServerCore
{
    class SpinLock
    {
        volatile int _locked = 0;
        public void Acquire()
        {            
            while (true)
            {
                //int origin = Interlocked.Exchange(ref _locked, 1);                
                //if (origin == 0) // 원래 0이었을때만
                //    break;

                // CAS Compare-And-Swap
                int expected = 0; // 예상값;
                int desired = 1; // 원하는값
                if (Interlocked.CompareExchange(ref _locked, desired, expected) == expected) // 
                    break;
            }
        }

        public void Release()
        {
            _locked = 0; // 사용 종료
        }
    }

    class Program
    {
        static int _num = 0;
        static SpinLock _lock = new SpinLock();

        static void Thread_1()
        {
            foreach (int i in Enumerable.Range(1, 1000000))
            {
                _lock.Acquire();
                _num++;
                _lock.Release();
            }
        }

        static void Thread_2()
        {
            foreach (int i in Enumerable.Range(1, 1000000))
            {
                _lock.Acquire();
                _num--;
                _lock.Release();
            }
        }

        static void Main(string[] args)
        {
            Task t1 = new Task(Thread_1);
            Task t2 = new Task(Thread_2);
            t1.Start();
            t2.Start();

            Task.WaitAll(t1, t2);

            Console.Write(_num);
        }
    }
}
