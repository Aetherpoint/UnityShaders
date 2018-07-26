using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Text.RegularExpressions;

public class TransformJson : MonoBehaviour {

    private GetFromWeb getFromWeb;

    private PopulateData populateData;
    private PopulateMeshes populateMeshes;
    private PopulateLines populateLines;
    private GameObject itemSpawner;

    [Multiline]
    private string testString;

    [Multiline]
    private string jsonString;

    [Multiline]
    private string jsonStringProcessed;

    //[Multiline]
    //public string jsonStringTextTestOutput;

    // Current Data
    public int itemNum; // Number of features
    public long itemLastGenerated; // Last time since generation
    public long currentGenerated; // Current time of generation
    public string title; // Title of dataset

    public bool readyForMoreData = true;
    private bool labelContainersSet = false;

    ProceduralBarGraphCube proceduralBarGraphCube;
    int count = 0;

    public List<Features> featureList; // Title of dataset
    // public List<Coordinates> coordinates; // Title of dataset

	// Use this for initialization
	void Awake () {
        // Get the components we need
        getFromWeb = gameObject.GetComponent<GetFromWeb>();
        itemSpawner = GameObject.FindWithTag("ItemSpawner");

        // populateData = itemSpawner.GetComponent<PopulateData>(); // Siesmic Spawner
        // populateLines = itemSpawner.GetComponent<PopulateLines>(); // Line Spawner
        populateMeshes = itemSpawner.GetComponent<PopulateMeshes>();

        proceduralBarGraphCube = itemSpawner.GetComponent<ProceduralBarGraphCube>();

	}

    // Take the JSON String ahead of time and apply regexes
    // Current we’re having trouble accessing a top level Array without its own properties
    // TODO: This is currently frail and only works with specific JSON
    public string ModifyJson(string json) {

        // These section takes the coordinates and converts them into a string
        // to sidestep JSON restrictions
        string updatedJSON = json.Replace("\"coordinates\":[", "\"coordinates\":\"");
        updatedJSON = updatedJSON.Replace("]},\"id\"", "\"},\"id\"");

        return updatedJSON;
    }


	// Update is called once per frame
	void Update () {

        // Get the string we got from our request
        jsonString = getFromWeb.webText;

        // Only process the text if it’s not an empty string
        if (jsonString != "") {

            // Process the JSON string
            // We're doing some replacements to sidestep arrays
            jsonStringProcessed = ModifyJson(jsonString);

            // Constantly update to current update
            itemLastGenerated = JsonUtility.FromJson<JsonTemplate>(jsonStringProcessed).metadata.generated;

            // Wait on setting updates until we know that the JSON we have client side has changed
            if (currentGenerated != itemLastGenerated) {

                Debug.Log("Update – " + itemLastGenerated + " x " + currentGenerated);
                
                // Refresh data
                itemNum = JsonUtility.FromJson<JsonTemplate>(jsonStringProcessed).metadata.count;

                currentGenerated = JsonUtility.FromJson<JsonTemplate>(jsonStringProcessed).metadata.generated;;
                title = JsonUtility.FromJson<JsonTemplate>(jsonStringProcessed).metadata.title;

                featureList = JsonUtility.FromJson<JsonTemplate>(jsonStringProcessed).features;

                // Update the view to a new set of datapoints
                // populateData.SetDataPoints();

                // Store data
                // populateLines.StoreData();
                // populateMeshes.StoreData();

                // Render the new items
                // populateLines.SetDataPoints();

                // Every time we have updated data
                // then send it to populateMeshes which can instantiate the next set of 
                // meshes with the proper data along with the total set cycle time of things as they get updated
                // populateMeshes.SetDataPoints();
            }

            // Setup the label containers for the datapoints
            if (labelContainersSet == false) {
                populateMeshes.InitDataLabelContainers();

                labelContainersSet = true;
            }

            // If we're ready to render the next set of datapoints, then do it!
            if (readyForMoreData == true) {
                readyForMoreData = false;

                populateMeshes.orderDataPoints();
                populateMeshes.SetDataPoints();
                populateMeshes.SetDataLabels();
            }

            // Why do we need this?
            if (count == 0) {
                populateMeshes.orderDataPoints();
                populateMeshes.SetDataPoints();
                populateMeshes.SetDataLabels();
                count++;
            }
        }
	}
}
