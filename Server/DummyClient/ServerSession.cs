using System;
using System.Text;
using System.Net;
using System.Net.Sockets;
using System.Threading;
using ServerCore;
using System.Collections.Generic;

namespace DummyClient
{
	//public abstract class Packet
	//{
	//    public ushort size;
	//    public ushort packetId;

	//    public abstract ArraySegment<byte> Write();
	//    public abstract void Read(ArraySegment<byte> s);
	//}

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

	class ServerSession : Session
    {
        public override void OnConnected(EndPoint endPoint)
        {
            Console.WriteLine($"OnConnected : {endPoint}");

            PlayerInfoReq packet = new PlayerInfoReq() { playerId = 1001, name = "마릴린" };
            {
				List<PlayerInfoReq.Skill.Attribute> att = new List<PlayerInfoReq.Skill.Attribute>();
				att.Add(new PlayerInfoReq.Skill.Attribute() { att = 15, cool = 1.5f });
				att.Add(new PlayerInfoReq.Skill.Attribute() { att = 10, cool = 1.1f });
				packet.skills.Add(new PlayerInfoReq.Skill() { id = 10151, level = 6, duration = 0.34f, 
					attributes = att });
				List<PlayerInfoReq.Skill.Attribute> att2 = new List<PlayerInfoReq.Skill.Attribute>();
				att.Add(new PlayerInfoReq.Skill.Attribute() { att = 135, cool = 1.25f });
				att.Add(new PlayerInfoReq.Skill.Attribute() { att = 510, cool = 41.1f });
				packet.skills.Add(new PlayerInfoReq.Skill() { id = 14758, level = 1, duration = 7.24f,
					attributes = att2
				});
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
