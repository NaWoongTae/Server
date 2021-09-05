using System;
using System.Text;
using System.Net;
using System.Net.Sockets;
using System.Threading;

namespace DummyClient
{
    class Program
    {
        static void Main(string[] args)
        {
            string host = Dns.GetHostName();
            IPHostEntry iPHost = Dns.GetHostEntry(host);
            IPAddress Adrs = iPHost.AddressList[0];
            IPEndPoint end = new IPEndPoint(Adrs, 7777);

            while (true)
            {
                Socket socket = new Socket(end.AddressFamily, SocketType.Stream, ProtocolType.Tcp);

                try
                {
                    socket.Connect(end);

                    //string read = Console.ReadLine();
                    for (int i = 0; i < 2; i++)
                    {
                        byte[] sendBuff = Encoding.UTF8.GetBytes($"서버에게, 안녕? 나는 {i}번 클라야. -클라가-");
                        int sendLen = socket.Send(sendBuff);
                    }

                    byte[] recvBuff = new byte[1024];
                    int recvLen = socket.Receive(recvBuff);
                    string recv = Encoding.UTF8.GetString(recvBuff, 0, recvLen);
                    Console.WriteLine(recv);

                    socket.Shutdown(SocketShutdown.Both);
                    socket.Close();
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.ToString());
                }

                Thread.Sleep(1000);
            }
        }
    }
}
