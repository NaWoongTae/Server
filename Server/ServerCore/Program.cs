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
                if (Interlocked.CompareExchange(ref _locked, desired, expected) == expected) // 여기서 즉시 재시도 해야 spinlock
                    break;

                Thread.Sleep(1); // 1ms 쉼
                Thread.Sleep(0); // 조건부 양보 => 나보다 우선순위가 낮은 애들한테는 양보 불가 => 우선순위가 나보다 같거나 높은 쓰레드가 없으면 다시 본인
                Thread.Yield(); // 관대한 양보 => 지금 실행 가능한 쓰레드가 있으면 실행가능 => 실행 가능한 애 없으면 다시 본인
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
