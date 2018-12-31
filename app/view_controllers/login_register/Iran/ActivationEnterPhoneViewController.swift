//
//  ActivationEnterPhoneViewController.swift
//  iptv
//
//  Created by Hamed.Gh on 8/1/1396 AP.
//  Copyright © 1396 aseman. All rights reserved.
//

import UIKit

class ActivationEnterPhoneViewController: UIViewController {
    
    let userDefault=UserDefaults.standard
    
    @IBOutlet weak var guideLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: ShakingTextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var closeComplition:(()->Void)?
    
    func setCloseComplition(closeComplition: (()->Void)? ) {
        self.closeComplition = closeComplition
    }
    
    var submitComplition:((String)->Void)?
    
    func setSubmitComplition(submitComplition:((String)->Void)?){
        self.submitComplition=submitComplition
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeUIElements()
        
        self.phoneNumberTextField.keyboardType = UIKeyboardType.numberPad
        
        if let phoneNumber = userDefault.string(forKey: AppConst.UserDefaults.PHONE_NUMBER) {
            phoneNumberTextField.text =  phoneNumber
        }
        
        setNavBar()
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setDefaultStyle()
        self.setAllTextsInView()
    }
    
    func setAllTextsInView(){
        self.navigationItem.title=LocalizationSystem.getStr(forKey: LanguageKeys.login)
        self.registerBtn.setTitle(LocalizationSystem.getStr(forKey: LanguageKeys.sendingActivationCode), for: .normal)
        self.guideLabel.text=LocalizationSystem.getStr(forKey: LanguageKeys.guideOfSendingActivationCode)
    }
    
    func setNavBar(){
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationItem.title=LocalizationSystem.getStr(forKey: LanguageKeys.login)
        self.navigationItem.removeDefaultBackBtn()
        self.navigationItem.setRightBtn(target: self, action: #selector(self.exitBtnAction), text: "", font: AppConst.Resource.Font.getIcomoonFont(size: 24))
    }
    
    @objc func exitBtnAction(){
        self.closeComplition?()
        self.dismiss(animated: true, completion: nil)
    }
    
    func customizeUIElements() {
        
        self.phoneNumberTextField.backgroundColor=UIColor.clear
        
        let uiFont = UIFont(name: "IRANSansMobile-Medium", size: 13)
        let attr = [NSAttributedString.Key.font : uiFont!,NSAttributedString.Key.foregroundColor: UIColor.gray]
        
        let nsAttr = NSAttributedString(string:"", attributes: attr)
        
        self.phoneNumberTextField.attributedPlaceholder = nsAttr
        
        self.registerBtn.backgroundColor=AppConst.Resource.Color.Tint
        
    }
    
    @IBAction func registerBtnClick(_ sender: Any) {
        let mobile:String = phoneNumberTextField.text?.castNumberToEnglish() ?? ""
        if !mobile.starts(with: "9") || mobile.count != 10 || !mobile.isNumber{
            FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.phoneNumberIncorrectError), theme: .error)
            self.phoneNumberTextField.shake()
            return
        }
        
        userDefault.set(mobile, forKey: AppConst.UserDefaults.PHONE_NUMBER)
        userDefault.synchronize()
        
        phoneNumberTextField.isUserInteractionEnabled = false
        
        registerBtn.setTitle("", for: [])
        loading.startAnimating()
        
        ApiMethods.register(telephone: mobile) { [weak self] (data, response, error) in
            
            self?.registerBtn.setTitle(LocalizationSystem.getStr(forKey: LanguageKeys.sendingActivationCode), for: [])
            self?.loading.stopAnimating()
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode < 200 && response.statusCode >= 300 {
                    return
                }
            }
            guard error == nil else {
                print("Get error register")
                return
            }

            let controller=ActivationEnterVerifyCodeViewController(
                nibName: ActivationEnterVerifyCodeViewController.identifier,
                bundle: ActivationEnterVerifyCodeViewController.bundle)
            
            controller.setCloseComplition(closeComplition: self?.closeComplition)
            controller.setSubmitComplition(submitComplition: self?.submitComplition)
            
            
            self?.navigationController?.pushViewController(controller, animated: true)
            
        }
    }
    
}