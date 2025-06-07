//
//  LoginViewModel.swift
//  Typesetter
//
//  Created by Илья Малинов on 20.05.2025.
//

import Foundation

class LoginViewModel {
    
    var email: String = ""
    var password: String = ""
    
    func isFormValid() -> Bool {
        return isValidEmail() && !password.isEmpty
    }
    
    private func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPred.evaluate(with: email)
    }
    
    // MARK: - Error Handling
    enum LoginError: Error {
        case emptyFields
        case invalidEmail
        case invalidPassword
    }
    
    func validateForm() throws {
        guard !email.isEmpty && !password.isEmpty else {
            throw LoginError.emptyFields
        }
        
        guard isValidEmail() else {
            throw LoginError.invalidEmail
        }
        
        guard password.count >= 6 else {
            throw LoginError.invalidPassword
        }
    }
}
