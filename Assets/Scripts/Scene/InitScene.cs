﻿using UnityEngine;using System.Collections;public class InitScene : BaseScene {	// Use this for initialization	void Start () {		Debug.Log("InitScene Start");		GameObject.FindGameObjectWithTag ("GameManager").GetComponent<GameManager> ().LoadScene (GameManager.GameScene.SCENE_WORLDMAP);		Player.Instance.Load(1);	}		// Update is called once per frame	void Update () {		}	}