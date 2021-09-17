using System;
using System.Text;
using System.Net;
using System.Net.Sockets;
using System.Threading;
using ServerCore;
using System.Collections.Generic;

namespace DummyClient
{
	class ServerSession : Session
    {
        public override void OnConnected(EndPoint endPoint)
        {
            Console.WriteLine($"OnConnected : {endPoint}");

            PlayerInfoReq packet = new PlayerInfoReq() { PlayerId = 1001, nicName = "마릴린" };
            {
				List<PlayerInfoReq.Weapon.Skill> att = new List<PlayerInfoReq.Weapon.Skill>();
				att.Add(new PlayerInfoReq.Weapon.Skill() { att = 15, cost = 17 });
				att.Add(new PlayerInfoReq.Weapon.Skill() { att = 10, cost = 52 });
                packet.weapons.Add(new PlayerInfoReq.Weapon() { equip = 2, id = 10151, level = 6, weaponName = "망치", skills = att });
				List<PlayerInfoReq.Weapon.Skill> att2 = new List<PlayerInfoReq.Weapon.Skill>();
				att.Add(new PlayerInfoReq.Weapon.Skill() { att = 135, cost = 67 });
				att.Add(new PlayerInfoReq.Weapon.Skill() { att = 510, cost = 521 });
                packet.weapons.Add(new PlayerInfoReq.Weapon() { equip = 1, id = 14758, level = 1, weaponName = "칼치", skills = att2 });
			}

            ArraySegment<byte> s = packet.Write();

            if (s != null)
                Send(s);            
        }

        public override void OnDisconnected(EndPoint endPoint)
        {
            Console.WriteLine($"OnDisconnected : {endPoint}");
        }

        public override int OnRecv(ArraySegment<byte> buffer)
        {
            string recv = Encoding.UTF8.GetString(buffer.Array, buffer.Offset, buffer.Count);
            Console.WriteLine($"[From Server] {recv}");

            return buffer.Count;
        }

        public override void OnSend(int numOfBytes)
        {
            Console.WriteLine($"Transferred bytes: {numOfBytes}");
        }
    }
}
