//
//  DataService.swift
//  Scheduling
//
//  Created by Glace on 2025-04-06.
//
 
import Foundation
 
enum DataError: Error {
    case networkError
    case decodingError
    case invalidResponse
    case authenticationError
}
 
class DataService {
    static let shared = DataService()
    
    // Keys for UserDefaults
    private let usersKey = "local_users"
    private let tasksKey = "local_tasks"
    private let currentUserKey = "current_user"
    
    // Sample users
    private let sampleUsers: [User] = [
        User(id: 1, name: "John Doe", email: "jdoe@example.com"),
        User(id: 2, name: "Bob Tester", email: "bobt@example.com"),
        User(id: 3, name: "Alice Johnson", email: "alicej123@example.com"),
    ]
    
    // User passwords
    private let userPasswords: [Int: String] = [
        1: "password1",
        2: "password2",
        3: "password3"
    ]
    
    // Sample tasks
    private let sampleTasks: [Task] = [
        Task(id: 1, title: "Take dog for walk", description: "Remember to take the dog for a 20 minute walk.", dueDate: Date().addingTimeInterval(86400), taskStatus: "Not Started", userId: 1),
        Task(id: 2, title: "Buy groceries", description: "Get milk, eggs, and bread", dueDate: Date().addingTimeInterval(172800), taskStatus: "In Progress", userId: 1),
        Task(id: 3, title: "Doctor appointment", description: "Annual checkup", dueDate: Date().addingTimeInterval(259200), taskStatus: "Completed", userId: 1),
        Task(id: 4, title: "Team meeting", description: "Weekly sync with the team", dueDate: Date().addingTimeInterval(86400), taskStatus: "Not Started", userId: 2),
        Task(id: 5, title: "Gym workout", description: "Cardio and strength training", dueDate: Date().addingTimeInterval(43200), taskStatus: "Completed", userId: 2)
    ]
    
    private init() {
        // Initialize with sample data if none exists
        if getUsers().isEmpty {
            saveUsers(sampleUsers)
        }
        
        if getTasks().isEmpty {
            saveTasks(sampleTasks)
        }
    }
    
    // MARK: - User Management
    private func getUsers() -> [User] {
        guard let data = UserDefaults.standard.data(forKey: usersKey),
              let users = try? JSONDecoder().decode([User].self, from: data) else {
            return []
        }
        return users
    }
    
    private func saveUsers(_ users: [User]) {
        if let encoded = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(encoded, forKey: usersKey)
        }
    }
    
    // MARK: - Task Management
    private func getTasks() -> [Task] {
        guard let data = UserDefaults.standard.data(forKey: tasksKey),
              let tasks = try? JSONDecoder().decode([Task].self, from: data) else {
            return []
        }
        return tasks
    }
    
    private func saveTasks(_ tasks: [Task]) {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: tasksKey)
        }
    }
    
    private func getNextTaskId() -> Int {
        let tasks = getTasks()
        return tasks.map { $0.id }.max() ?? 0 + 1
    }
    
    // MARK: - API Routes (I had to use local data since I couldn't get Alamofire to work)
    func login(email: String, password: String, completion: @escaping (Result<LoginResponse, DataError>) -> Void) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let users = self.getUsers()
            
            if let user = users.first(where: { $0.email == email }),
               let storedPassword = self.userPasswords[user.id],
               storedPassword == password {
                
                // Create response
                let response = LoginResponse(
                    message: "Login successful",
                    userId: user.id,
                    userName: user.name
                )
                completion(.success(response))
            } else {
                completion(.failure(.authenticationError))
            }
        }
    }
    
    func getAllTasks(userId: Int, completion: @escaping (Result<[Task], DataError>) -> Void) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let userTasks = self.getTasks().filter { $0.userId == userId }
            completion(.success(userTasks))
        }
    }
    
    func getTasksByStatus(userId: Int, status: String, completion: @escaping (Result<[Task], Error>) -> Void) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let filteredTasks = self.getTasks().filter { $0.userId == userId && $0.taskStatus == status }
            completion(.success(filteredTasks))
        }
    }
    
    func createTask(userId: Int, request: TaskCreateRequest, completion: @escaping (Result<Task, Error>) -> Void) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            var allTasks = self.getTasks()
            
            // Generate a new ID
            let newId = self.getNextTaskId() + 1
            
            // Create new task
            let newTask = Task(
                id: newId,
                title: request.title,
                description: request.description,
                dueDate: request.dueDate,
                taskStatus: request.taskStatus,
                userId: userId
            )
            
            // Add to tasks and save
            allTasks.append(newTask)
            self.saveTasks(allTasks)
            
            completion(.success(newTask))
        }
    }
    
    func updateTask(userId: Int, request: TaskUpdateRequest, completion: @escaping (Result<Task, Error>) -> Void) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            var allTasks = self.getTasks()
            
            // Find the task to update
            if let index = allTasks.firstIndex(where: { $0.id == request.id && $0.userId == userId }) {
                
                // Update the task
                allTasks[index] = Task(
                    id: request.id,
                    title: request.title,
                    description: request.description,
                    dueDate: request.dueDate,
                    taskStatus: request.taskStatus,
                    userId: userId
                )
                
                // Save changes
                self.saveTasks(allTasks)
                
                completion(.success(allTasks[index]))
            } else {
                completion(.failure(DataError.invalidResponse))
            }
        }
    }
    
    func deleteTask(userId: Int, taskId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            var allTasks = self.getTasks()
            
            // Remove the task
            allTasks.removeAll { $0.id == taskId && $0.userId == userId }
            
            // Save changes
            self.saveTasks(allTasks)
            
            completion(.success(()))
        }
    }
    
    func resetData() {
        // Clear existing data
        UserDefaults.standard.removeObject(forKey: usersKey)
        UserDefaults.standard.removeObject(forKey: tasksKey)
        
        // Reinitialize with sample data
        saveUsers(sampleUsers)
        saveTasks(sampleTasks)
    }
}
