using System;
using System.Collections.Generic;
using System.Text;
using DummyClient;
using ServerCore;

class PacketHandler
{
    public static void S_BroadcaseEnterGameHandler(PacketSession session, IPacket packet)
    {
        S_BroadcaseEnterGame bEnter = packet as S_BroadcaseEnterGame;
        ServerSession serverSession = session as ServerSession;
    }

    public static void S_BroadcaseLeaveGameHandler(PacketSession session, IPacket packet)
    {
        S_BroadcaseLeaveGame bLeave = packet as S_BroadcaseLeaveGame;
        ServerSession serverSession = session as ServerSession;
    }

    public static void S_PlayerListHandler(PacketSession session, IPacket packet)
    {
        S_PlayerList list = packet as S_PlayerList;
        ServerSession serverSession = session as ServerSession;
    }

    public static void S_BroadcaseMoveHandler(PacketSession session, IPacket packet)
    {
        S_BroadcaseMove move = packet as S_BroadcaseMove;
        ServerSession serverSession = session as ServerSession;
    }
}

