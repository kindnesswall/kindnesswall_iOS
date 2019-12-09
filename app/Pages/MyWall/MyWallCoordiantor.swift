//
//  MyWallCoordiantor.swift
//  app
//
//  Created by Hamed Ghadirian on 28.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

class MyWallCoordinator: NavigationCoordinator {
    let keychainService = KeychainService()
    var navigationController: CoordinatedNavigationController

    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        self.navigationController = navigationController
        navigationController.coordinator = self
    }

    func showMyWall() {
        let viewController = MyWallViewController(myWallCoordinator: self)
        viewController.userId = Int(keychainService.get(.userId) ?? "")

        let img = UIImage(named: AppImages.MyWall)
        viewController.tabBarItem = UITabBarItem(title: LanguageKeys.tabBarMyWall.localizedString, image: img, tag: 0)

        navigationController.viewControllers = [viewController]
    }

    func showGiftDetail(gift: Gift, editHandler:(() -> Void)?) {
        let controller = GiftDetailViewController()

        controller.gift = gift
        controller.editHandler = editHandler

        self.navigationController.pushViewController(controller, animated: true)
    }
}