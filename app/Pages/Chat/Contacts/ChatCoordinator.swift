//
//  ChatCoordinator.swift
//  app
//
//  Created by Hamed Ghadirian on 25.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

class ChatCoordinator: NavigationCoordinator {
    var navigationController: CoordinatedNavigationController
    weak var startNewChatProtocol: StartNewChatProtocol?
    weak var refreshChatProtocol: RefreshChatProtocol?
    var rootViewController: ContactsViewController?
    let blockedChats: Bool
    
    lazy var messagesCoordinator = MessagesCoordinator(navigationController: self.navigationController)
    
    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController(), blockedChats: Bool = false) {
        self.blockedChats = blockedChats
        self.navigationController = navigationController
        navigationController.coordinator = self
    }

    func showRoot() {
        let rootVC = getRootViewController()
        let img = UIImage(named: AppImages.Requests)
        rootVC.tabBarItem = UITabBarItem(title: LanguageKeys.chats.localizedString, image: img, tag: 0)
        navigationController.viewControllers = [rootVC]
    }

    func pushRoot() {
        navigationController.pushViewController(getRootViewController(), animated: true)
    }

    func getRootViewController() -> ContactsViewController {
        if let rootVC = rootViewController {
            return rootVC
        }
        rootViewController = ContactsViewController(chatCoordinator: self, blockedChats: blockedChats)
        self.startNewChatProtocol = rootViewController!.viewModel
        self.refreshChatProtocol = rootViewController!
        return rootViewController!
    }
    
    func showMessages(viewModel: MessagesViewModel) {
        messagesCoordinator.showMessages(viewModel: viewModel)
    }
}
