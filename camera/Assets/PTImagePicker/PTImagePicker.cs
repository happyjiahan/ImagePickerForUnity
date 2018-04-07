using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;
using UnityEngine.Events;

namespace PTSun
{
    public class PTImagePicker : MonoBehaviour
    {
        [DllImport("__Internal")]
        private static extern void PickImageFromPhotoLibrary();
        
        private UnityAction<byte[]> m_completion;

        public void PickImage(UnityAction<byte[]> completion)
        {
            m_completion = completion;
            
            PickImageFromPhotoLibrary(); 
        }


        void OnImagePickerCompleted(string imageDataBase64String)
        {
            byte[] imageBytes = null;
            
            if (!string.IsNullOrEmpty(imageDataBase64String))   
            {
                imageBytes = System.Convert.FromBase64String(imageDataBase64String);
            }

            if (m_completion != null)
            {
                m_completion(imageBytes);
            }
        }
    }
}