using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerManager
{
    MyPlayer _myPlayer;
    Material _myMat;
    Dictionary<int, Player> _otherPlayers = new Dictionary<int, Player>();

    public static PlayerManager Instance { get; } = new PlayerManager();
    GameObject _playerFab;
    GameObject PlayerFab 
    { 
        get
        {
            if (_playerFab == null)
            {
                _playerFab = Resources.Load<GameObject>("Player");
                _myMat = Resources.Load<Material>("myPlayer");
            }
            return _playerFab; 
        }
    }

    public void Add(S_PlayerList packet)
    {
        foreach (S_PlayerList.Player p in packet.players)
        {
            GameObject go = Object.Instantiate(PlayerFab);

            if (p.isSelf)
            {
                _myPlayer = go.AddComponent<MyPlayer>();
                _myPlayer.PlayerId = p.playerId;
                _myPlayer.GetComponent<MeshRenderer>().material = _myMat;
                _myPlayer.transform.position = new Vector3(p.posX, 1, p.posZ);
            }
            else
            {
                Player ply = go.AddComponent<Player>();
                ply.transform.position = new Vector3(p.posX, p.posY, p.posZ);
                _otherPlayers.Add(p.playerId, ply);
            }
        }
    }

    public void EnterGame(S_BroadcaseEnterGame packet)
    {
        if (packet.playerId == _myPlayer.PlayerId)
            return;

        GameObject go = Object.Instantiate(PlayerFab);

        Player ply = go.AddComponent<Player>();
        ply.transform.position = new Vector3(packet.posX, packet.posY, packet.posZ);
        _otherPlayers.Add(packet.playerId, ply);
    }

    public void LeaveGame(S_BroadcaseLeaveGame packet)
    {
        if (_myPlayer.PlayerId == packet.playerId)
        {
            GameObject.Destroy(_myPlayer.gameObject);
            _myPlayer = null;
        }
        else
        {
            Player ply = null;
            if (_otherPlayers.TryGetValue(packet.playerId, out ply))
            {
                GameObject.Destroy(ply.gameObject);
                _otherPlayers.Remove(packet.playerId);
            }
        }
    }

    public void Move(S_BroadcaseMove packet)
    {
        if (_myPlayer.PlayerId == packet.playerId)
        {
            _myPlayer.transform.position = new Vector3(packet.posX, packet.posY, packet.posZ);
        }
        else
        {
            Player ply = null;
            if (_otherPlayers.TryGetValue(packet.playerId, out ply))
            {
                ply.transform.position = new Vector3(packet.posX, packet.posY, packet.posZ);
            }
        }
    }
}
