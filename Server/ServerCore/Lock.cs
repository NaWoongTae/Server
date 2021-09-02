using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;

namespace ServerCore
{
    // 재귀적 락을 허용할지 (true) W -> W , W -> R , R -> W(X)
    // spinLock 정책 (5000회 -> yield)
    class Lock
    {
        const int EMPTY_FLAG = 0x00000000;
        const int WRITE_MASK = 0x7FFF0000;
        const int READ_MASK  = 0x0000FFFF;
        const int MAX_SPIN_COUNT = 5000;

        // write는 한번에 한 쓰레드만 잡을수 있음
        // [Unused(1bit)] [WriteThreadId(15bit)] [ReadCount(16bit)]
        int _flag = 0x00000000;
        int _writeCount = 0;
        public void WriteLock()
        {
            // 동일 스레드가 WriteLock을 이미 획득하고 있는지 확인
            int lockThreadId = (_flag & WRITE_MASK) >> 16;
            if (lockThreadId == Thread.CurrentThread.ManagedThreadId)
            {
                _writeCount++;
                return;
            }

            // 아무도 writelock or readlock을 획득하고 있지 않을 때, 경합해서 소유권을 얻는다
            int threadId = (Thread.CurrentThread.ManagedThreadId << 16) & WRITE_MASK;
            while (true)
            {
                for (int i = 0; i < MAX_SPIN_COUNT; i++)
                {
                    if (Interlocked.CompareExchange(ref _flag, threadId, EMPTY_FLAG) == EMPTY_FLAG)  // 시도해서 성공하면 return;
                    {
                        _writeCount = 1;
                        return;
                    }
                }

                Thread.Yield();
            }
        }

        public void WriteUnlock()
        {
            if (--_writeCount == 0)
                Interlocked.Exchange(ref _flag, EMPTY_FLAG);
        }

        public void ReadLock()
        {
            // 동일 스레드가 WriteLock을 이미 획득하고 있는지 확인
            int lockThreadId = (_flag & WRITE_MASK) >> 16;
            if (lockThreadId == Thread.CurrentThread.ManagedThreadId)
            {
                Interlocked.Increment(ref _flag);
                return;
            }

            // 아무도 writelock을 획득하고 있지 않으면 readCount를 1 증가시킴
            while (true)
            {
                for (int i = 0; i < MAX_SPIN_COUNT; i++)
                {
                    int expected = (_flag & READ_MASK);

                    if (Interlocked.CompareExchange(ref _flag, expected + 1, expected) == expected)
                    {
                        Console.WriteLine(_flag);
                        return;
                    }
                }

                Thread.Yield();
            }
        }

        public void ReadUnlock()
        {
            Interlocked.Decrement(ref _flag);
        }
    }
}
