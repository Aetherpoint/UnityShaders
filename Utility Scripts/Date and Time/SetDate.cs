using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System;
using TMPro;

public class SetDate : MonoBehaviour {
    
    private TextMeshPro textItem;

	// Use this for initialization
	void Start () {
        textItem = gameObject.GetComponent<TextMeshPro>();

        // 152072 (Hours) 71 (Minutes)  36 (Seconds)
        // Debug.Log("Cur time " + UnixTimeStampToDateTime(Epoch.Current()));
        // Debug.Log(Epoch.Current().ToLocalTime());
	}
	
	// Update is called once per frame
	void Update () {

        // Debug.Log(System.DateTime.Now.Hour);
        textItem.text = System.DateTime.Now.ToString("h:mm:ss tt");

        //Debug.Log(Epoch.Current().ToLocalTime());
	}
}
