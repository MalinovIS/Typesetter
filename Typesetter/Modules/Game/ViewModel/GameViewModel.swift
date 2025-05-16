//
//  GameViewModel.swift
//  Typesetter
//
//  Created by Илья Малинов on 24.04.2025.
//

import Foundation

class GameViewModel {
    
    var correctCount = 0
    var wrongCount = 0
    var remainingTime = 180
    var currentText = ""
    
    var onStatsUpdate: (() -> Void)?
    var onTimeUpdate: (() -> Void)?
    var onEndGame: ((Int, Int) -> Void)?
    
    func startGame() {
        correctCount = 0
        wrongCount = 0
        remainingTime = 180
        currentText = generateRandomText(length: 50)
        onStatsUpdate?()
        onTimeUpdate?()
    }
    
    func updateTimer() {
        guard remainingTime > 0 else {
            onEndGame?(correctCount, wrongCount)
            return
        }
        remainingTime -= 1
        onTimeUpdate?()
    }
    
    func handleInput(_ input: String){
        guard !currentText.isEmpty else { return }
        
        let firstChar = String(currentText.prefix(1))
        
        if input.lowercased() == firstChar.lowercased() {
            correctCount += 1
            currentText.removeFirst()
        } else {
            wrongCount += 1
        }
        
        onStatsUpdate?()
        
        if currentText.isEmpty {
            onEndGame?(correctCount, wrongCount)
        }
    }
    
    func formatTime() -> String {
        let minutes = remainingTime / 60
        let seconds = remainingTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func generateRandomText(length: Int) -> String {
        let symbols = "qwertyuiopasdfghjklzxcvbnm ,.!?"
        return String((0..<length).map { _ in symbols.randomElement()! })
    }
    
}
