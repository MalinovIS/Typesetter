//
//  AppCoordinator.swift
//  Typesetter
//
//  Created by Илья Малинов on 17.05.2025.
//

import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let viewController = LoginViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showLogin() {
        let viewController = LoginViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showRegister() {
        let viewController = RegisterViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showGame() {
        let viewController = GameViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }
}
