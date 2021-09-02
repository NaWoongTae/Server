using System;
using System.Threading;
using System.Threading.Tasks;
using System.Linq;

namespace ServerCore
{
    // 커널레벨까지 가서 요청하기 때문에 spinLock에 비해 매우 오래걸림
    class Lock
    {
        // bool <- 커널
        // 생성자의 인자 bool값 문이 열린/닫힌상태로 시작할 것인지
        AutoResetEvent _available = new AutoResetEvent(true); // 자동으로 문 닫아줌
        
        ManualResetEvent _mAvailable = new ManualResetEvent(true); // 자동으로 문 안닫아줌

        public void Acquire()
        {
            _available.WaitOne(); // 입장 시도
            // _available.Reset(); // bool => false , 사실상 WaitOne에 포함
            
            { 
                _mAvailable.WaitOne(); // 입장시도
                _mAvailable.Reset();   // 문 닫기  --  이런식으로 행동이 분화 될수록 멀티스레드에서 문제가 생길 확률이 높음
                // 여러가지 스레드들이 기다렸다가 한번에 실행되어야 할때 사용 - ex) 긴 로딩후 여러가지실행
                // 일반적인 lock이랑은 시나리오가 다르다.
            }
        }

        public void Release()
        {
            _available.Set(); // bool => true;
        }
    }

    class Program
    {
        static int _num = 0;
        static Lock _lock = new Lock();

        static void Thread_1()
        {
            foreach (int i in Enumerable.Range(1, 10000))
            {
                _lock.Acquire();
                _num++;
                _lock.Release();
            }
        }

        static void Thread_2()
        {
            foreach (int i in Enumerable.Range(1, 10000))
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
