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
                    _loginResult.postValue(response.body())
                } else {
                    _loginResult.postValue(null)
                }
            } catch (e: Exception) {
                _loginResult.postValue(null)
            }
        }
    }

    fun logoutUser() {
        viewModelScope.launch {
            try {
                val response = RetrofitClient.apiService.logout()
                _logoutResult.postValue(true)
            } catch (e: Exception) {
                _logoutResult.postValue(false)
            }
        }
    }
}
