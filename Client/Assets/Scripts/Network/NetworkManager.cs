﻿using DummyClient;
using ServerCore;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Net;
using UnityEngine;

public class NetworkManager : MonoBehaviour
{
    ServerSession _session = new ServerSession();

    public void Send(ArraySegment<byte> sendBuffer)
    {
        _session.Send(sendBuffer);
    }

    void Start()
    {
        string host = Dns.GetHostName();
        IPHostEntry ipHost = Dns.GetHostEntry(host);
        IPAddress ipAddr = ipHost.AddressList[0];
        IPEndPoint endPoint = new IPEndPoint(ipAddr, 7777);

        Connector connector = new Connector();

        connector.Connect(endPoint, () => { return _session; }, 1);
    }

    void Update()
    {
        List<IPacket> packetlist = PacketQueue.Instance.PopAll();
        foreach (IPacket packet in packetlist)
        {
            PacketManager.Instance.HandlePacket(_session, packet);
        }
    }

    
}
