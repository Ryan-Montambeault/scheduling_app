//
//  TaskCreateRequest.swift
//  Scheduling
//
//  Created by Glace on 2025-04-07.
//

import Foundation

struct TaskCreateRequest: Codable {
    let userId: Int
    let title: String
    let description: String
    let dueDate: Date?
    let taskStatus: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case title
        case description
        case dueDate = "due_date"
        case taskStatus = "task_status"
    }
}
