//
//  TaskUpdateRequest.swift
//  Scheduling
//
//  Created by Glace on 2025-04-07.
//

import Foundation

struct TaskUpdateRequest: Codable {
    let id: Int
    let userId: Int
    let taskId: Int
    let title: String
    let description: String
    let dueDate: Date?
    let taskStatus: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "userId"
        case taskId = "taskId"
        case title
        case description
        case dueDate = "due_date"
        case taskStatus = "task_status"
    }
}
