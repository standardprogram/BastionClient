using UnityEngine;
using System.Collections;

public class MapNet {

	private const string AMAP_URL = "http://restapi.amap.com/v3/staticmap";
	private const string AMAP_KEY = "3e552f61928bb5d072cd83d18b00858f";
	private const int AMAP_SIZE = 1024;

	public static MapNet Instance  {get {return mapnet;}}

	private static MapNet mapnet = new MapNet();
		
	public IEnumerator DownloadMapTexture(float lng,float lat, GameObject obj) {
		//string url = "http://restapi.amap.com/v3/staticmap?location=108.977541,34.170067&zoom=16&size=1024*1024&markers=mid,,A:116.481485,39.990464&key=3e552f61928bb5d072cd83d18b00858f";


		string key = string.Format ("key={0}", AMAP_KEY);
		string location = string.Format ("location={0},{1}", lng, lat);
		string zoom = string.Format ("zoom={0}", 16);
		string size = string.Format("size={0}*{1}", AMAP_SIZE, AMAP_SIZE);

		//makers
		//labels
		//paths

		string url = string.Format ("{0}?{1}&{2}&{3}&{4}", AMAP_URL, key, location, zoom, size);
		Debug.Log (url);
		WWW www = new WWW(url);

		yield return www;

		if(www.isDone) {
			obj.renderer.material.mainTexture = www.texture;
		}

	}



}
