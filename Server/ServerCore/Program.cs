using System;
using System.Threading;
using System.Threading.Tasks;
using System.Linq;

namespace ServerCore
{
    class Program
    {
        // TLS Thread Local Storage 스레드 개별 데이터를 만들어준다. 각 스레드안의 스토리지에 ThreadName 라는 같은 이름의 데이터를 생성하는것같다.
        static ThreadLocal<string> ThreadName = new ThreadLocal<string>(()=> { return $"my ThreadLocal name is {Thread.CurrentThread.ManagedThreadId}"; });
        static string threadname;

        // 스레드를 마구잡이로 썼을때 TLS인 ThreadName가 각각의 id를 잘 반환하는지 체크
        static void WhoAmI_0()
        {
            ThreadName.Value = $"my ThreadLocal name is {Thread.CurrentThread.ManagedThreadId}";

            Thread.Sleep(1000);

            Console.WriteLine(ThreadName.Value);
        }

        // 스레드를 마구잡이로 썼을때 일반 string 필드인 threadname가 각각의 id를 잘 반환하는지 체크
        static void WhoAmI_1()
        {
            threadname = $"my Thread name is {Thread.CurrentThread.ManagedThreadId}";

            Thread.Sleep(1000);

            Console.WriteLine(threadname);
        }

        // WhoAmI_0과 같이 매번 스레드아이디를 가져와서 덮어쓰기 하지않고
        // TLS 생성시 생성자를 통해 값을 설정후 저장된값을 사용
        static void WhoAmI_2()
        {
            bool repeat = ThreadName.IsValueCreated; // 값이 생성 됬는지 체크

            if (repeat)
                Console.WriteLine(ThreadName.Value + " (repeat)");
            else
                Console.WriteLine(ThreadName.Value);
        }

        static void Main(string[] args)
        {
            ThreadPool.SetMinThreads(1, 1);
            ThreadPool.SetMaxThreads(3, 3);
            Parallel.Invoke(WhoAmI_0, WhoAmI_0, WhoAmI_0, WhoAmI_0, WhoAmI_0, WhoAmI_0, WhoAmI_0); // 쉽게 스레드 사용가능 ThreadPool에 영향
            Parallel.Invoke(WhoAmI_1, WhoAmI_1, WhoAmI_1, WhoAmI_1, WhoAmI_1, WhoAmI_1, WhoAmI_1);
            Parallel.Invoke(WhoAmI_2, WhoAmI_2, WhoAmI_2, WhoAmI_2, WhoAmI_2, WhoAmI_2, WhoAmI_2);

            ThreadName.Dispose();
        }
    }
}
