using System;
using System.Threading.Tasks;

namespace ccharpEx
{
    // async/await
    // async -> 비동기 프로그래밍?
    // 게임서버) 비동기 = 멀티쓰레드? -> 꼭 그렇진 않다

    // 유니티) 코루틴 - 일종의 비동기 하지만 싱글스레드

    class Program // <- 싱글스레드 ->
    {
        static Task Test()
        {
            Console.WriteLine("start test");
            Task t = Task.Delay(3000);
            return t;
        }

        static void TestAsync()
        {
            Console.WriteLine("start TestAsync");
            Task t = Task.Delay(3000); // 복잡한 작업 (ex. DB나 파일 작업)
            t.Wait();
            Console.WriteLine("end TestAsync");
        }

        static async Task<int> TestAsyncWait()
        {
            Console.WriteLine("start TestAsyncWait");
            await Task.Delay(3000);
            Console.WriteLine("end TestAsyncWait"); // 명시적으로 쓰진 않았지만 멀티스레드로 잡힌다.
            return 1;
        }

        // await
        // await 뒤의 작업을 기다린다.
        // await를 사용하는 함수는 async를 붙여줘야하고 Task를 반환해 주어야한다.

        static async Task Main(string[] args)
        {
            int ret = await TestAsyncWait();

            // t.Wait();

            Console.WriteLine("while start");
            while (true)
            {
            }
        }
    }
}
