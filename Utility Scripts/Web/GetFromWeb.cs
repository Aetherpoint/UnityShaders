using UnityEngine;
using System.Collections;
using UnityEngine.Networking;

public class GetFromWeb : MonoBehaviour {

    public string webText;
    public string jsonSource = "http://aetherpoint.com/artext/items.json";
    private bool searching = true;
    private bool searchReady = true;
    public int searchingTime = 10;

	// Use this for initialization
	void Start () {
        StartCoroutine(SetTimer());
	}

    // Poll for data updates
    IEnumerator SetTimer() {
        while (searching == true) {

            Debug.Log("Attempting search " + searchReady);

            if (searchReady) {

                UnityWebRequest www = UnityWebRequest.Get(jsonSource);
                yield return www.SendWebRequest();

                if (www.isNetworkError || www.isHttpError) {
                    Debug.Log(www.error);
                }
                else {
                    // Show results as text
                    Debug.Log(www.downloadHandler.text);

                    // Or retrieve results as binary data
                    byte[] results = www.downloadHandler.data;

                    webText = www.downloadHandler.text;
                }

                yield return new WaitForSeconds(searchingTime);
            }
        }
    }


	private void Update()
	{
        gameObject.GetComponent<TextMesh>().text = webText;
	}
}
