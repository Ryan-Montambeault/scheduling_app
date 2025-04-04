package com.example.schedulingapp_android.fragments

import android.app.DatePickerDialog
import android.app.TimePickerDialog
import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import android.widget.Button
import android.widget.EditText
import android.widget.ImageView
import android.widget.Spinner
import androidx.fragment.app.Fragment
import com.example.schedulingapp_android.R
import com.example.schedulingapp_android.activities.MainActivity
import com.example.schedulingapp_android.data.models.TaskCreateRequest
import java.sql.Timestamp
import java.util.Calendar

class CreateTaskFragment : Fragment() {

    private lateinit var userName: String
    private var userId: Int = -1

    private lateinit var titleEditText: EditText
    private lateinit var descriptionEditText: EditText
    private lateinit var dueDateEditText: EditText
    private lateinit var statusSpinner: Spinner

    private lateinit var cancelButton: Button
    private lateinit var doneButton: Button

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        arguments?.let {
            userId = it.getInt("userId")
            userName = it.getString("userName") ?: "User"
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.fragment_edit_create_task, container, false)

        // Initialize the views
        titleEditText = view.findViewById(R.id.fragment_edit_create_task_title)
        descriptionEditText = view.findViewById(R.id.fragment_edit_create_task_description)
        dueDateEditText = view.findViewById(R.id.edit_text_task_due_date)
        statusSpinner = view.findViewById(R.id.spinner_task_status)

        cancelButton = view.findViewById(R.id.button_cancel)
        doneButton = view.findViewById(R.id.button_done)

        // Initialize status spinner
        val statusList = listOf("Not Started", "In Progress", "Completed")
        val statusAdapter = ArrayAdapter(requireContext(), R.layout.spinner_item, statusList)
        statusAdapter.setDropDownViewResource(R.layout.spinner_dropdown_item)
        statusSpinner.adapter = statusAdapter

        // Set up the date and time picker for due date
        val dueDateIcon: ImageView = view.findViewById(R.id.button_calendar)
        dueDateIcon.setOnClickListener {
            showDateTimePicker()
        }

        // Cancel button listener
        cancelButton.setOnClickListener {
            activity?.onBackPressed()
        }

        // Done button listener
        doneButton.setOnClickListener {
            val taskTitle = titleEditText.text.toString()
            val taskDescription = descriptionEditText.text.toString()
            val taskDueDate: Timestamp? = if (dueDateEditText.text.isNullOrEmpty()) {
                null
            } else {
                Timestamp.valueOf(dueDateEditText.text.toString())
            }
            val taskStatus = statusSpinner.selectedItem.toString()

            // Create TaskCreateRequest object
            val taskCreateRequest = TaskCreateRequest(
                userId = userId,
                title = taskTitle,
                description = taskDescription,
                dueDate = taskDueDate,
                taskStatus = taskStatus
            )

            // Send the new task to MainActivity
            val intent = Intent(activity, MainActivity::class.java).apply {
                putExtra("createdTask", taskCreateRequest)
                putExtra("fragmentStatus", "Created Task")
                putExtra("userId", userId)
                putExtra("userName", userName)
            }
            intent.flags = Intent.FLAG_ACTIVITY_CLEAR_TOP
            startActivity(intent)
            activity?.finish()
        }

        return view
    }

    private fun showDateTimePicker() {
        val calendar = Calendar.getInstance()

        val datePickerDialog = DatePickerDialog(requireContext(),
            { _, year, month, dayOfMonth ->
                val pickedDate = Calendar.getInstance()
                pickedDate.set(Calendar.YEAR, year)
                pickedDate.set(Calendar.MONTH, month)
                pickedDate.set(Calendar.DAY_OF_MONTH, dayOfMonth)

                // After selecting date, show time picker
                TimePickerDialog(requireContext(),
                    { _, hourOfDay, minute ->
                        pickedDate.set(Calendar.HOUR_OF_DAY, hourOfDay)
                        pickedDate.set(Calendar.MINUTE, minute)

                        // Format and display in EditText
                        val timestamp = Timestamp(pickedDate.timeInMillis)
                        dueDateEditText.setText(timestamp.toString())
                    },
                    calendar.get(Calendar.HOUR_OF_DAY),
                    calendar.get(Calendar.MINUTE),
                    true
                ).show()
            },
            calendar.get(Calendar.YEAR),
            calendar.get(Calendar.MONTH),
            calendar.get(Calendar.DAY_OF_MONTH)
        )

        datePickerDialog.show()
    }

    companion object {
        fun newInstance(userName: String, userId: Int): CreateTaskFragment {
            val fragment = CreateTaskFragment()
            val args = Bundle().apply {
                putInt("userId", userId)
                putString("userName", userName)
            }
            fragment.arguments = args
            return fragment
        }
    }
}
