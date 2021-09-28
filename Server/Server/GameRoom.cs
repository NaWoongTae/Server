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
        List<ArraySegment<byte>> _pendingList = new List<ArraySegment<byte>>();

        public void Push(Action job)
        {
            _jobQueue.Push(job);
        }

        public void Flush()
        {
            foreach (ClientSession s in _session)
            {
                s.Send(_pendingList);
            }

            // Console.WriteLine($"Flushed {_pendingList.Count} items");
            _pendingList.Clear();
        }

        public void Broadcase(ArraySegment<byte> segment)
        {
            _pendingList.Add(segment);            
        }

        public void Enter(ClientSession session)
        {
            // 플레이어 추가
            _session.Add(session);
            session.Room = this;

            // 신입생한테 모든 플레이어 목록 전송
            S_PlayerList players = new S_PlayerList();
            foreach (ClientSession s in _session)
            {
                players.players.Add(new S_PlayerList.Player() { 
                    isSelf = (s == session),
                    playerId = s.SessionId,
                    posX = s.PosX,
                    posY = s.PosY,
                    posZ = s.PosZ
                });
            }
            session.Send(players.Write());

            // 신입생 입장을 모두에게 알림
            S_BroadcaseEnterGame enter = new S_BroadcaseEnterGame();
            enter.playerId = session.SessionId;
            enter.posX = 0;
            enter.posY = 0;
            enter.posZ = 0;
            Broadcase(enter.Write());
        }

        public void Leave(ClientSession session)
        {
            // 플레이어 제거
            _session.Remove(session);

            // 모두에게 알림
            S_BroadcaseLeaveGame leave = new S_BroadcaseLeaveGame();
            leave.playerId = session.SessionId;
            Broadcase(leave.Write());
        }

        public void Move(ClientSession session, C_Move packet)
        {
            // 좌표
            session.PosX = packet.posX;
            session.PosY = packet.posY;
            session.PosZ = packet.posZ;

            // 모두에게 알림
            S_BroadcaseMove move = new S_BroadcaseMove();
            move.playerId = session.SessionId;
            move.posX = session.PosX;
            move.posY = session.PosY;
            move.posZ = session.PosZ;
            Broadcase(move.Write());
        }
    }
}
