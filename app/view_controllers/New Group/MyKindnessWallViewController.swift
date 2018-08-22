//
//  MyKindnessWallViewController.swift
//  app
//
//  Created by Hamed.Gh on 12/14/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit
import KeychainSwift

class MyKindnessWallViewController: UIViewController {

    @IBOutlet weak var bugReportBtn: UIButton!
    @IBOutlet weak var aboutKindnessWallBtn: UIButton!
    @IBOutlet weak var statisticBtn: UIButton!
    @IBOutlet weak var contactUsBtn: UIButton!
    @IBOutlet var loginLogoutBtn: UIButton!
    let keychain = KeychainSwift()
    
    @IBAction func logoutBtnClicked(_ sender: Any) {
        
        if let _=keychain.get(AppConstants.Authorization) { //UserDefaults.standard.string(forKey: AppConstants.Authorization) {
             AppDelegate.clearUserDefault()
            keychain.clear()
        } else {
            AppDelegate.me().showLoginVC()
        }
       
        setLoginLogoutBtnTitle()
        
    }
    
    @IBAction func contactUsBtnClicked(_ sender: Any) {
        guard let url = URL(string: "https://t.me/Kindness_Wall_Admin") else {
            return //be safe
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    @IBAction func statisticBtnAction(_ sender: Any) {
        
    }
    @IBAction func aboutKindnessWallBtnAction(_ sender: Any) {
        
    }
    @IBAction func bugReportBtnAction(_ sender: Any) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NavigationBarStyle.setDefaultStyle(navigationC: navigationController)
        
        setAllTextsInView()
        
    }
    
    func setAllTextsInView(){
        setLoginLogoutBtnTitle()
        
        self.navigationItem.title=AppLiteral.myWall
        
        contactUsBtn.setTitle(AppLiteral.contactUs, for: .normal)
        bugReportBtn.setTitle(AppLiteral.bugReport, for: .normal)
        aboutKindnessWallBtn.setTitle(AppLiteral.aboutKindnessWall, for: .normal)
        statisticBtn.setTitle(AppLiteral.statistic, for: .normal)
    }
    
    func setLoginLogoutBtnTitle(){
        if let _=keychain.get(AppConstants.Authorization) {
            loginLogoutBtn.setTitle(AppLiteral.logout, for: .normal)
        } else {
            loginLogoutBtn.setTitle(AppLiteral.login, for: .normal)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
