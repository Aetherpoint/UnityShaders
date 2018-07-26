using UnityEngine;
using UnityEngine.Networking;

public class Populate : MonoBehaviour {

    public GameObject objectPrefab;
    public GameObject parentObj;

    private float spacing = 1;
    private int totalAmount = 15;

    // Furthest distance from one corner of the cube to the other
    public float furthestPointDist;

    void Awake()
    {
        for (int x = 0; x < totalAmount; x++)
        {
            for (int y = 0; y < totalAmount; y++)
            {
                for (int z = 0; z < totalAmount; z++)
                {
                    GameObject text = Instantiate(objectPrefab, new Vector3(x * spacing, y * spacing, z * spacing), Quaternion.identity);
                    text.transform.parent = parentObj.transform;
                }
            }
        }

        parentObj.transform.position = new Vector3((spacing * totalAmount) / -2, (spacing * totalAmount) / -2, (spacing * totalAmount) / -2);
    }

    // Do some math to measure the farthest away you can be from a given item?
    // Get the 
}



