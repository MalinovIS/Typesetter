//
//  RegisterViewModel.swift
//  Typesetter
//
//  Created by Илья Малинов on 17.05.2025.
//

import Foundation

class RegisterViewModel {
    
    var email: String = ""
    var password: String = ""
    var username: String = ""
    
    func isFormValid() -> Bool {
        return isValidEmail() && isValidPassword() && isValidUsername()
    }
    
    private func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPred.evaluate(with: email)
    }
    
    private func isValidPassword() -> Bool {
        return password.count >= 6
    }
    
    private func isValidUsername() -> Bool {
        return username.count >= 3
    }
    
    enum RegistrationError: Error {
        case emptyFields
        case invalidEmail
        case invalidPassword
        case invalidUsername
    }
    
    func validateForm() throws {
        guard !email.isEmpty && !password.isEmpty && !username.isEmpty else {
            throw RegistrationError.emptyFields
        }
        
        guard isValidEmail() else {
            throw RegistrationError.invalidEmail
        }
        
        guard isValidPassword() else {
            throw RegistrationError.invalidPassword
        }
        
        guard isValidUsername() else {
            throw RegistrationError.invalidUsername
        }
    }
}
