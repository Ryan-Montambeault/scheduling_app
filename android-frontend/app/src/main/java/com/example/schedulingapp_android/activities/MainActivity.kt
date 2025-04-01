package com.example.schedulingapp_android.activities

import android.os.Bundle
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.example.schedulingapp_android.R

class MainActivity: AppCompatActivity() {
    private lateinit var welcomeTextView: TextView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        welcomeTextView = findViewById(R.id.activity_main_header)

        // Retrieve the userId passed from LoginActivity
        val userId = intent.getIntExtra("userId", -1)
        if (userId == -1) {
            // Handle error if no userId is passed
            Toast.makeText(this, "User ID not found", Toast.LENGTH_SHORT).show()
            return
        }
    }
}