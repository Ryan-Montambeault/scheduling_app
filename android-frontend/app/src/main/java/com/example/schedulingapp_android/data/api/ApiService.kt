package com.example.schedulingapp_android.data.api

import com.example.schedulingapp_android.data.models.LoginRequest
import com.example.schedulingapp_android.data.models.LoginResponse
import com.example.schedulingapp_android.data.models.Task
import com.example.schedulingapp_android.data.models.TaskRequest
import com.example.schedulingapp_android.data.models.TaskResponse
import com.example.schedulingapp_android.data.models.TaskUpdateRequest
import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.DELETE
import retrofit2.http.GET
import retrofit2.http.POST
import retrofit2.http.PUT
import retrofit2.http.Path

interface ApiService {
    // login
    @POST("authentication/login")
    suspend fun login(@Body credentials: LoginRequest): Call<LoginResponse>

    // logout
    @POST("authentication/logout")
    suspend fun logout(): Call<Void>

    // fetch all tasks for a user
    @GET("users/{userId}/tasks/")
    suspend fun getAllTasks(@Path("userId") userId: Int): Call<List<Task>>

    // fetch a single task
    @GET("users/{userId}/tasks/{taskId}/")
    suspend fun getTaskById(@Path("userId") userId: Int, @Path("taskId") taskId: Int): Call<Task>

    // fetch filtered tasks
    @GET("users/{userId}/{filter}/")
    suspend fun getFilteredTasks(@Path("userId") userId: Int, @Path("filter") filter: String): Call<List<Task>>

    // create a task
    @POST("users/{userId}/create-task/")
    suspend fun createTask(@Path("userId") userId: Int, @Body task: TaskRequest): Call<TaskResponse>

    // edit a task
    @PUT("users/{userId}/tasks/{taskId}/edit/")
    suspend fun updateTask(
        @Path("userId") userId: Int,
        @Path("taskId") taskId: Int,
        @Body task: TaskUpdateRequest
    ): Call<Void>

    // delete a task
    @DELETE("users/{userId}/tasks/{taskId}/delete/")
    suspend fun deleteTask(@Path("userId") userId: Int, @Path("taskId") taskId: Int): Call<Void>
}
