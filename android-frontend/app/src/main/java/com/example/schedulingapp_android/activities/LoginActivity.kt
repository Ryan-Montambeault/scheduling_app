package com.example.schedulingapp_android.activities

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import com.example.schedulingapp_android.R
import com.example.schedulingapp_android.data.models.LoginResponse
import com.example.schedulingapp_android.viewmodels.LoginViewModel

class LoginActivity : AppCompatActivity() {
    private lateinit var loginViewModel: LoginViewModel
    private lateinit var emailEditText: EditText
    private lateinit var passwordEditText: EditText
    private lateinit var loginButton: Button

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_login)

        // Initialize UI components and ViewModel
        emailEditText = findViewById(R.id.activity_login_email_field)
        passwordEditText = findViewById(R.id.activity_login_password_field)
        loginButton = findViewById(R.id.activity_login_button)
        loginViewModel = ViewModelProvider(this)[LoginViewModel::class.java]

        // Set login state observer
        loginViewModel.loginResult.observe(this) { response ->
            response?.let {
                val userId = it.userId
                val userName = it.userName
                val message = it.message

                Toast.makeText(this, message, Toast.LENGTH_SHORT).show()

                // Navigate to MainActivity and pass user data
                val intent = Intent(this, MainActivity::class.java).apply {
                    putExtra("userId", userId)
                    putExtra("userName", userName)
                }
                startActivity(intent)
                finish()
            } ?: run {
                // Login failed, show an error message
                Toast.makeText(this, "Login failed. Please try again.", Toast.LENGTH_SHORT).show()
            }
        }

        // Login button click listener
        loginButton.setOnClickListener {
            val userEmail = emailEditText.text.toString()
            val userPassword = passwordEditText.text.toString()

            if (userEmail.isBlank() || userPassword.isBlank()) {
                Toast.makeText(this, "Email and password required.", Toast.LENGTH_SHORT).show()
            } else {
                loginViewModel.loginUser(userEmail, userPassword)
            }
        }
    }
}
