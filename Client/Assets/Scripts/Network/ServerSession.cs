using System;
using System.Text;
using System.Net;
using System.Net.Sockets;
using System.Threading;
using ServerCore;
using System.Collections.Generic;

namespace DummyClient
{
	class ServerSession : PacketSession
    {
        public override void OnConnected(EndPoint endPoint)
        {
            Console.WriteLine($"OnConnected : {endPoint}");

            C_Chat packet = new C_Chat() {  };
            packet.chat = "안녕하세요";

            ArraySegment<byte> s = packet.Write();

            if (s != null)
                Send(s);            
        }

        public override void OnDisconnected(EndPoint endPoint)
        {
            Console.WriteLine($"OnDisconnected : {endPoint}");
        }

        public override void OnRecvPacket(ArraySegment<byte> buffer)
        {
            PacketManager.Instance.OnRecvPacket(this, buffer, (s, p) => PacketQueue.Instance.Push(p));
        }

        public override void OnSend(int numOfBytes)
        {
            // Console.WriteLine($"C Transferred bytes: {numOfBytes}");
        }
    }
}
