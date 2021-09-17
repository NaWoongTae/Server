using System;
using System.Text;
using System.Net;
using System.Net.Sockets;
using System.Threading;
using System.Threading.Tasks;
using ServerCore;
using System.Collections.Generic;

namespace Server
{
    //public abstract class Packet
    //{
    //    public ushort size;
    //    public ushort packetId;

    //    public abstract ArraySegment<byte> Write();
    //    public abstract void Read(ArraySegment<byte> s);
    //}

	

	class ClientSession : PacketSession
    {
        public override void OnConnected(EndPoint endPoint)
        {
            Console.WriteLine($"OnConnected : {endPoint}");

            Thread.Sleep(5000);
            Disconnect();
        }

        public override void OnRecvPacket(ArraySegment<byte> buffer)
        {
            ushort count = 0;
            ushort size = BitConverter.ToUInt16(buffer.Array, buffer.Offset);
            count += sizeof(ushort);
            ushort id = BitConverter.ToUInt16(buffer.Array, buffer.Offset + count);
            count += sizeof(ushort);
            switch ((PacketID)id)
            {
                case PacketID.PlayerInfoReq:
                    {
                        PlayerInfoReq p = new PlayerInfoReq();
                        p.Read(buffer);

						Console.WriteLine($"플레이어 체크 : {p.check}");
						Console.WriteLine($"플레이어 ID : {p.PlayerId} // 닉네임 : {p.nicName}");
                        foreach (PlayerInfoReq.Weapon weapons in p.weapons)
                        {
							Console.WriteLine($"    ㄴ장비 ID : {weapons.id} // 장비레벨 : {weapons.level} // 장착여부 : {weapons.equip}");
							Console.WriteLine($"    ㄴ장비 스킬");
							for (int j = 0; j < weapons.skills.Count; j++)
							{
								Console.WriteLine($"        ㄴ공격력 : {weapons.skills[j].att} // 비용 : {weapons.skills[j].cost}");
							}							
						}
                    }
                    break;
            }

            Console.WriteLine($"RecvPacketId - size : {size}, id : {id}");
        }

        public override void OnDisconnected(EndPoint endPoint)
        {
            Console.WriteLine($"OnDisconnected : {endPoint}");
        }

        public override void OnSend(int numOfBytes)
        {
            Console.WriteLine($"Transferred bytes: {numOfBytes}");
        }
    }
}
