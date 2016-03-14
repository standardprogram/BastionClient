﻿using UnityEngine;using System;using System.Collections;using System.Collections.Generic;public class MapNet {	//"http://restapi.amap.com/v3/staticmap?location=108.977541,34.170067&zoom=16&size=1024*1024&markers=mid,,A:116.481485,39.990464&key=3e552f61928bb5d072cd83d18b00858f";	private const string AMAP_URL = "http://restapi.amap.com/v3/staticmap";	private const string AMAP_KEY = "3e552f61928bb5d072cd83d18b00858f";	private const int AMAP_SIZE = 1024;	private const int ZOOM_LV = 16;	public IEnumerator DownloadMapTile(Lnglat lnglat, Action<MapTile, int> action) {		Debug.Log ("DownloadMapTile");		MapTile tile = new MapTile (lnglat);		MapTile.AddToCache (tile, 0);		string key = string.Format ("key={0}", AMAP_KEY);		string location = string.Format ("location={0},{1}", lnglat.Longitude, lnglat.Latitude);		string zoom = string.Format ("zoom={0}", ZOOM_LV);		string size = string.Format("size={0}*{1}", AMAP_SIZE, AMAP_SIZE);		//makers		//labels		//paths		string url = string.Format ("{0}?{1}&{2}&{3}&{4}", AMAP_URL, key, location, zoom, size);		Debug.Log (url);		WWW www = new WWW(url);		yield return www;		if(www.isDone && www.texture != null) {			tile.Texture = www.texture;			tile.IsDownloading = false;			action(tile, 0);		}		yield break ;	}}