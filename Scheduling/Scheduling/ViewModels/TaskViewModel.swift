//
//  TaskViewModel.swift
//  Scheduling
//
//  Created by Glace on 2025-04-07.
//

import Foundation

class TaskViewModel {
    private(set) var tasks: [Task] = []
    var onTasksUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    func getAllTasksForUser(userId: Int) {
        DataService.shared.getAllTasks(userId: userId) { [weak self] result in
            switch result {
            case .success(let tasks):
                self?.tasks = tasks
                self?.onTasksUpdated?()
            case .failure(_):
                self?.onError?("Failed to fetch tasks")
            }
        }
    }
    
    func getTasksByStatus(userId: Int, status: String) {
        DataService.shared.getTasksByStatus(userId: userId, status: status) { [weak self] result in
            switch result {
            case .success(let tasks):
                self?.tasks = tasks
                self?.onTasksUpdated?()
            case .failure(_):
                self?.onError?("Failed to fetch tasks")
            }
        }
    }
    
    func createTask(userId: Int, request: TaskCreateRequest, completion: @escaping (Bool) -> Void) {
        DataService.shared.createTask(userId: userId, request: request) { [weak self] result in
            switch result {
            case .success(_):
                self?.getAllTasksForUser(userId: userId)
                completion(true)
            case .failure(_):
                self?.onError?("Failed to create task")
                completion(false)
            }
        }
    }
    
    func updateTask(userId: Int, request: TaskUpdateRequest, completion: @escaping (Bool) -> Void) {
        DataService.shared.updateTask(userId: userId, request: request) { [weak self] result in
            switch result {
            case .success(_):
                self?.getAllTasksForUser(userId: userId)
                completion(true)
            case .failure(_):
                self?.onError?("Failed to update task")
                completion(false)
            }
        }
    }
    
    func deleteTask(userId: Int, taskId: Int) {
        DataService.shared.deleteTask(userId: userId, taskId: taskId) { [weak self] result in
            switch result {
            case .success(_):
                self?.tasks.removeAll { $0.id == taskId }
                self?.onTasksUpdated?()
            case .failure(_):
                self?.onError?("Failed to delete task")
            }
        }
    }
}
