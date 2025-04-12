//
//  LoginViewModel.swift
//  Scheduling
//
//  Created by Glace on 2025-04-07.
//

import Foundation

class LoginViewModel {
    // Closure for handling state changes
    var onStateChange: ((String?) -> Void)?
    var onLoginSuccess: ((Int, String) -> Void)?
    
    func loginUser(email: String, password: String) {
        DataService.shared.login(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let response):
                self?.onLoginSuccess?(response.userId, response.userName)
            case .failure(_):
                self?.onStateChange?("Login failed. Please try again.")
            }
        }
    }
}
