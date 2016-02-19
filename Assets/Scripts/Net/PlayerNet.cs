﻿using UnityEngine;using System;using System.Text;using System.Collections.Generic;using LitJson;using Bastion.Net;public class PlayerNet {	private const int CMD_GET_PLAYER_INFO = 1001;	public static PlayerNet Instance {get {return playernet;}}	private static PlayerNet playernet = new PlayerNet();	private Dictionary<int, Action<JsonData>> Requesters;	private JsonData jsonData;	private PlayerNet() {				Requesters = new Dictionary<int, Action<JsonData>> ();		jsonData = new JsonData ();	}	public void GetPlayerInfo(int uid, Action<JsonData> action) {		NetRequest req = new NetRequest (1001);		req.AddParam ("uid", uid);		int hashCode = req.GetHashCode ();		req.AddParam ("reqcode", hashCode);		Network.Instance.SendRequest(req);		if(!Requesters.ContainsKey(hashCode))			Requesters.Add (hashCode, action);	}	public void OnReceivedResponse(JsonData data) {		int code = int.Parse(data ["reqcode"].ToString());		Action<JsonData> action = Requesters [code];		action (data);		Requesters.Remove (code);	}}