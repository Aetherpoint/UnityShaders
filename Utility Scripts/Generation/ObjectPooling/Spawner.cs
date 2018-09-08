using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Spawner : MonoBehaviour {

    private int timer = 0;

	// Update is called once per frame
	void FixedUpdate () {
        
        if (timer > 30) {
            timer = 0;
            ObjectPooler.Instance.SpawnFromPool("alphablock", transform.position, Quaternion.identity); 
        }
        else {
            timer++;
        }

    }
}
