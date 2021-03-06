//
//  LockSettingViewController.swift
//  app
//
//  Created by Hamed.Gh on 12/17/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

class LockSettingViewController: UIViewController {

    let keychainService = KeychainService()

    @IBOutlet weak var turnPasscodeOnOffBtn: UIButton!

    @IBOutlet weak var changePasscodeBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        if keychainService.isPasscodeSaved() {
            turnPasscodeOnOffBtn.setTitle(LanguageKeys.TurnPasscodeOff.localizedString, for: UIControl.State.normal)
            changePasscodeBtn.show()
        } else {
            turnPasscodeOnOffBtn.setTitle(LanguageKeys.TurnPasscodeOn.localizedString, for: UIControl.State.normal)
            changePasscodeBtn.hide()
        }

        self.navigationItem.title=LanguageKeys.PasscodeLock.localizedString

    }

    func setPasscode() {
        let controller = LockViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.mode = .setPassCode
        self.tabBarController?.present(controller, animated: true, completion: nil)
    }

    @IBAction func changePasscodeBtnClicked(_ sender: Any) {
        setPasscode()
    }

    @IBAction func turnPassOnOffBtnClicked(_ sender: Any) {
        if keychainService.isPasscodeSaved() {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)

            alert.addAction(UIAlertAction(title: LanguageKeys.TurnPasscodeOff.localizedString, style: UIAlertAction.Style.destructive, handler: { [weak self] (_) in

                self?.keychainService.delete(.passCode)
                self?.turnPasscodeOnOffBtn.setTitle(LanguageKeys.TurnPasscodeOn.localizedString, for: UIControl.State.normal)
                self?.changePasscodeBtn.hide()

            }))

            alert.addAction(UIAlertAction(title: LanguageKeys.cancel.localizedString, style: UIAlertAction.Style.cancel, handler: { (_) in
                alert.dismiss(animated: true, completion: {

                })
            }))

            self.present(alert, animated: true, completion: nil)

        } else {
            setPasscode()
        }
    }

}
