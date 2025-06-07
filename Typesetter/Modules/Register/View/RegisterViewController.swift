//
//  RegisterViewController.swift
//  Typesetter
//
//  Created by Илья Малинов on 17.05.2025.
//

import Foundation
import UIKit

class RegisterViewController: UIViewController {
    
    private let viewModel = RegisterViewModel()
    
    weak var coordinator: AppCoordinator?
    
    private lazy var usernameField: UITextField = makeTextField(placeholder: "Имя пользователя")
    private lazy var emailField: UITextField = makeTextField(placeholder: "Email", keyboardType: .emailAddress)
    private lazy var passwordField: UITextField = {
        let field = makeTextField(placeholder: "Пароль", isSecure: true)
        field.textContentType = .newPassword
        return field
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.setTitle("Зарегистрироваться", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Уже есть аккаунт? Войти", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(goBackToLogin), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        let stack = UIStackView(arrangedSubviews: [
            usernameField,
            emailField,
            passwordField,
            registerButton,
            loginButton
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    private func makeTextField(placeholder: String, isSecure: Bool = false, keyboardType: UIKeyboardType = .default) -> UITextField {
        let field = UITextField()
        field.placeholder = placeholder
        field.borderStyle = .roundedRect
        field.isSecureTextEntry = isSecure
        field.keyboardType = keyboardType
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.textContentType = isSecure ? .password : .username
        field.returnKeyType = .next
        field.delegate = self
        
        field.font = UIFont.preferredFont(forTextStyle: .body)
        field.adjustsFontForContentSizeCategory = true
        
        return field
    }
    
    @objc private func registerTapped() {
        guard let username = usernameField.text, !username.isEmpty,
              let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty
        else {
            showAlert(title: "Ошибка", message: "Заполните все поля")
            return
        }

        // Заглушка успешной регистрации
        showAlert(title: "Успех", message: "Регистрация прошла успешно")
        coordinator?.showLogin()
    }

    @objc private func goBackToLogin() {
        coordinator?.showLogin()
    }
//    private lazy var loginAction = UIAction { [weak self] _ in
//        guard let self = self else { return }
//        
//        guard let coordinator = self.coordinator else {
//            print("❌ Coordinator равен nil!")
//            return
//        }
//        
//        print("📎 Coordinator существует, вызываем showLogin()")
//        coordinator.showLogin()
//    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField {
            emailField.becomeFirstResponder()
        } else if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            passwordField.resignFirstResponder()
        }
        return true
    }
    
}
