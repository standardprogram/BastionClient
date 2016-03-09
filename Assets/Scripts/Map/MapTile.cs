//------------------------------------------------------------------------------// <auto-generated>//     This code was generated by a tool.//     Runtime Version:4.0.30319.18408////     Changes to this file may cause incorrect behavior and will be lost if//     the code is regenerated.// </auto-generated>//------------------------------------------------------------------------------using System;using UnityEngine;public class MapTile{	//H_LAT = 1024/ 103/ 111.31955;	private Location center;	//图块中心经纬度	private double H_LAT, W_LNG;	private GameObject quad;	private Texture2D mapTexture;	//图块纹理	private bool isShown;	public MapTile (Location location, Texture2D texture)	{		center = location;		mapTexture = texture;		isShown = false;		H_LAT = 0.0089308190455455f;		W_LNG = H_LAT * Mathf.Cos(center.Latitude * Math.PI / 180);	}	public Texture2D Texture {		get { return mapTexture;}	}	public GameObject Quad {		get { return quad;}	}	public Vector3 GetBastionPosition(Location location) {		float dlng = location.Longitude - center.Longitude;		float dlat = location.Latitude - center.Latitude;		return new Vector3(dlng/W_LNG , dlat/H_LAT, -0.25f);	}	public static MapTile FindMapTile(Location location) {		return null;	}}