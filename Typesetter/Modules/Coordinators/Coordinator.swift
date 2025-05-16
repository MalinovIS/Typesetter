//
//  Coordinator.swift
//  Typesetter
//
//  Created by Илья Малинов on 17.05.2025.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}
