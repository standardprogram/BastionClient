//------------------------------------------------------------------------------
// <auto-generated>
//     此代码由工具生成。
//     运行时版本:4.0.30319.1026
//
//     对此文件的更改可能会导致不正确的行为，并且如果
//     重新生成代码，这些更改将会丢失。
// </auto-generated>
//------------------------------------------------------------------------------
using System;
using UnityEngine;
using System.Collections;

public class ScreenLog :MonoBehaviour
{

	GUIStyle style;
	static SortedList rects;
	static SortedList contents;

	static int w, h;
	static int lineH;

	public ScreenLog(){
		reset ();
	}

	public void Start ()
	{
		w = Screen.width;
		h = Screen.height;
		lineH = h / 16 + 5;

		style = new GUIStyle ();
		style.alignment = TextAnchor.UpperLeft;
		style.fontSize = h / 16;
		style.normal.textColor = new Color (0.6f, 0.6f, 0.9f, 1.0f);
	}


	public static void println(string tag, string str) {
		if (!rects.ContainsKey (tag)) {
			Rect rect = new Rect (0, rects.Count * lineH, w, lineH);
			rects [tag] = rect;
			contents [tag] = str;
		} else {
			contents[tag] = str;
		}
	}

	public static void reset() {
		rects = new SortedList();
		contents = new SortedList();
	}

	void OnGUI ()
	{
		foreach (string key in rects.Keys) {
			GUI.Label ((Rect)rects[key], (string)key+": "+(string)contents[key], style);
		}

	}

}


