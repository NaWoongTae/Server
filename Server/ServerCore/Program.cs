using System;
using System.Threading;
using System.Threading.Tasks;
using System.Linq;

namespace ServerCore
{
    class Program
    {
        static int _num = 0;

        // AutoResetEvent보다 많은 데이터를 가짐
        // lock 횟수 저장
        // 쓰레드 ID - 잘못된 애가 릴리즈 하지않도록
        // 때문에 코스트가 좀더 듬
        static Mutex _lock = new Mutex(); // spinlock보다는 느림 -> 커널동기화 객체

        static void Thread_1()
        {
            foreach (int i in Enumerable.Range(1, 100000))
            {
                _lock.WaitOne();
                _num++;
                _lock.ReleaseMutex();
            }
        }

        static void Thread_2()
        {
            foreach (int i in Enumerable.Range(1, 100000))
            {
                _lock.WaitOne();
                _num--;
                _lock.ReleaseMutex();
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
