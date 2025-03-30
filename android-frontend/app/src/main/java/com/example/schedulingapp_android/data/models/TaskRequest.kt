package com.example.schedulingapp_android.data.models

import java.sql.Timestamp

data class TaskRequest(
    val userId: Int,
    val title: String,
    val description: String,
    val dueDate: Timestamp
)
