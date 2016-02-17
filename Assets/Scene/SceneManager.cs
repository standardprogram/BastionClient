using UnityEngine;
using System.Collections;

public class SceneManager : MonoBehaviour {


	public const int SID_MAP = 3;
	int currentScene;

	// Use this for initialization
	void Start () {
		//Save Root Obj
		GameObject root = GameObject.FindGameObjectWithTag ("Root");
		Object.DontDestroyOnLoad (root);

		currentScene = SID_MAP;
	}

	void Update() {
		if (Input.GetKey (KeyCode.Escape))
			Application.Quit ();
	}


	public void switchScene(int sceneId) 
	{
		Application.LoadLevel (sceneId);
		currentScene = sceneId;	
	}

}
