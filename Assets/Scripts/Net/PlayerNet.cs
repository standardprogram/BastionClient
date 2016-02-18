using UnityEngine;
using System;
using System.Text;
using System.Collections.Generic;
using LitJson;
using Bastion.Net;

public class PlayerNet {

	private const int CMD_GET_PLAYER_INFO = 1001;

	public static PlayerNet Instance {get {return playernet;}}
	private static PlayerNet playernet = new PlayerNet();
	private Dictionary<string, Action<JsonData>> Requesters;

	private PlayerNet() {
		
		Requesters = new Dictionary<string, Action<JsonData>> ();

	}

	public void GetPlayerInfo(int uid, Action<JsonData> action) {

		NetRequest req = new NetRequest ();

		Network.Instance.SendRequest(req);

		Requesters.Add (req.SerialNo, action);
	}

	public void OnReceivedResponse(JsonData data) {
		string id = data ["reqid"];
		Action<string> action = Requesters [id];
		action (data);
	}
}
