package com.example.schedulingapp_android.data.api

import com.example.schedulingapp_android.data.models.LoginRequest
import com.example.schedulingapp_android.data.models.LoginResponse
import com.example.schedulingapp_android.data.models.Task
import com.example.schedulingapp_android.data.models.TaskCreateRequest
import com.example.schedulingapp_android.data.models.TaskCreateResponse
import com.example.schedulingapp_android.data.models.TaskUpdateRequest
import retrofit2.Response
import retrofit2.http.Body
import retrofit2.http.DELETE
import retrofit2.http.GET
import retrofit2.http.POST
import retrofit2.http.PUT
import retrofit2.http.Path

interface ApiService {
    // Login
    @POST("authentication/login")
    suspend fun login(@Body credentials: LoginRequest): Response<LoginResponse>

    // Logout
    @POST("authentication/logout")
    suspend fun logout(): Response<Void>

    // Fetch all tasks
    @GET("users/{userId}/tasks/")
    suspend fun getAllTasks(@Path("userId") userId: Int): Response<List<Task>>

    // Fetch a single task
    @GET("users/{userId}/tasks/{taskId}/")
    suspend fun getTaskById(
        @Path("userId") userId: Int,
        @Path("taskId") taskId: Int
    ): Response<Task>

    // Fetch tasks not started
    @GET("users/{userId}/tasks-not-started/")
    suspend fun getTasksNotStarted(@Path("userId") userId: Int): Response<List<Task>>

    // Fetch tasks in progress
    @GET("users/{userId}/tasks-in-progress/")
    suspend fun getTasksInProgress(@Path("userId") userId: Int): Response<List<Task>>

    // Fetch completed tasks
    @GET("users/{userId}/tasks-completed/")
    suspend fun getCompletedTasks(@Path("userId") userId: Int): Response<List<Task>>

    // Create a task
    @POST("users/{userId}/create-task/")
    suspend fun createTask(
        @Path("userId") userId: Int,
        @Body task: TaskCreateRequest
    ): Response<TaskCreateResponse>

    // Edit a task
    @PUT("users/{userId}/tasks/{taskId}/edit/")
    suspend fun updateTask(
        @Path("userId") userId: Int,
        @Path("taskId") taskId: Int,
        @Body task: TaskUpdateRequest
    ): Response<Void>

    // Delete a task
    @DELETE("users/{userId}/tasks/{taskId}/delete/")
    suspend fun deleteTask(
        @Path("userId") userId: Int,
        @Path("taskId") taskId: Int
    ): Response<Void>
}
