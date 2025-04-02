package com.example.schedulingapp_android.activities

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.example.schedulingapp_android.R
import com.example.schedulingapp_android.data.adapters.TaskAdapter
import com.example.schedulingapp_android.data.models.Task
import com.example.schedulingapp_android.viewmodels.TaskViewModel

class MainActivity : AppCompatActivity() {
    private lateinit var taskAdapter: TaskAdapter
    private lateinit var recyclerView: RecyclerView
    private lateinit var taskViewModel: TaskViewModel
    private lateinit var welcomeTextView: TextView
    private lateinit var notStartedButton: Button
    private lateinit var inProgressButton: Button
    private lateinit var completedButton: Button
    private lateinit var addTaskButton: Button
    private var userId: Int = -1
    private var userName: String = ""

    // Track the current filter state (null means "show all tasks")
    private var currentFilter: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // Get userId and userName from Intent
        userId = intent.getIntExtra("userId", -1)
        userName = intent.getStringExtra("userName") ?: "User"

        // Set welcome text
        welcomeTextView = findViewById(R.id.activity_main_header)
        welcomeTextView.text = getString(R.string.welcome_header, userName)

        // Initialize RecyclerView
        recyclerView = findViewById(R.id.recyclerViewTasks)
        taskAdapter = TaskAdapter(mutableListOf(), ::openEditTaskActivity, ::deleteTask, ::openTaskActivity)

        recyclerView.apply {
            layoutManager = LinearLayoutManager(this@MainActivity)
            adapter = taskAdapter
        }

        // Initialize ViewModel
        taskViewModel = ViewModelProvider(this)[TaskViewModel::class.java]

        // Observe tasks LiveData
        taskViewModel.tasks.observe(this) { taskList ->
            taskAdapter.updateTasks(taskList.toMutableList())
        }

        // Fetch user's tasks
        taskViewModel.getAllTasksForUser(userId)

        // Initialize buttons and set click listeners
        notStartedButton = findViewById(R.id.activity_main_not_started_button)
        notStartedButton.setOnClickListener {
            taskViewModel.getNotStartedTasks(userId)
            welcomeTextView.text = getString(R.string.tasks_not_started_header)
        }

        inProgressButton = findViewById(R.id.activity_main_in_progress_button)
        inProgressButton.setOnClickListener {
            taskViewModel.getInProgressTasks(userId)
            welcomeTextView.text = getString(R.string.tasks_in_progress_header)
        }

        completedButton = findViewById(R.id.activity_main_completed_button)
        completedButton.setOnClickListener {
            taskViewModel.getCompletedTasks(userId)
            welcomeTextView.text = getString(R.string.tasks_completed_header)
        }

        addTaskButton = findViewById(R.id.activity_main_add_task_button)
        addTaskButton.setOnClickListener {
            openCreateTaskActivity()
        }

        // Set up toggle behavior for each status filter button
        setupFilterButton(notStartedButton, "not_started", R.string.tasks_not_started_header)
        setupFilterButton(inProgressButton, "in_progress", R.string.tasks_in_progress_header)
        setupFilterButton(completedButton, "completed", R.string.tasks_completed_header)
    }

    // Open TaskActivity in "view" mode when a task is clicked on
    private fun openTaskActivity(task: Task) {
        val intent = Intent(this, TaskActivity::class.java).apply {
            putExtra("taskId", task.id)
            putExtra("userId", userId)
            putExtra("mode", "view")
        }
        startActivity(intent)
    }

    // Open TaskActivity in "edit" mode when edit button is clicked
    private fun openEditTaskActivity(task: Task) {
        val intent = Intent(this, TaskActivity::class.java).apply {
            putExtra("taskId", task.id)
            putExtra("userId", userId)
            putExtra("mode", "edit")
        }
        startActivity(intent)
    }

    // Open TaskActivity in "create" mode when add button is clicked
    private fun openCreateTaskActivity() {
        val intent = Intent(this, TaskActivity::class.java).apply {
            putExtra("userId", userId)
            putExtra("mode", "create")
        }
        startActivity(intent)
    }

    // Delete task when delete button is clicked
    private fun deleteTask(task: Task) {
        taskAdapter.removeTask(task)
        taskViewModel.deleteTask(userId, task.id)
    }

    private fun setupFilterButton(button: Button, status: String, headerResId: Int) {
        button.setOnClickListener {
            if (currentFilter == status) {
                // If already filtering by this status, reset to default (show all tasks)
                taskViewModel.getAllTasksForUser(userId)
                welcomeTextView.text = getString(R.string.welcome_header, userName)
                currentFilter = null
            } else {
                // Otherwise, filter tasks by the selected status
                when (status) {
                    "not_started" -> taskViewModel.getNotStartedTasks(userId)
                    "in_progress" -> taskViewModel.getInProgressTasks(userId)
                    "completed" -> taskViewModel.getCompletedTasks(userId)
                }
                welcomeTextView.text = getString(headerResId)
                currentFilter = status
            }
        }
    }
}
