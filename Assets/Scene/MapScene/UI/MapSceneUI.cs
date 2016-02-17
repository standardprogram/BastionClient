﻿using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class MapSceneUI : MonoBehaviour {

	bool _ShowTaskList = false;
	bool _ShowMsgList = false;

	float tipsShowTime;
	GUIContent tipsContent;
	
	// Use this for initialization
	void Start () {
		int scrW = Screen.width;
		int scrH = Screen.height;


		foreach (RawImage comp in FindObjectsOfType<RawImage>()) {
			Debug.Log(comp.name);
			if(comp.name.Equals("Avatar")) {
				comp.texture = Player.Instance.getAvatar();
			}
			else if(comp.name.Equals("EnergyBar")) {
				int currentEnergy = Player.Instance.getEnergy();
				int maxEnergy = Player.Instance.getEnergyMax();
				comp.texture = getEnergyBar(currentEnergy, maxEnergy);
			}
		
		}

		foreach(Text comp in FindObjectsOfType<Text> ()) {
			Debug.Log(comp.name);
			if(comp.name.Equals("Nickname")) {
				comp.text = Player.Instance.getNickName();
			}
			else if (comp.name.Equals("Level")) {
				comp.text = Player.Instance.getLevel().ToString();
			}
		}


	}

	void Update() {
		if (Input.GetKey (KeyCode.Escape))
			Application.Quit ();
	}
	

	private Texture getEnergyBar(int current,int max) {

		int barW = 360;
		int barH = 32;
		float q = current * barW / max;

		Texture2D texture = new Texture2D (barW, barH);


		for(int x=0; x < barW; x++) {
			for(int y = 0; y < barH; y++) {

				if(x < q){
					texture.SetPixel(x, y, Color.white);
				}
				else{
					texture.SetPixel(x,y, Color.blue);
				}
			}

		}
		texture.Apply ();
		return texture;
	}


}
