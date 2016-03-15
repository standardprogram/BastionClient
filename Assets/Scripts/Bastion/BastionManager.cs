using System;using UnityEngine;using LitJson;public class BastionManager:MonoBehaviour{	private Lnglat lastReqPoint = null;		public void RefreshBastion(Lnglat lnglat) {		if (lastReqPoint == null || !MapTile.CacheContains (lastReqPoint)) {			BastionNet.Instance.GetNearbyBastions (lnglat, OnGetNearbyBastions);		}	}	private void OnGetNearbyBastions(JsonData data) {		Debug.Log ("OnGetNearbyBastions:"+data.ToJson());		JsonData list = data ["list"];		Debug.Log (list.Count);		for(int i = 0; i < list.Count; i++) {			Bastion bastion = new Bastion(list[i]);			MapTile tile = MapTile.FindFromCache(bastion.location);			if(tile != null) {				Debug.Log("11111");				GameObject bastionPrefab = Resources.Load("Prefabs/ModelPrefab/Bastion") as GameObject;				GameObject bastionObj = GameObject.Instantiate (bastionPrefab, tile.GetBastionPosition(bastion.location),Quaternion.identity) as GameObject;								if(tile.Quad != null) {					Debug.Log("2222");					bastionObj.transform.parent = tile.Quad.transform;									}			}		}	}}