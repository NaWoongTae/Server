using ServerCore;
using System;
using System.Collections.Generic;
using System.Text;

namespace Server
{
    class PacketHandler
    {
        public static void PlayerInfoReqHandler(PacketSession session, IPacket packet)
        {
            PlayerInfoReq p = packet as PlayerInfoReq;

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
    }
}
