package com.example.schedulingapp_android.data.models

import java.sql.Timestamp

data class Task(
    val id: Int,
    val title: String,
    val description: String,
    val dateCreated: Timestamp,
    val dueDate: Timestamp,
    val dateCompleted: Timestamp,
    val taskStatus: String,
    val userId: Int
)
