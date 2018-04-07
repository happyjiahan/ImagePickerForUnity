using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using PTSun;
using UnityEngine.UI;

namespace OneSight.UI
{
    public class GameRoot : MonoBehaviour
    {
        public RawImage img;


        public void openAlbum()
        {
            PTImagePicker picker = GameObject.Find("PTImagePicker").GetComponent<PTImagePicker>();
            picker.PickImage(imageBytes =>
            {
                Texture2D tex = new Texture2D(1, 1);
                tex.LoadImage(imageBytes);
                img.texture = tex;
            });
        }
    }
}