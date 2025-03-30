package com.example.schedulingapp_android.data.models

import java.sql.Timestamp

data class TaskUpdateRequest(
    val userId: Int,
    val taskId: Int,
    val title: String,
    val description: String,
    val dueDate: Timestamp,
    val taskStatus: String
)
