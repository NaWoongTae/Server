using System;
using System.Collections.Generic;
using System.Text;
using DummyClient;
using ServerCore;
using UnityEngine;

class PacketHandler
{
    public static void S_ChatHandler(PacketSession session, IPacket packet)
    {
        S_Chat p = packet as S_Chat;
        ServerSession serverSession = session as ServerSession;

        if (p.playerId < 3)
            Debug.Log(p.playerId + " : " + p.chat);
    }
}

