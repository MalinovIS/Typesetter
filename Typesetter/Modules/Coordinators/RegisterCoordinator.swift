//
//  RegisterCoordinator.swift
//  Typesetter
//
//  Created by Илья Малинов on 17.05.2025.
//

import UIKit

class RegisterCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let registerVC = RegisterViewController()
        registerVC.coordinator = self
        navigationController.pushViewController(registerVC, animated: true)
    }
    
    func showLogin() {
        print("go to loginVC")
    }
    
    func registerSuccessful() {
        // go to menu
        let registerCoordinator = RegisterCoordinator(navigationController: navigationController)
        registerCoordinator.start()
    }
}
