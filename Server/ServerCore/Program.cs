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
        static void Main(string[] args)
        {
            // DNS (Domain Name System)
            string host = Dns.GetHostName();
            Console.WriteLine($"My Host : {host}");
            IPHostEntry ipHost = Dns.GetHostEntry(host);
            IPAddress ipAddr = ipHost.AddressList[0];
            IPEndPoint endPoint = new IPEndPoint(ipAddr, 7777);

            try 
            {
                // 문지기
                Socket listenSocket = new Socket(endPoint.AddressFamily, SocketType.Stream, ProtocolType.Tcp);

                // 문지기 교육
                listenSocket.Bind(endPoint);

                // 영업 시작
                listenSocket.Listen(10); // backlog : 최대 대기수

                while (true)
                {
                    Console.WriteLine(("Listening..."));

                    // 손님 입장 (대리인 생성)
                    Socket clientSocket = listenSocket.Accept(); // 클라이언트가 입장하지 않으면 멈추고 기다린다

                    // 받는다
                    byte[] receiveBuff = new byte[1024];
                    int recvBytes = clientSocket.Receive(receiveBuff);
                    string recvData = Encoding.UTF8.GetString(receiveBuff, 0, recvBytes);
                    Console.WriteLine($"[From Client] {recvData}");

                    // 보낸다
                    byte[] sendBuff = Encoding.UTF8.GetBytes("Welcome to MMORPG Server !");
                    clientSocket.Send(sendBuff);

                    // 쫒아낸다
                    clientSocket.Shutdown(SocketShutdown.Both);
                    clientSocket.Close();
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
            } 
        }
    }
}
