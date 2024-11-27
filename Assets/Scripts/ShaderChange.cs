using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShaderChange : MonoBehaviour
{
    [SerializeField] private GameObject diffuse;
    [SerializeField] private GameObject ambientDiffuse;
    [SerializeField] private GameObject specular;
    [SerializeField] private GameObject textures;


    public void SetDiffuse()
    {
        diffuse.SetActive(true);
        ambientDiffuse.SetActive(false);
        specular.SetActive(false);
        textures.SetActive(false);
    }
    public void SetAmbientDiffuse()
    {
        ambientDiffuse.SetActive(true);
        diffuse.SetActive(false);
        specular.SetActive(false);
        textures.SetActive(false);
    }
    public void SetSpecular()
    {
        specular.SetActive(true);
        diffuse.SetActive(false);
        ambientDiffuse.SetActive(false);
        textures.SetActive(false);
    }

    public void SetTextures()
    {
        textures.SetActive(true);
        diffuse.SetActive(false);
        ambientDiffuse.SetActive(false);
        specular.SetActive(false);
    }
}
