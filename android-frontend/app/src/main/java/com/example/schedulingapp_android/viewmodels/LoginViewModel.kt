package com.example.schedulingapp_android.viewmodels

import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.schedulingapp_android.data.api.RetrofitClient
import com.example.schedulingapp_android.data.models.LoginRequest
import com.example.schedulingapp_android.data.models.LoginResponse
import kotlinx.coroutines.launch

class LoginViewModel : ViewModel() {
    private val _loginResult = MutableLiveData<LoginResponse?>()
    val loginResult: LiveData<LoginResponse?> get() = _loginResult

    private val _logoutResult = MutableLiveData<Boolean>()
    val logoutResult: LiveData<Boolean> get() = _logoutResult

    fun loginUser(email: String, password: String) {
        viewModelScope.launch {
            try {
                val response = RetrofitClient.apiService.login(LoginRequest(email, password))

                if (response.isSuccessful) {
                    Log.d("Login", "Login successful: ${response.body()}")
                    _loginResult.postValue(response.body())
                } else {
                    Log.e("Login", "Login failed. Response code: ${response.code()}, ${response.message()}")
                    _loginResult.postValue(null)
                }
            } catch (e: Exception) {
                Log.e("Login", "Error: ${e.message}")
                _loginResult.postValue(null)
            }
        }
    }

    fun logoutUser() {
        viewModelScope.launch {
            try {
                // Call the API to perform logout
                val response = RetrofitClient.apiService.logout()

                // If logout is successful, post true to indicate success
                _logoutResult.postValue(true)
            } catch (e: Exception) {
                // If logout fails, post false to indicate failure
                _logoutResult.postValue(false)
            }
        }
    }
}
