﻿using UnityEngine;
using System.Collections;

public class GameManager : MonoBehaviour {

	public enum GameScene {
		SCENE_INIT,
		SCENE_LOADING,
		SCENE_BASTION,
		SCENE_WORLDMAP,
		SCENE_BATTLE,

	};


	// Use this for initialization
	void Start () {
		GameObject gameManagerObj = GameObject.FindGameObjectWithTag ("GameManager");
		GameObject.DontDestroyOnLoad (gameManagerObj);
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetKey (KeyCode.Escape)) {
			Application.Quit ();
		}
	}

	#region Scene Manage
	static public void LoadScene(GameScene scene) {
		switch (scene) {
		case GameScene.SCENE_INIT:
			Application.LoadLevelAsync ("InitScene");

			break;
		case GameScene.SCENE_LOADING:
			Application.LoadLevel ("LoadScene");
			break;
		case GameScene.SCENE_BASTION:
			Application.LoadLevel ("BastionScene");
			break;

		case GameScene.SCENE_BATTLE:
			Application.LoadLevel ("BattleScene");
			break;
		case GameScene.SCENE_WORLDMAP:
			Application.LoadLevel ("WorldMapScene");
			break;
		}
	}
	

	#endregion


}
