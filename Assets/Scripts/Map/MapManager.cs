using System;using System.Collections.Generic;using UnityEngine;public class MapManager:MonoBehaviour{	private MapNet net;	private Dictionary<Location, Texture2D> mapCache;		public void Awake() {		net = new MapNet ();		mapCache = new Dictionary<Location, Texture2D> ();	}	public void RequestMap(float lng, float lat) {		GameObject obj = GameObject.FindGameObjectWithTag ("WorldMap");		if (obj == null) {			Debug.Log ("Can't find WorldMap Obj");			return;		}		Location loc = new Location (lng, lat);		Texture2D texture = findMapInCache (loc);		if (texture != null) {			obj.renderer.material.mainTexture = texture;		} else {			StartCoroutine(net.DownloadMapTexture (loc, obj));		}	}	private Texture2D findMapInCache(Location loc) {		foreach (Location other in mapCache.Keys) {			if (loc.GetDistance(other) < 1.5f) {				return mapCache[other];			}		}		return null;	}}