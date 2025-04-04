package com.example.schedulingapp_android.fragments

import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.TextView
import androidx.fragment.app.Fragment
import com.example.schedulingapp_android.R
import com.example.schedulingapp_android.activities.MainActivity
import com.example.schedulingapp_android.data.models.Task

class ViewTaskFragment : Fragment() {

    private var task: Task? = null
    private var userName: String? = null
    private var userId: Int? = -1

    private lateinit var backButton: Button

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        task = arguments?.getSerializable("task") as? Task
        userName = arguments?.getString("userName", "User") ?: "User"
        userId = arguments?.getInt("userId", -1)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.fragment_view_task, container, false)

        val titleTextView: TextView = view.findViewById(R.id.fragment_view_task_title)
        val descriptionTextView: TextView = view.findViewById(R.id.fragment_view_task_description)
        val dueDateTextView: TextView = view.findViewById(R.id.fragment_view_task_due_date)
        val statusTextView: TextView = view.findViewById(R.id.fragment_view_task_status)
        backButton = view.findViewById(R.id.fragment_view_task_back_button)

        // Set task details in the UI
        task?.let {
            titleTextView.text = it.title
            descriptionTextView.text = it.description
            dueDateTextView.text = it.dueDate.toString()
            statusTextView.text = it.taskStatus
        }

        backButton.setOnClickListener {
            // Close the current fragment and launch MainActivity
            val intent = Intent(activity, MainActivity::class.java).apply {
                putExtra("userName", userName)
                putExtra("userId", userId)
                putExtra("task", task)
            }
            intent.flags = Intent.FLAG_ACTIVITY_CLEAR_TOP
            startActivity(intent)
            activity?.finish()
        }

        return view
    }

    companion object {
        fun newInstance(task: Task, userName: String, userId: Int): ViewTaskFragment {
            val fragment = ViewTaskFragment()
            val args = Bundle().apply {
                putSerializable("task", task)
                putString("userName", userName)
                putInt("userId", userId)
            }
            fragment.arguments = args
            return fragment
        }
    }
}
