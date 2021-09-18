using System;
using System.Collections.Generic;
using System.Text;
using ServerCore;

class PacketHandler
{
    public static void C_PlayerInfoReqHandler(PacketSession session, IPacket packet)
    {
        C_PlayerInfoReq p = packet as C_PlayerInfoReq;

        Console.WriteLine($"플레이어 체크 : {p.check}");
        Console.WriteLine($"플레이어 ID : {p.PlayerId} // 닉네임 : {p.nicName}");
        foreach (C_PlayerInfoReq.Weapon weapons in p.weapons)
        {
            Console.WriteLine($"    ㄴ장비 ID : {weapons.id} // 장비레벨 : {weapons.level} // 장착여부 : {weapons.equip}");
            Console.WriteLine($"    ㄴ장비 스킬");
            for (int j = 0; j < weapons.skills.Count; j++)
            {
                Console.WriteLine($"        ㄴ공격력 : {weapons.skills[j].att} // 비용 : {weapons.skills[j].cost}");
            }
        }
    }

    public static void S_InventoryHandler(PacketSession session, IPacket packet)
    {
        S_Inventory p = packet as S_Inventory;

        foreach (S_Inventory.Item i in p.items)
            Console.WriteLine($"인벤 체크 : {i.temName}");
    }
}

