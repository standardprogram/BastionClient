using UnityEngine;
using System.Text;

public class PlayerNet {

	private const int CMD_GET_PLAYER_INFO = 1001;

	public static PlayerNet Instance {get {return playernet;}}
	private static PlayerNet playernet = new PlayerNet();


	public void GetPlayerInfo(string uid) {
		byte[] content = Encoding.UTF8.GetBytes(uid);
		Network.Instance.SendMsg (content, CMD_GET_PLAYER_INFO);
	}
}
