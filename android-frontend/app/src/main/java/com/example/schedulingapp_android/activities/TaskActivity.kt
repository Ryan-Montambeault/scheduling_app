package com.example.schedulingapp_android.activities

import android.os.Build
import android.os.Bundle
import android.util.Log
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.example.schedulingapp_android.R
import com.example.schedulingapp_android.data.models.Task
import com.example.schedulingapp_android.fragments.CreateTaskFragment
import com.example.schedulingapp_android.fragments.EditTaskFragment
import com.example.schedulingapp_android.fragments.ViewTaskFragment

class TaskActivity : AppCompatActivity() {
    private lateinit var modeHeaderTextView: TextView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_task)

        val mode = intent.getStringExtra("mode") ?: "View"
        val userId = intent.getIntExtra("userId", -1)
        val userName = intent.getStringExtra("userName") ?: "User"
        val task: Task? = intent.getSerializableExtra("task") as? Task

        modeHeaderTextView = findViewById(R.id.activity_task_header)
        modeHeaderTextView.text = getString(R.string.task_activity_mode, mode)

        val fragment = when (mode) {
            "Edit" -> task?.let { EditTaskFragment.newInstance(it, userName, userId) }
            "Create" -> CreateTaskFragment.newInstance(userName, userId)
            else -> task?.let { ViewTaskFragment.newInstance(it, userName, userId) }
        }

        if (fragment != null) {
            supportFragmentManager.beginTransaction()
                .replace(R.id.fragment_container, fragment)
                .commit()
        }
    }
}
