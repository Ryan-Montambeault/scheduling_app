//
//  LoginResponse.swift
//  Scheduling
//
//  Created by Glace on 2025-04-06.
//

struct LoginResponse: Codable {
    let message: String
    let userId: Int
    let userName: String
    
    enum CodingKeys: String, CodingKey {
        case message
        case userId = "userId"
        case userName = "userName"
    }
}
