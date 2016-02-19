using UnityEngine;using System.Collections;using LitJson;public class Player {	const int ICON_SIZE = 64;	private static Player instance = new Player();	private int uid; 	private string openId;	private string nickName;	private string avatarUrl;	private byte gender;	private byte camp; 	private int exp;	private short level;	private int energyMax;	private int energy; 	private float lat, lng;	public static Player Instance {		get{return instance;}	}	private Player() {		//get uid		//get player info	}	public void Load(int uid) {		PlayerNet.Instance.GetPlayerInfo (uid, OnLoaded);	}	public void OnLoaded(JsonData data) {		uid = int.Parse(data ["uid"].ToString ());		openId = data ["openid"].ToString();		nickName = data["name"].ToString();		level = short.Parse(data ["level"].ToString());		gender = byte.Parse(data ["gender"].ToString());		camp = byte.Parse(data ["camp"].ToString());		exp = int.Parse(data["exp"].ToString());		energy = int.Parse(data ["energy"].ToString());		energyMax = int.Parse(data ["energymax"].ToString());		Debug.Log("Got it");	}	public string getNickName() {		return nickName;	}	public Texture getAvatar() {		Texture2D texture = new Texture2D (ICON_SIZE, ICON_SIZE);		//texture.LoadImage (pngBytes);		return texture;	}	public int getLevel() {		return level;	}	public int getExp() {		return exp;	}	public int getEnergy() {		return energy;	}	public int getEnergyMax() {		return energyMax;	}}