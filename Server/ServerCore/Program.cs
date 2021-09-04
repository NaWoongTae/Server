using System;
using System.Text;
using System.Net;
using System.Net.Sockets;
using System.Threading;
using System.Threading.Tasks;

namespace ServerCore
{
    class Program
    {
        static Listener _listener = new Listener();

        static void OnAcceptHandler(Socket clientSocket)
        {
            try
            {
                // 보낸다
                byte[] sendBuff = Encoding.UTF8.GetBytes("클라에게, 안녕? 나는 서버야. -서버가-");
                int sendLen = clientSocket.Send(sendBuff);

                // 받는다
                byte[] recvBuff = new byte[1024];
                int recvLen = clientSocket.Receive(recvBuff);
                string recv = Encoding.UTF8.GetString(recvBuff, 0, recvLen);
                Console.WriteLine(recv);

                // 종료
                clientSocket.Shutdown(SocketShutdown.Both);
                clientSocket.Close();
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
            }
        }

        static void Main(string[] args)
        {
            IPHostEntry host = Dns.GetHostEntry(Dns.GetHostName());
            IPAddress Adrs = host.AddressList[0];
            IPEndPoint endPoint = new IPEndPoint(Adrs, 7777);

            _listener.Init(endPoint, OnAcceptHandler);

            while (true) //(임시) 프로그램 종료 방지
            {

            }
        }
    }
}
