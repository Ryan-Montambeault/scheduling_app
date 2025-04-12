//
//  Task.swift
//  Scheduling
//
//  Created by Glace on 2025-04-06.
//

import Foundation

struct Task: Codable {
    let id: Int
    let title: String
    let description: String
    let dueDate: Date?
    let taskStatus: String
    let userId: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case dueDate = "due_date"
        case taskStatus = "task_status"
        case userId = "user_id"
    }
}
