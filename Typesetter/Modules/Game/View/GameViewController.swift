//
//  ViewController.swift
//  Typesetter
//
//  Created by Илья Малинов on 13.04.2025.
//

import UIKit

class GameViewController: UIViewController {
    
    private var viewModel = GameViewModel()
    private var timer: Timer?
    
    private lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Нажмите 'Старт' чтобы начать"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var textDisplayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.monospacedSystemFont(ofSize: 20, weight: .regular)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.backgroundColor = .systemBackground.withAlphaComponent(0.9)
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = false
        return label
    }()
    
    private lazy var startButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Старт"
        config.image = UIImage(systemName: "play.fill")
        config.imagePadding = 8
        config.imagePlacement = .trailing
        config.cornerStyle = .capsule
        config.buttonSize = .large
        config.baseBackgroundColor = .systemIndigo
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction( UIAction { [weak self] _ in
            self?.animateButtonTap(button)
            self?.startGame()
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "03:00"
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var statsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Правильно: 0 | Ошибки: 0"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var textInputField:UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.isHidden = true
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        return field
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraints()
        setupBindings()
        setupTextInput()
    }
    
    deinit {
        timer?.invalidate()
    }
}

extension GameViewController: UITextFieldDelegate {
    func setupTextInput() {
        textInputField.delegate = self
        textInputField.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textfieldDidChange(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            viewModel.handleInput(text)
        }
        textInputField.text = ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 1
    }
}

private extension GameViewController {
    
    func addSubviews() {
        view.backgroundColor = .systemBackground
        
        // Сначала добавляем основные элементы
        view.addSubview(instructionLabel)
        view.addSubview(textDisplayLabel)
        view.addSubview(statsLabel)
        view.addSubview(timerLabel)
        view.addSubview(startButton)
        view.addSubview(textInputField)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            textDisplayLabel.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 24),
            textDisplayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            textDisplayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            textDisplayLabel.heightAnchor.constraint(equalToConstant: 60),
            
            statsLabel.topAnchor.constraint(equalTo: textDisplayLabel.bottomAnchor, constant: 16),
            statsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            statsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            timerLabel.topAnchor.constraint(equalTo: statsLabel.bottomAnchor, constant: 16),
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            startButton.widthAnchor.constraint(equalToConstant: 180),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            
            textInputField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textInputField.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 20),
            textInputField.widthAnchor.constraint(equalToConstant: 20),
            textInputField.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func setupBindings() {
        viewModel.onStatsUpdate = { [weak self] in
            self?.updateStatsLabel()
            self?.textDisplayLabel.text = self?.viewModel.currentText
        }
        
        viewModel.onTimeUpdate = { [weak self] in
            self?.updateTimerLabel()
        }
        
        viewModel.onEndGame = { [weak self] correct, wrong in
            self?.endGame(correct: correct, wrong: wrong)
        }
    }
    
    private func startGame() {
        timer?.invalidate()
        
        viewModel.startGame()
        textDisplayLabel.text = viewModel.currentText
        
        timerLabel.isHidden = false
        statsLabel.isHidden = false
        textInputField.isHidden = false
        textInputField.isEnabled = true
        textInputField.becomeFirstResponder()
        
        startButton.configuration?.title = "Заново"
        startButton.configuration?.image = UIImage(systemName: "arrow.clockwise")
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        viewModel.updateTimer()
    }
    
    func endGame(correct: Int, wrong: Int) {
        timer?.invalidate()
        textInputField.isEnabled = false
        textInputField.resignFirstResponder()
        
        let accuracy = correct == 0 ? 0 : Double(correct) / Double(correct + wrong) * 100
        let alert = UIAlertController(
            title: "Игра окончена",
            message: String(format: "Правильно: %d\nОшибки: %d\nТочность: %.1f%%", correct, wrong, accuracy),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    private func updateStatsLabel() {
            statsLabel.text = "Правильно: \(viewModel.correctCount) | Ошибки: \(viewModel.wrongCount)"
        }
        
        private func updateTimerLabel() {
            timerLabel.text = viewModel.formatTime()
        }
        
        private func animateButtonTap(_ button: UIButton) {
            UIView.animate(withDuration: 0.1, animations: {
                button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    button.transform = .identity
                }
            }
        }
}
