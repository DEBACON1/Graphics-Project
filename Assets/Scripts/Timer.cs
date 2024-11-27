using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Timer : MonoBehaviour
{
    [SerializeField] private Material color;
    public float _float;

    void Update()
    {
        _float -= Time.deltaTime;
        color.SetFloat("_float", _float);
    }
}
