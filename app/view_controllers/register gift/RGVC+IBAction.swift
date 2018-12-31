//
//  RGVC+IBAction.swift
//  app
//
//  Created by Hamed.Gh on 12/30/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

extension RegisterGiftViewController {
    
    @IBAction func submitBtnAction(_ sender: Any) {
        
        self.registerBtn.isEnabled=false
        
        if AppDelegate.me().isIranSelected() {
            vm.sendGift(httpMethod: .POST, responseHandler: {
                self.registerBtn.isEnabled=true
            }) {
                self.clearAllInput()
                FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.giftRegisteredSuccessfully),theme: .success)
            }
        }else{
            vm.createGiftOnFIR()
        }
        
    }
    
    @IBAction func editBtnAction(_ sender: Any) {
        
        guard let giftId=self.vm.editedGift?.id else {
            return
        }
        
        self.editBtn.isEnabled=false
        vm.sendGift(httpMethod: .PUT,giftId: giftId, responseHandler: {
            self.editBtn.isEnabled=true
        }) {
            
            FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.editedSuccessfully), theme: .success)
            
            self.vm.writeChangesToEditedGift()
            self.editHandler?()
            
            let when=DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                self.dismiss(animated: true, completion: nil)
            })
            
        }
    }
    
    @IBAction func placeBtnAction(_ sender: Any) {
        
        self.clearGiftPlaces()
        self.vm.giftHasNewAddress=true
        self.configAddressViews()
        
        let controller=OptionsListViewController(
            nibName: OptionsListViewController.identifier,
            bundle: OptionsListViewController.bundle
        )
        controller.option = OptionsListViewController.Option.city(showRegion: true)
        controller.completionHandler={ [weak self] (id,name) in
            let place=Place(id: Int(id ?? ""), name: name)
            self?.vm.places.append(place)
            self?.addGiftPlace(place: place)
        }
        controller.closeHandler={ [weak self] in
            self?.clearGiftPlaces()
        }
        let nc=UINavigationController(rootViewController: controller)
        self.present(nc, animated: true, completion: nil)
    }
    
    @IBAction func categoryBtnClicked(_ sender: Any) {
        
        let controller=OptionsListViewController(
            nibName: OptionsListViewController.identifier,
            bundle: OptionsListViewController.bundle
        )
        controller.option = OptionsListViewController.Option.category
        controller.completionHandler={ [weak self] (id,name) in
            self?.categoryBtn.setTitle(name, for: .normal)
            self?.vm.category=Category(id: id, title: name)
        }
        let nc=UINavigationController(rootViewController: controller)
        self.present(nc, animated: true, completion: nil)
    }
    
    @IBAction func dateStatusBtnAction(_ sender: Any) {
        let controller=OptionsListViewController(
            nibName: OptionsListViewController.identifier,
            bundle: OptionsListViewController.bundle
        )
        controller.option = OptionsListViewController.Option.dateStatus
        controller.completionHandler={ [weak self] (id,name) in
            self?.dateStatusBtn.setTitle(name, for: .normal)
            self?.vm.dateStatus=DateStatus(id: id, title: name)
        }
        let nc=UINavigationController(rootViewController: controller)
        self.present(nc, animated: true, completion: nil)
    }
}

