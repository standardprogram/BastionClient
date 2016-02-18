using UnityEngine;
using System.Collections;
using LitJson;

public class Player {
	const int ICON_SIZE = 64;


	private static Player instance = new Player();

	private string uid; 
	private string openId;

	private string nickName;
	private string avatarUrl;
	private byte gender;
	private byte camp; 
	private int exp;
	private int level;
	private int energyMax;
	private int energy; 
	private float lat, lng;

	public static Player Instance {
		get{return instance;}
	}


	private Player() {
		//get uid


		//get player info
	}

	public void Load(string uid) {
		PlayerNet.Instance.GetPlayerInfo (uid, OnLoaded);
	}

	public void OnLoaded(JsonData data) {
		uid = data ["uid"];
		openId = data ["openid"];
		nickName = data["name"];
		level = data ["level"];
		gender = data ["gender"];
		camp = data ["camp"];
		exp = data["exp"];
		energy = data ["energy"];
		energyMax = data ["energymax"];

	}

	public string getNickName() {
		return nickName;
	}

	public Texture getAvatar() {
		Texture2D texture = new Texture2D (ICON_SIZE, ICON_SIZE);
		//texture.LoadImage (pngBytes);
		return texture;
	}

	public int getLevel() {
		return level;
	}

	public int getExp() {
		return exp;
	}

	public int getEnergy() {
		return energy;
	}

	public int getEnergyMax() {
		return energyMax;
	}

}
