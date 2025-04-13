//
//  ViewController.swift
//  Typesetter
//
//  Created by Илья Малинов on 13.04.2025.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    private var timer: Timer?
    private var remainingTime: Int = 180
    
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
        label.backgroundColor = .systemBackground
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addSoftUIEffect(to: textDisplayLabel)
    }
    
    deinit {
        timer?.invalidate()
    }
    
    
}
private extension ViewController {
    
    func addSubviews() {
        view.backgroundColor = .systemBackground
        
        // Add blur effect background
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        view.addSubview(blurView)
        view.sendSubviewToBack(blurView)
        
        view.addSubview(instructionLabel)
        view.addSubview(textDisplayLabel)
        view.addSubview(startButton)
        view.addSubview(timerLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            textDisplayLabel.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 24),
            textDisplayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            textDisplayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            textDisplayLabel.bottomAnchor.constraint(lessThanOrEqualTo: timerLabel.topAnchor, constant: -20),
            
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.topAnchor.constraint(equalTo: textDisplayLabel.bottomAnchor, constant: 20),
            timerLabel.bottomAnchor.constraint(lessThanOrEqualTo: startButton.topAnchor, constant: -40),
            
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            startButton.widthAnchor.constraint(equalToConstant: 180),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    func startGame() {
        
        timer?.invalidate()
        
        remainingTime = 180
        
        updateTimerLabel()
        
        let randomText = textGenerate(length: 50)
        
        UIView.transition(with: textDisplayLabel,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
            self.textDisplayLabel.text = randomText
        })
        
        timerLabel.isHidden = false
        
        startButton.configuration?.title = "Заново"
        startButton.configuration?.image = UIImage(systemName: "arrow.clockwise")
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    @objc func updateTimer() {
        remainingTime -= 1
        updateTimerLabel()
        
        if remainingTime <= 0 {
            timer?.invalidate()
            timerLabel.text = "00:00"
        }
    }
    
    func updateTimerLabel() {
        let minutes = remainingTime / 60
        let seconds = remainingTime % 60
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    func textGenerate(length: Int) -> String {
        let arrayOfSymbol = "абвгдеёжзийклмнопрстуфхцчшщьыъэюя"
        return String((0..<length).map{ _ in arrayOfSymbol.randomElement()! })
    }
    
    func animateButtonTap(_ button: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) {_ in
            UIView.animate(withDuration: 0.1) {
                button.transform = .identity
            }
        }
    }
    
    func addSoftUIEffect(to view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: view.bounds, cornerRadius: 12).cgPath
        shadowLayer.fillColor = UIColor.systemBackground.cgColor
        shadowLayer.shadowColor = UIColor.white.cgColor
        shadowLayer.shadowOffset = CGSize(width: -2, height: -2)
        shadowLayer.shadowOpacity = 0.5
        shadowLayer.shadowRadius = 2
        view.layer.insertSublayer(shadowLayer, at: 0)
    }
}
