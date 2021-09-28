using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MyPlayer : Player
{
    NetworkManager _net;

    private void Start()
    {
        _net = GameObject.Find("NetworkManager").GetComponent<NetworkManager>();
        StartCoroutine(CoSendPacket());
    }

    IEnumerator CoSendPacket()
    {
        yield return new WaitForSeconds(1f);

        while (true)
        {
            yield return new WaitForSeconds(0.25f);

            C_Move movePack = new C_Move();
            Vector3 vec = Random.insideUnitSphere * 50f;
            movePack.posX = vec.x;
            movePack.posY = 1f;
            movePack.posZ = vec.z;

            _net.Send(movePack.Write());
        }
    }
}
