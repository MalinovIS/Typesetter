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
        let gameCoodinator = GameCoordinator(navigationController: navigationController)
        gameCoodinator.start()
    }
    
    
}
