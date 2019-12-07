//
//  MoreCoordinator.swift
//  app
//
//  Created by Hamed Ghadirian on 25.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit
import KeychainSwift

class MoreCoordinator : NavigationCoordinator {
    var navigationController: CoordinatedNavigationController
    
    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        self.navigationController = navigationController
        navigationController.coordinator = self
    }
    
    func showMore() {
        let viewController = MoreViewController(moreCoordinator: self)
        let img = UIImage(named: AppImages.More)
        viewController.tabBarItem = UITabBarItem(title: LanguageKeys.more.localizedString, image: img, tag: 0)
        
        navigationController.viewControllers = [viewController]
    }
    
    func showGiftReview() {
        let homeCoordinator = HomeCoordinator(navigationController: self.navigationController,isReview: true)
        homeCoordinator.pushRoot()
    }
    
    func showContacts() {
        let chatCoordinator = ChatCoordinator(navigationController: navigationController, blockedChats: true)
        chatCoordinator.pushRoot()
    }
    
    func showCharitySignupEditView() {
        let vm = CharitySignupEditVM()
        let controller = CharitySignupEditViewController(vm: vm)
        self.navigationController.pushViewController(controller, animated: true)
    }
    
    func showProfile() {
        let controller = ProfileViewController ()
        let nc = UINavigationController.init(rootViewController: controller)
        navigationController.present(nc, animated: true, completion: nil)
    }
    
    func showLanguageView() {
        let controller = LanguageViewController()
        controller.languageViewModel.tabBarIsInitialized = true
        self.navigationController.present(controller, animated: true, completion: nil)
    }
    
    func showStatisticView() {
        let controller = StatisticViewController()
        self.navigationController.pushViewController(controller, animated: true)
    }
    
    func showContactUsView() {
        let controller = ContactUsViewController()
        self.navigationController.pushViewController(controller, animated: true)
    }
    
    func showMyWall() {
        
    }
    
    func showLockScreenView()  {
        let controller = LockViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.mode = .checkPassCode
        controller.onPasscodeCorrect = {
            let controller = LockSettingViewController()
            self.navigationController.pushViewController(controller, animated: true)
        }
        self.navigationController.present(controller, animated: true, completion: nil)
    }
    
    func showLockSetting() {
        let controller = LockSettingViewController()
        self.navigationController.pushViewController(controller, animated: true)
    }
    
    func showLogoutAlert(onConfirm : @escaping ()->()) {
        let alert = UIAlertController(
            title:LanguageKeys.logoutDialogTitle.localizedString,
            message: LanguageKeys.logoutDialogText.localizedString,
            preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: LanguageKeys.ok.localizedString, style: UIAlertAction.Style.default, handler: { (action) in
            
            onConfirm()
            
        }))
        
        alert.addAction(UIAlertAction(title: LanguageKeys.cancel.localizedString, style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: {
                
            })
        }))
        
        self.navigationController.present(alert, animated: true, completion: nil)
    }
    
    func showIntro() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = (mainStoryboard.instantiateViewController(withIdentifier: "IntroViewController") as? IntroViewController) ?? IntroViewController()
        self.navigationController.present(viewController, animated: true, completion: nil)
    }
    
    func openTelegram() {
        let urlAddress = AppConst.URL.telegramLink
        URLBrowser(urlAddress: urlAddress).openURL()
    }
}
