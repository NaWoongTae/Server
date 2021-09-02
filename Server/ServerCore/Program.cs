using System;
using System.Threading;
using System.Threading.Tasks;
using System.Linq;

namespace ServerCore
{
    class Program
    {
        static volatile int count = 0;
        static Lock _lock = new Lock();

        static void Main(string[] args)
        {
            Task t1 = new Task(delegate ()
            {
                foreach (int i in Enumerable.Range(1, 1000))
                {
                    _lock.ReadLock();
                    count++;
                    _lock.ReadUnlock();
                }
            });
            Task t2 = new Task(delegate ()
            {
                foreach (int i in Enumerable.Range(1, 1000))
                {
                    _lock.ReadLock();
                    count--;
                    _lock.ReadUnlock();
                }
            });
            Task t3 = new Task(delegate ()
            {
                foreach (int i in Enumerable.Range(1, 1000))
                {
                    _lock.ReadLock();
                    //count--;
                    _lock.ReadUnlock();
                }
            });

            t1.Start();
            t2.Start();
            t3.Start();

            Task.WaitAll(t1, t2, t3);

            Console.WriteLine(count);
        }
    }
}
