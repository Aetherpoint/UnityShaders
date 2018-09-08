using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FadeOut : MonoBehaviour {

    public float killTime = 2f; // Seconds to read the text
    public Color currentColor;
    public Color colorFaded;

    private TextMesh text;
    private bool fading = false;

    float t = 0;
    private float duration = 11f;

    void Awake()
    {
        text = GetComponent<TextMesh>();
    }

    void Update()
    {
        if (t < 1)
        {
            text.color = Color.Lerp(currentColor, colorFaded, t);
            t += Time.deltaTime / duration;
        }
    }
}

