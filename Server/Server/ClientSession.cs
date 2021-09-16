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
    public abstract class Packet
    {
        public ushort size;
        public ushort packetId;

        public abstract ArraySegment<byte> Write();
        public abstract void Read(ArraySegment<byte> s);
    }

	public enum PacketID
	{
		PlayerInfoReq = 1,
		TestPacket = 2,
	}

	class PlayerInfoReq
	{
		public byte check;
		public long playerId;
		public string name;

		public class Skill
		{
			public int id;
			public short level;
			public float duration;

			public class Attribute
			{
				public int att;
				public float cool;

				public void Read(ReadOnlySpan<byte> s, ref ushort count)
				{
					this.att = BitConverter.ToInt32(s.Slice(count, s.Length - count));
					count += sizeof(int);
					this.cool = BitConverter.ToSingle(s.Slice(count, s.Length - count));
					count += sizeof(float);
				}

				public bool Write(Span<byte> s, ref ushort count)
				{
					bool success = true;
					success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), this.att);
					count += sizeof(int);
					success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), this.cool);
					count += sizeof(float);

					return success;
				}
			}

			public List<Attribute> attributes = new List<Attribute>();

			public void Read(ReadOnlySpan<byte> s, ref ushort count)
			{
				this.id = BitConverter.ToInt32(s.Slice(count, s.Length - count));
				count += sizeof(int);
				this.level = BitConverter.ToInt16(s.Slice(count, s.Length - count));
				count += sizeof(short);
				this.duration = BitConverter.ToSingle(s.Slice(count, s.Length - count));
				count += sizeof(float);
				this.attributes.Clear();
				ushort attributeLen = BitConverter.ToUInt16(s.Slice(count, s.Length - count));
				count += sizeof(ushort);
				for (int i = 0; i < attributeLen; i++)
				{
					Attribute attribute = new Attribute();
					attribute.Read(s, ref count);
					attributes.Add(attribute);
				}
			}

			public bool Write(Span<byte> s, ref ushort count)
			{
				bool success = true;
				success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), this.id);
				count += sizeof(int);
				success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), this.level);
				count += sizeof(short);
				success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), this.duration);
				count += sizeof(float);
				success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), (ushort)this.attributes.Count);
				count += sizeof(ushort);
				foreach (Attribute attribute in this.attributes)
				{
					success &= attribute.Write(s, ref count);
				}

				return success;
			}
		}

		public List<Skill> skills = new List<Skill>();

		public void Read(ArraySegment<byte> segment)
		{
			ushort count = 0;

			ReadOnlySpan<byte> s = new ReadOnlySpan<byte>(segment.Array, segment.Offset, segment.Count);
			count += sizeof(ushort);
			count += sizeof(ushort);

			this.check = (byte)segment.Array[segment.Offset + count];
			count += sizeof(byte);
			this.playerId = BitConverter.ToInt64(s.Slice(count, s.Length - count));
			count += sizeof(long);
			ushort nameLen = BitConverter.ToUInt16(s.Slice(count, s.Length - count));
			count += sizeof(ushort);
			name = Encoding.Unicode.GetString(s.Slice(count, nameLen));
			count += nameLen;
			this.skills.Clear();
			ushort skillLen = BitConverter.ToUInt16(s.Slice(count, s.Length - count));
			count += sizeof(ushort);
			for (int i = 0; i < skillLen; i++)
			{
				Skill skill = new Skill();
				skill.Read(s, ref count);
				skills.Add(skill);
			}
		}

		public ArraySegment<byte> Write()
		{
			ArraySegment<byte> segment = SendBufferHelper.Open(4096);

			ushort count = 0;
			bool success = true;

			Span<byte> s = new Span<byte>(segment.Array, segment.Offset, segment.Count);

			count += sizeof(ushort);
			success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), (ushort)PacketID.PlayerInfoReq);
			count += sizeof(ushort);

			segment.Array[segment.Offset + count] = (byte)this.check;
			count += sizeof(byte);
			success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), this.playerId);
			count += sizeof(long);
			ushort nameLen = (ushort)Encoding.Unicode.GetBytes(this.name, 0, this.name.Length, segment.Array, segment.Offset + count + sizeof(ushort));
			success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), nameLen);
			count += (ushort)(sizeof(ushort) + nameLen);
			success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), (ushort)this.skills.Count);
			count += sizeof(ushort);
			foreach (Skill skill in this.skills)
			{
				success &= skill.Write(s, ref count);
			}

			success &= BitConverter.TryWriteBytes(s, count);

			if (success == false)
				return null;

			return SendBufferHelper.Close(count);
		}
	}	

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
						Console.WriteLine($"플레이어 ID : {p.playerId} // 닉네임 : {p.name}");
						for (int i = 0; i < p.skills.Count; i++)
						{
							Console.WriteLine($"    ㄴ스킬 키 : {p.skills[i].id} // 스킬레벨 : {p.skills[i].level} // 쿨타임 : {p.skills[i].duration}");
							Console.WriteLine($"    ㄴ스킬 속성");
							for (int j = 0; j < p.skills[i].attributes.Count; j++)
							{
								Console.WriteLine($"        ㄴ공격력 : {p.skills[i].attributes[j].att} // 시전시간 : {p.skills[i].attributes[j].cool}");
							}							
						}

						foreach (PlayerInfoReq.Skill info in p.skills)
                        {
                            Console.WriteLine($"{info.id} [{info.level}] left : {info.duration}초... ");
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
