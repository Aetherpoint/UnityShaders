using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class PostEffect : MonoBehaviour
{

    public Material mat;

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        // src is the fully rendered scene that you would normally send directly to the monitor
        // we are intercepting so we can do a bit more work before passing it on

        // PRETENDING TO DO IMAGE EFFECT IN CPU

        Graphics.Blit(src, dest, mat);
    }

}
