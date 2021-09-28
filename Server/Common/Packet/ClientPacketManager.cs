using System;
using System.Collections.Generic;
using ServerCore;

// 21.09.28

public class PacketManager
{
    #region Singleton

    static PacketManager _instance = new PacketManager();
    public static PacketManager Instance { get { return _instance; } }

    #endregion

    PacketManager()
    {
        Register();
    }

    Dictionary<ushort, Func<PacketSession, ArraySegment<byte>, IPacket>> _makeFunc = new Dictionary<ushort, Func<PacketSession, ArraySegment<byte>, IPacket>>();
    Dictionary<ushort, Action<PacketSession, IPacket>> _handler = new Dictionary<ushort, Action<PacketSession, IPacket>>();

    public void Register()
    {
        _makeFunc.Add((ushort)PacketID.S_BroadcaseEnterGame, MakePacket<S_BroadcaseEnterGame>);
        _handler.Add((ushort)PacketID.S_BroadcaseEnterGame, PacketHandler.S_BroadcaseEnterGameHandler);
_makeFunc.Add((ushort)PacketID.S_BroadcaseLeaveGame, MakePacket<S_BroadcaseLeaveGame>);
        _handler.Add((ushort)PacketID.S_BroadcaseLeaveGame, PacketHandler.S_BroadcaseLeaveGameHandler);
_makeFunc.Add((ushort)PacketID.S_PlayerList, MakePacket<S_PlayerList>);
        _handler.Add((ushort)PacketID.S_PlayerList, PacketHandler.S_PlayerListHandler);
_makeFunc.Add((ushort)PacketID.S_BroadcaseMove, MakePacket<S_BroadcaseMove>);
        _handler.Add((ushort)PacketID.S_BroadcaseMove, PacketHandler.S_BroadcaseMoveHandler);
        
    }

    public void OnRecvPacket(PacketSession session, ArraySegment<byte> buffer, Action<PacketSession, IPacket> onRecvCallback = null)
    {
        ushort count = 0;
        ushort size = BitConverter.ToUInt16(buffer.Array, buffer.Offset);
        count += sizeof(ushort);
        ushort id = BitConverter.ToUInt16(buffer.Array, buffer.Offset + count);
        count += sizeof(ushort);

        Func<PacketSession, ArraySegment<byte>, IPacket> func = null;
        if (_makeFunc.TryGetValue(id, out func))
        {
            IPacket packet = func.Invoke(session, buffer);
            if (onRecvCallback != null)
                onRecvCallback.Invoke(session, packet);
            else
                HandlePacket(session, packet);
        }
    }

    T MakePacket<T>(PacketSession session, ArraySegment<byte> buffer) where T : IPacket, new()
    {
        T p = new T();
        p.Read(buffer);
        return p;
    }

    public void HandlePacket(PacketSession session, IPacket packet)
    {
        Action<PacketSession, IPacket> action = null;
        if (_handler.TryGetValue(packet.Protocol, out action))
            action.Invoke(session, packet);
    }
}