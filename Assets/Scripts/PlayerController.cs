using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using TMPro;
// This script controles the player, and manages the collectables text
public class PlayerController : MonoBehaviour
{
    public float speed = 0;
    private Rigidbody rb;
    private float movementX;
    private float movementY;
    private float jumpForce = 2;

    

    void Start()
    {
        rb = GetComponent<Rigidbody>();
 
    }
    

    private void FixedUpdate()
    {
        Vector3 movement = new Vector3(movementX, 0.0f, movementY);
        rb.AddForce(movement * speed);
        
    }
        
    void OnMove(InputValue movementValue)
    {
        Vector2 movementVector = movementValue.Get<Vector2>();
        movementX = movementVector.x;
        movementY = movementVector.y;
    }
    
    void OnJump(InputValue movementValue)
    {
        rb.AddForce(Vector3.up * jumpForce, ForceMode.Impulse);
    }

}
