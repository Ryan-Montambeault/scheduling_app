//
//  TaskViewController.swift
//  Scheduling
//
//  Created by Glace on 2025-04-08.
//

import UIKit

enum TaskMode {
    case create
    case edit
    case view
}

protocol TaskViewControllerDelegate: AnyObject {
    func taskUpdated()
}

class TaskViewController: UIViewController {
    weak var delegate: TaskViewControllerDelegate?
    private let mode: TaskMode
    private let task: Task?
    private let userId: Int
    private let userName: String
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter Task Title"
        field.attributedPlaceholder = NSAttributedString(
            string: "Enter Task Title",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        field.borderStyle = .roundedRect
        field.backgroundColor = .appPrimary
        field.textColor = .white
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let descriptionTextView: UITextView = {
        let view = UITextView()
        view.font = .systemFont(ofSize: 16)
        view.backgroundColor = .appPrimary
        view.textColor = .white
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dueDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .compact
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let statusSegmentedControl: UISegmentedControl = {
        let items = ["Not Started", "In Progress", "Completed"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    init(mode: TaskMode, task: Task? = nil, userId: Int, userName: String) {
        self.mode = mode
        self.task = task
        self.userId = userId
        self.userName = userName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureForMode()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleTextField)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(dueDatePicker)
        contentView.addSubview(statusSegmentedControl)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 44),
            
            descriptionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            descriptionTextView.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 120),
            
            dueDatePicker.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20),
            dueDatePicker.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            dueDatePicker.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            
            statusSegmentedControl.topAnchor.constraint(equalTo: dueDatePicker.bottomAnchor, constant: 20),
            statusSegmentedControl.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            statusSegmentedControl.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            statusSegmentedControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        // Setup navigation bar
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        switch mode {
        case .create:
            title = "Create Task"
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTapped))
        case .edit:
            title = "Edit Task"
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTapped))
        case .view:
            title = "View Task"
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(cancelTapped))
        }
    }
    
    private func configureForMode() {
        switch mode {
        case .view:
            titleTextField.isEnabled = false
            descriptionTextView.isEditable = false
            dueDatePicker.isEnabled = false
            statusSegmentedControl.isEnabled = false
        case .edit, .create:
            titleTextField.isEnabled = true
            descriptionTextView.isEditable = true
            dueDatePicker.isEnabled = true
            statusSegmentedControl.isEnabled = true
        }
        
        if let task = task {
            titleTextField.text = task.title
            descriptionTextView.text = task.description
            if let dueDate = task.dueDate {
                dueDatePicker.date = dueDate
            }
            switch task.taskStatus {
            case "Not Started": statusSegmentedControl.selectedSegmentIndex = 0
            case "In Progress": statusSegmentedControl.selectedSegmentIndex = 1
            case "Completed": statusSegmentedControl.selectedSegmentIndex = 2
            default: break
            }
        }
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveTapped() {
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert(message: "Please enter a title")
            return
        }
        
        let description = descriptionTextView.text ?? ""
        let dueDate = dueDatePicker.date
        let status = ["Not Started", "In Progress", "Completed"][statusSegmentedControl.selectedSegmentIndex]
        
        if mode == .create {
            let request = TaskCreateRequest(
                userId: userId,
                title: title,
                description: description,
                dueDate: dueDate,
                taskStatus: status
            )
            
            TaskViewModel().createTask(userId: userId, request: request) { [weak self] success in
                if success {
                    self?.delegate?.taskUpdated()
                    self?.dismiss(animated: true)
                }
            }
        } else if mode == .edit, let task = task {
            let request = TaskUpdateRequest(
                id: task.id,
                userId: userId,
                taskId: task.id,
                title: title,
                description: description,
                dueDate: dueDate,
                taskStatus: status
            )
            
            TaskViewModel().updateTask(userId: userId, request: request) { [weak self] success in
                if success {
                    self?.delegate?.taskUpdated()
                    self?.dismiss(animated: true)
                }
            }
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
