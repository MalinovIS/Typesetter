//
//  GameCoordinator.swift
//  Typesetter
//
//  Created by Илья Малинов on 17.05.2025.
//

import UIKit

class GameCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let gameVC = GameViewController()
        gameVC.coordinator = self
        navigationController.pushViewController(gameVC, animated: true)
    }
}
