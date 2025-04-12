//
//  MainViewController.swift
//  Scheduling
//
//  Created by Glace on 2025-04-08.
//
        
import UIKit

class MainViewController: UIViewController {
    private let viewModel = TaskViewModel()
    private let userId: Int
    private let userName: String
    private var currentFilter: String? = nil
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let logoutImage = UIImage(systemName: "rectangle.portrait.and.arrow.right", withConfiguration: config)
        button.setImage(logoutImage, for: .normal)
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let addTaskButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let plusImage = UIImage(systemName: "plus", withConfiguration: config)
        button.setImage(plusImage, for: .normal)
        button.tintColor = .appPrimary
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let filterStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let notStartedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Not Started", for: .normal)
        button.backgroundColor = .taskNotStarted
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let inProgressButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("In Progress", for: .normal)
        button.backgroundColor = .taskInProgress
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let completedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Completed", for: .normal)
        button.backgroundColor = .taskCompleted
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    init(userId: Int, userName: String) {
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
        setupBindings()
        viewModel.getAllTasksForUser(userId: userId)
    }
    
    
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Add subviews
        view.addSubview(tableView)
        view.addSubview(headerLabel)
        view.addSubview(logoutButton)
        view.addSubview(addTaskButton)
        view.addSubview(filterStackView)
        
        // Add filter buttons
        filterStackView.addArrangedSubview(notStartedButton)
        filterStackView.addArrangedSubview(inProgressButton)
        filterStackView.addArrangedSubview(completedButton)
        
        // Setup TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        
        // Setup header
        headerLabel.text = "Welcome, \(userName)"
        
        // Setup constraints
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            
            headerLabel.centerYAnchor.constraint(equalTo: logoutButton.centerYAnchor, constant: 60),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLabel.leadingAnchor.constraint(greaterThanOrEqualTo: logoutButton.trailingAnchor, constant: 10),
            headerLabel.trailingAnchor.constraint(lessThanOrEqualTo: addTaskButton.leadingAnchor, constant: -10),
            
            addTaskButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            addTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addTaskButton.heightAnchor.constraint(equalToConstant: 44),
            addTaskButton.widthAnchor.constraint(equalToConstant: 44),
            
            filterStackView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 40),
            filterStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            filterStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            filterStackView.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.topAnchor.constraint(equalTo: filterStackView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Setup button actions
        notStartedButton.addTarget(self, action: #selector(filterTasks), for: .touchUpInside)
        inProgressButton.addTarget(self, action: #selector(filterTasks), for: .touchUpInside)
        completedButton.addTarget(self, action: #selector(filterTasks), for: .touchUpInside)
        addTaskButton.addTarget(self, action: #selector(addTaskTapped), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
    }
    
    private func setupBindings() {
        viewModel.onTasksUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.showAlert(message: message)
            }
        }
    }
    
    @objc private func filterTasks(_ sender: UIButton) {
        let status: String
        switch sender {
        case notStartedButton:
            status = "Not Started"
        case inProgressButton:
            status = "In Progress"
        case completedButton:
            status = "Completed"
        default:
            return
        }
        
        // Toggle filter if tapping the same button
        if status == currentFilter {
            currentFilter = nil
            updateFilterButtonStyles()
            viewModel.getAllTasksForUser(userId: userId)
        } else {
            currentFilter = status
            updateFilterButtonStyles()
            viewModel.getTasksByStatus(userId: userId, status: status)
        }
    }
    
    private func updateFilterButtonStyles() {
        // Reset all button styles
        [notStartedButton, inProgressButton, completedButton].forEach { button in
            button.alpha = 0.7
            button.layer.borderWidth = 0
        }
        
        // Highlight active filter
        if let currentFilter = currentFilter {
            switch currentFilter {
            case "Not Started":
                notStartedButton.alpha = 1.0
                notStartedButton.layer.borderWidth = 2
                notStartedButton.layer.borderColor = UIColor.white.cgColor
            case "In Progress":
                inProgressButton.alpha = 1.0
                inProgressButton.layer.borderWidth = 2
                inProgressButton.layer.borderColor = UIColor.white.cgColor
            case "Completed":
                completedButton.alpha = 1.0
                completedButton.layer.borderWidth = 2
                completedButton.layer.borderColor = UIColor.white.cgColor
            default:
                break
            }
        }
    }
    
    @objc private func logoutTapped() {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
            // Navigate back to login screen
            let loginVC = LoginViewController()
            self?.navigationController?.setViewControllers([loginVC], animated: true)
        })
        
        present(alert, animated: true)
    }
    
    @objc private func addTaskTapped() {
        let taskVC = TaskViewController(mode: .create, userId: userId, userName: userName)
        taskVC.delegate = self
        let nav = UINavigationController(rootViewController: taskVC)
        present(nav, animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// UITableViewDelegate & UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell
        let task = viewModel.tasks[indexPath.row]
        cell.configure(with: task)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = viewModel.tasks[indexPath.row]
        let taskVC = TaskViewController(mode: .view, task: task, userId: userId, userName: userName)
        taskVC.delegate = self
        let nav = UINavigationController(rootViewController: taskVC)
        present(nav, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// TaskCellDelegate
extension MainViewController: TaskCellDelegate {
    func editTask(_ task: Task) {
        let taskVC = TaskViewController(mode: .edit, task: task, userId: userId, userName: userName)
        taskVC.delegate = self
        let nav = UINavigationController(rootViewController: taskVC)
        present(nav, animated: true)
    }
    
    func deleteTask(_ task: Task) {
        viewModel.deleteTask(userId: userId, taskId: task.id)
    }
}

// TaskViewControllerDelegate
extension MainViewController: TaskViewControllerDelegate {
    func taskUpdated() {
        viewModel.getAllTasksForUser(userId: userId)
    }
}
