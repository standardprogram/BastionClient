using System;using System.Collections.Generic;using UnityEngine;public class MapManager:MonoBehaviour{	private MapNet net;	private Texture2D curTexture;	private List<Location> DownloadingList;	public void Awake() {		net = new MapNet ();		DownloadingList = new List<Location>();	}	public void RefreshMap(Location location) {		MapTile tile = MapTile.FindMapTile ();		if (tile == null) {			tile = MapTile.LoadFromFile(location);		}		if (tile == null) {			if(NeedDownloading(location)) {				StartCoroutine (net.DownloadMapTile (location, OnMapTileDownloaded));				DownloadingList.Add(location);			}		} else {			ShowMapTile (tile);		}	}	private bool NeedDownloading(Location location) {		foreach (Location a in DownloadingList) {			if(location.IsNearbyWith(a)) {				return false;			}		}		return true;	}	private void ShowMapTile(MapTile tile) {		GameObject obj = GameObject.FindGameObjectWithTag ("WorldMap");		if (obj != null) {			obj.renderer.material.mainTexture = tile.Texture;		}		MapTile.AddToCache (tile);	}	public void OnMapTileDownloaded(MapTile tile) {				ShowMapTile (tile);		}}