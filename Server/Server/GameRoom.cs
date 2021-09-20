using ServerCore;
using System;
using System.Collections.Generic;
using System.Text;

namespace Server
{
    class GameRoom : IJobQueue
    {
        List<ClientSession> _session = new List<ClientSession>();
        JobQueue _jobQueue = new JobQueue();

        public void Push(Action job)
        {
            _jobQueue.Push(job);
        }

        public void Broadcase(ClientSession session, string chat)
        {
            S_Chat packet = new S_Chat();
            packet.playerId = session.SessionId;
            packet.chat = $"{packet.playerId} : {chat}";

            ArraySegment<byte> segment = packet.Write();

            foreach (ClientSession s in _session)
            {
                s.Send(segment);
            }
        }

        public void Enter(ClientSession session)
        {
            _session.Add(session);
            session.Room = this;
        }

        public void Leave(ClientSession session)
        {
            _session.Remove(session);
        }
    }
}
