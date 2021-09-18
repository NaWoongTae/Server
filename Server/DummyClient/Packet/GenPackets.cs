using System;
using System.Text;
using System.Collections.Generic;
using ServerCore;

// version 0.0.6

public enum PacketID 
{
	C_PlayerInfoReq = 1,
	S_Inventory = 2,
}

interface IPacket
{
	ushort Protocol { get; }
	void Read(ArraySegment<byte> segment);
	ArraySegment<byte> Write();
}

class C_PlayerInfoReq : IPacket
{
    public byte check;
	public int PlayerId;
	public string nicName;
	
	public class Weapon
	{
	    public byte equip;
		public short id;
		public int level;
		public string weaponName;
		
		public class Skill
		{
		    public int att;
			public int cost;
		
		    public void Read(ArraySegment<byte> segment, ref ushort count)
		    {
		        ReadOnlySpan<byte> s = new ReadOnlySpan<byte>(segment.Array, segment.Offset, segment.Count);
		
		        this.att = BitConverter.ToInt32(s.Slice(count, s.Length - count));
				count += sizeof(int);
				this.cost = BitConverter.ToInt32(s.Slice(count, s.Length - count));
				count += sizeof(int);
		    }
		
		    public bool Write(ArraySegment<byte> segment, ref ushort count)
		    {
		        Span<byte> s = new Span<byte>(segment.Array, segment.Offset, segment.Count);
		        bool success = true;
		
		        success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), this.att);
				count += sizeof(int);
				success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), this.cost);
				count += sizeof(int);
		
		        return success;
		    }
		}
		
		public List<Skill> skills = new List<Skill>();
	
	    public void Read(ArraySegment<byte> segment, ref ushort count)
	    {
	        ReadOnlySpan<byte> s = new ReadOnlySpan<byte>(segment.Array, segment.Offset, segment.Count);
	
	        this.equip = (byte)segment.Array[segment.Offset + count];
			count += sizeof(byte);
			this.id = BitConverter.ToInt16(s.Slice(count, s.Length - count));
			count += sizeof(short);
			this.level = BitConverter.ToInt32(s.Slice(count, s.Length - count));
			count += sizeof(int);
			ushort weaponNameLen = BitConverter.ToUInt16(s.Slice(count, s.Length - count));
			count += sizeof(ushort);
			weaponName = Encoding.Unicode.GetString(s.Slice(count, weaponNameLen));
			count += weaponNameLen;
			this.skills.Clear();
			ushort skillLen = BitConverter.ToUInt16(s.Slice(count, s.Length - count));
			count += sizeof(ushort);
			for (int i = 0; i < skillLen; i++)
			{
			    Skill skill = new Skill();
			    skill.Read(segment, ref count);
			    skills.Add(skill);
			}
	    }
	
	    public bool Write(ArraySegment<byte> segment, ref ushort count)
	    {
	        Span<byte> s = new Span<byte>(segment.Array, segment.Offset, segment.Count);
	        bool success = true;

			segment.Array[segment.Offset + count] = (byte)this.equip;
			count += sizeof(byte);
			success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), this.id);
			count += sizeof(short);
			success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), this.level);
			count += sizeof(int);
			ushort weaponNameLen = (ushort)Encoding.Unicode.GetBytes(this.weaponName, 0, this.weaponName.Length, segment.Array, segment.Offset + count + sizeof(ushort));
			success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), weaponNameLen);
			count += (ushort)(sizeof(ushort) + weaponNameLen);
			success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), (ushort)this.skills.Count);
			count += sizeof(ushort);
			foreach (Skill skill in this.skills)
			{
			    success &= skill.Write(segment, ref count);
			}
	
	        return success;
	    }
	}
	
	public List<Weapon> weapons = new List<Weapon>();

    public ushort Protocol { get => (ushort)PacketID.C_PlayerInfoReq; }

    public void Read(ArraySegment<byte> segment)
    {
        ushort count = 0;

        ReadOnlySpan<byte> s = new ReadOnlySpan<byte>(segment.Array, segment.Offset, segment.Count);
        count += sizeof(ushort);
        count += sizeof(ushort);

        this.check = (byte)segment.Array[segment.Offset + count];
		count += sizeof(byte);
		this.PlayerId = BitConverter.ToInt32(s.Slice(count, s.Length - count));
		count += sizeof(int);
		ushort nicNameLen = BitConverter.ToUInt16(s.Slice(count, s.Length - count));
		count += sizeof(ushort);
		nicName = Encoding.Unicode.GetString(s.Slice(count, nicNameLen));
		count += nicNameLen;
		this.weapons.Clear();
		ushort weaponLen = BitConverter.ToUInt16(s.Slice(count, s.Length - count));
		count += sizeof(ushort);
		for (int i = 0; i < weaponLen; i++)
		{
		    Weapon weapon = new Weapon();
		    weapon.Read(segment, ref count);
		    weapons.Add(weapon);
		}
    }

    public ArraySegment<byte> Write()
    {
        ArraySegment<byte> segment = SendBufferHelper.Open(4096);

        ushort count = 0;
        bool success = true;

        Span<byte> s = new Span<byte>(segment.Array, segment.Offset, segment.Count);

        count += sizeof(ushort);
        success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), (ushort)PacketID.C_PlayerInfoReq);
        count += sizeof(ushort);

        segment.Array[segment.Offset + count] = (byte)this.check;
		count += sizeof(byte);
		success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), this.PlayerId);
		count += sizeof(int);
		ushort nicNameLen = (ushort)Encoding.Unicode.GetBytes(this.nicName, 0, this.nicName.Length, segment.Array, segment.Offset + count + sizeof(ushort));
		success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), nicNameLen);
		count += (ushort)(sizeof(ushort) + nicNameLen);
		success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), (ushort)this.weapons.Count);
		count += sizeof(ushort);
		foreach (Weapon weapon in this.weapons)
		{
		    success &= weapon.Write(segment, ref count);
		}

        success &= BitConverter.TryWriteBytes(s, count);

        if (success == false)
            return null;

        return SendBufferHelper.Close(count);
    }
}
class S_Inventory : IPacket
{
    
	public class Item
	{
	    public string temName;
		public int count;
	
	    public void Read(ArraySegment<byte> segment, ref ushort count)
	    {
	        ReadOnlySpan<byte> s = new ReadOnlySpan<byte>(segment.Array, segment.Offset, segment.Count);
	
	        ushort temNameLen = BitConverter.ToUInt16(s.Slice(count, s.Length - count));
			count += sizeof(ushort);
			temName = Encoding.Unicode.GetString(s.Slice(count, temNameLen));
			count += temNameLen;
			this.count = BitConverter.ToInt32(s.Slice(count, s.Length - count));
			count += sizeof(int);
	    }
	
	    public bool Write(ArraySegment<byte> segment, ref ushort count)
	    {
	        Span<byte> s = new Span<byte>(segment.Array, segment.Offset, segment.Count);
	        bool success = true;
	
	        ushort temNameLen = (ushort)Encoding.Unicode.GetBytes(this.temName, 0, this.temName.Length, segment.Array, segment.Offset + count + sizeof(ushort));
			success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), temNameLen);
			count += (ushort)(sizeof(ushort) + temNameLen);
			success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), this.count);
			count += sizeof(int);
	
	        return success;
	    }
	}
	
	public List<Item> items = new List<Item>();

    public ushort Protocol { get => (ushort)PacketID.S_Inventory; }

    public void Read(ArraySegment<byte> segment)
    {
        ushort count = 0;

        ReadOnlySpan<byte> s = new ReadOnlySpan<byte>(segment.Array, segment.Offset, segment.Count);
        count += sizeof(ushort);
        count += sizeof(ushort);

        this.items.Clear();
		ushort itemLen = BitConverter.ToUInt16(s.Slice(count, s.Length - count));
		count += sizeof(ushort);
		for (int i = 0; i < itemLen; i++)
		{
		    Item item = new Item();
		    item.Read(segment, ref count);
		    items.Add(item);
		}
    }

    public ArraySegment<byte> Write()
    {
        ArraySegment<byte> segment = SendBufferHelper.Open(4096);

        ushort count = 0;
        bool success = true;

        Span<byte> s = new Span<byte>(segment.Array, segment.Offset, segment.Count);

        count += sizeof(ushort);
        success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), (ushort)PacketID.S_Inventory);
        count += sizeof(ushort);

        success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), (ushort)this.items.Count);
		count += sizeof(ushort);
		foreach (Item item in this.items)
		{
		    success &= item.Write(segment, ref count);
		}

        success &= BitConverter.TryWriteBytes(s, count);

        if (success == false)
            return null;

        return SendBufferHelper.Close(count);
    }
}