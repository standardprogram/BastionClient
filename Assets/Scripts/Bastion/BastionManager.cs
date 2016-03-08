//------------------------------------------------------------------------------// <auto-generated>//     This code was generated by a tool.//     Runtime Version:4.0.30319.18408////     Changes to this file may cause incorrect behavior and will be lost if//     the code is regenerated.// </auto-generated>//------------------------------------------------------------------------------using System;using UnityEngine;using LitJson;public class BastionManager:MonoBehaviour{	private Location lastLocation;		public void RefreshBastion(Location focusedLocation) {		if (lastLocation == null || focusedLocation.GetDistance(lastLocation) > 0.1f) {			BastionNet.Instance.GetNearbyBastions (focusedLocation, OnGetNearbyBastions);			lastLocation = focusedLocation;		} 	}	private void OnGetNearbyBastions(JsonData data) {		Debug.Log ("OnGetNearbyBastions:"+data.ToJson());		JsonData list = data ["list"];		for(int i = 0; i < list.Count; i++) {			Bastion bastion = new Bastion(list[i]);			MapTile tile = MapTile.FindMapTile (bastion.location);				GameObject bastionObj = GameObject.Instantiate ("Prefabs/ModelPrefab/Bastion");			if(tile.Quad != null) {				bastionObj.transform.parent = tile.Quad;				bastionObj.transform.localPosition = tile.GetBastionPosition(bastion.location);			}		}	}}