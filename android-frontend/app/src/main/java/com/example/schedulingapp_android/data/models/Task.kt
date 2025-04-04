package com.example.schedulingapp_android.data.models

import com.google.gson.annotations.SerializedName
import java.io.Serializable
import java.sql.Timestamp

data class Task(
    val id: Int,
    val title: String,
    val description: String,
    @SerializedName("date_created") val dateCreated: String,
    @SerializedName("due_date") val dueDate: Timestamp,
    @SerializedName("date_completed") val dateCompleted: Timestamp,
    @SerializedName("task_status") val taskStatus: String,
    @SerializedName("user_id") val userId: Int
) : Serializable
