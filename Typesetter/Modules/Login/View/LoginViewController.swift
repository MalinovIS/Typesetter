//
//  LoginViewController.swift
//  Typesetter
//
//  Created by Илья Малинов on 20.05.2025.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let viewModel = LoginViewModel()
    
    weak var coordinator: AppCoordinator?
    
    private lazy var emailField: UITextField = makeTextField(placeholder: "Email", keyboardType: .emailAddress, textContentType: .emailAddress)
    private lazy var passwordField: UITextField = makeTextField(placeholder: "Пароль", isSecure: true, textContentType: .password)
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.setTitle("Войти", for: .normal)
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Нет аккаунта? Зарегистрироваться", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("✅ Загружен LoginViewController")
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        let stack = UIStackView(arrangedSubviews: [
            emailField,
            passwordField,
            loginButton,
            registerButton
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
        
        [emailField, passwordField].forEach {
            $0.addAction(textFieldDidChange, for: .editingChanged)
        }
        
        updateButtonState()
    }
    
    private func makeTextField(placeholder: String, isSecure: Bool = false, keyboardType: UIKeyboardType = .default, textContentType: UITextContentType) -> UITextField {
        let field = UITextField()
        field.placeholder = placeholder
        field.borderStyle = .roundedRect
        field.isSecureTextEntry = isSecure
        field.keyboardType = keyboardType
        field.textContentType = textContentType
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.delegate = self
        field.returnKeyType = .next
        field.font = UIFont.preferredFont(forTextStyle: .body)
        field.adjustsFontForContentSizeCategory = true
        return field
    }
    
    private func updateButtonState() {
        loginButton.configuration?.baseBackgroundColor = viewModel.isFormValid() ? .systemIndigo : .systemGray
    }
    
    private lazy var textFieldDidChange = UIAction { [weak self] _ in
        guard let self = self else { return }
        
        self.viewModel.email = emailField.text ?? ""
        self.viewModel.password = passwordField.text ?? ""
        self.updateButtonState()
        
    }
    
    @objc private func loginTapped() {
        // Заглушка: имитируем успешный вход
        if emailField.text == "test@example.com" && passwordField.text == "password" {
            coordinator?.showGame()
        } else {
            showAlert(title: "Ошибка", message: "Неверный email или пароль")
        }
    }
    
    @objc private func registerTapped() {
        coordinator?.showRegister()
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            passwordField.resignFirstResponder()
                loginTapped()
        }
        return true
    }
}
