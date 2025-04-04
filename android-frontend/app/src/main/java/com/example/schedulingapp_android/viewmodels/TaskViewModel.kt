package com.example.schedulingapp_android.viewmodels

import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.schedulingapp_android.data.api.RetrofitClient
import com.example.schedulingapp_android.data.models.Task
import com.example.schedulingapp_android.data.models.TaskCreateRequest
import com.example.schedulingapp_android.data.models.TaskCreateResponse
import com.example.schedulingapp_android.data.models.TaskUpdateRequest
import kotlinx.coroutines.launch

class TaskViewModel : ViewModel() {
    private val _tasks = MutableLiveData<List<Task>>()
    val tasks: LiveData<List<Task>> get() = _tasks

    fun getAllTasksForUser(userId: Int) {
        viewModelScope.launch {
            try {
                val response = RetrofitClient.apiService.getAllTasks(userId)
                if (response.isSuccessful) {
                    _tasks.postValue(response.body())
                } else {
                    _tasks.postValue(emptyList())
                    Log.e("TaskViewModel", "Failed to fetch user's tasks: ${response.errorBody()?.string()}")
                }
            } catch (e: Exception) {
                _tasks.postValue(emptyList())
                Log.e("TaskViewModel", "Error fetching user's tasks: ${e.message}", e)
            }
        }
    }

    fun getNotStartedTasks(userId: Int) {
        viewModelScope.launch {
            try {
                val response = RetrofitClient.apiService.getTasksNotStarted(userId)
                if (response.isSuccessful) {
                    _tasks.postValue(response.body())
                } else {
                    _tasks.postValue(emptyList())
                }
            } catch (e: Exception) {
                _tasks.postValue(emptyList())
            }
        }
    }

    fun getInProgressTasks(userId: Int) {
        viewModelScope.launch {
            try {
                val response = RetrofitClient.apiService.getTasksInProgress(userId)
                if (response.isSuccessful) {
                    _tasks.postValue(response.body())
                } else {
                    _tasks.postValue(emptyList())
                }
            } catch (e: Exception) {
                _tasks.postValue(emptyList())
            }
        }
    }

    fun getCompletedTasks(userId: Int) {
        viewModelScope.launch {
            try {
                val response = RetrofitClient.apiService.getCompletedTasks(userId)
                if (response.isSuccessful) {
                    _tasks.postValue(response.body())
                } else {
                    _tasks.postValue(emptyList())
                }
            } catch (e: Exception) {
                _tasks.postValue(emptyList())
            }
        }
    }

    fun createTask(userId: Int, task: TaskCreateRequest) {
        viewModelScope.launch {
            try {
                val response = RetrofitClient.apiService.createTask(userId, task)
                if (response.isSuccessful) {
                    val taskCreateResponse = response.body()
                    taskCreateResponse?.let {
                        val newTaskId = it.taskId

                        val taskResponse = RetrofitClient.apiService.getTaskById(userId, newTaskId)
                        if (taskResponse.isSuccessful) {
                            val newTask = taskResponse.body()

                            newTask?.let {
                                val updatedTaskList =
                                    _tasks.value?.toMutableList() ?: mutableListOf()
                                updatedTaskList.add(it)
                                _tasks.postValue(updatedTaskList)
                            }
                        } else {
                            Log.e("TaskViewModel", "Failed to fetch newly created task: ${taskResponse.errorBody()?.string()}")
                        }
                    } ?: run {
                        Log.e("TaskViewModel", "Failed to get taskId from response")
                    }
                } else {
                    Log.e("TaskViewModel", "Failed to create task: ${response.errorBody()?.string()}")
                }
            } catch (e: Exception) {
                Log.e("TaskViewModel", "Error creating task: ${e.message}", e)
            }
        }
    }

    fun editTask(userId: Int, taskId: Int, taskUpdateRequest: TaskUpdateRequest) {
        viewModelScope.launch {
            try {
                val response = RetrofitClient.apiService.updateTask(userId, taskId, taskUpdateRequest)
                if (response.isSuccessful) {
                    getAllTasksForUser(userId)
                } else {
                    Log.e("TaskViewModel", "Failed to edit task: ${response.errorBody()?.string()}")
                }
            } catch (e: Exception) {
                Log.e("TaskViewModel", "Error editing task: ${e.message}", e)
            }
        }
    }

    fun deleteTask(userId: Int, taskId: Int) {
        viewModelScope.launch {
            try {
                val response = RetrofitClient.apiService.deleteTask(userId, taskId)
                if (response.isSuccessful) {
                    _tasks.postValue(_tasks.value?.filter { it.id != taskId })
                } else {
                    Log.e("TaskViewModel", "Failed to delete task: ${response.errorBody()?.string()}")
                }
            } catch (e: Exception) {
                Log.e("TaskViewModel", "Error deleting task: ${e.message}", e)
            }
        }
    }
}
