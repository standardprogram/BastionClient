using UnityEngine;
using System.Collections;

public class WorldMapScene : BaseScene {


	#region Mono
	// Use this for initialization
	void Start () {
		Debug.Log("WorldMapScene Start");

		InitUI ();
		LoadMapTexture ();

	}
	
	// Update is called once per frame
	void Update () {
	
	}

	#endregion



	#region UI

	private void InitUI(){


	}


	private void OnButtonClick() {

	}



	

	#endregion


	#region MAP
	private void LoadMapTexture() {
		GameObject obj = GameObject.FindGameObjectWithTag ("WorldMap");


		StartCoroutine (MapNet.Instance.DownloadMapTexture (108.977541f,34.170067f, obj));
	}



	private void OnMapLoaded() {

	}

	private void OnFingerInput() {
	
	}

	private void RotateMap() {
	
	}


	private void ZoomMap() {

	}

	#endregion



	#region Bastion

	private void InitBastions() {
		
	}
	#endregion
}
