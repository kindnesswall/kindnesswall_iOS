//
//  AppLanguage.swift
//  app
//
//  Created by AmirHossein on 3/30/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import Foundation
import KeychainSwift

class AppLanguage{
    
    static private var language:Language?
    
    enum Language:String {
        case persian
        case english
    }
    
    static func setLanguage(language:Language){
        self.language=language
        KeychainSwift().set(language.rawValue, forKey: AppConstants.APPLanguage)
    }
    static func getLanguage()->Language {
        
        if let language=self.language {
            return language
        }
        
        let defaultLanguage=Language.persian
        
        guard let languageString=KeychainSwift().get(AppConstants.APPLanguage) , let language=Language(rawValue: languageString) else {
            return defaultLanguage
        }
        
        self.language=language
        return language
    }
    
    
    //MARK: - Utilities
    
    static func getNumberString(number:String)->String{
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return number.CastNumberToPersian()
        case .english:
            return number
        }
    }
    
    static func getTextAlignment()->NSTextAlignment{
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return .right
        case .english:
            return .left
        }
    }
    
}

struct LanguageKeys {
    static let RegisterGiftViewController_title : String = "RegisterGiftViewController_title"
    static let MyGiftsViewController_title : String = "MyGiftsViewController_title"
    static let EditGiftViewController_title : String = "EditGiftViewController_title"
    static let RequestsViewController_title : String = "RequestsViewController_title"
    
    static let ok : String = "ok"
    
    static let edit : String = "edit"
    static let back : String = "back"
    static let cancel : String = "cancel"
    static let yes : String = "yes"
    static let no : String = "no"
    static let skip : String = "skip"
    static let home : String = "home"

    static let request : String = "request"
    static let remove : String = "remove"
    static let status : String = "status"
    static let address : String = "address"

    static let allGifts : String = "allGifts"
    static let allCities : String = "allCities"
    static let allRegions : String = "allRegions"
    static let category : String = "category"
    static let giftCategory : String = "giftCategory"
    static let newOrUsed : String = "newOrUsed"
    static let new : String = "new"
    static let used : String = "used"
    static let placeOfTheGift : String = "placeOfTheGift"
    static let registered : String = "registered"
    static let donated : String = "donated"
    static let clearPage : String = "clearPage"
    static let saveDraft : String = "saveDraft"
    static let select : String = "select"
    static let camera : String = "camera"
    static let gallery : String = "gallery"
    static let title : String = "title"
    static let description : String = "description"
    static let approximatePrice : String = "approximatePrice"
    static let addImage : String = "addImage"
    static let login : String = "login"
    static let logout : String = "logout"
    static let myWall : String = "myWall"
    static let contactUs : String = "contactUs"
    static let bugReport : String = "bugReport"
    static let aboutKindnessWall : String = "aboutKindnessWall"
    static let letsGoToTheApplication : String = "letsGoToTheApplication"
    static let statistic : String = "statistic"
    static let activationCode : String = "activationCode"
    static let sendingActivationCode : String = "sendingActivationCode"
    static let resendActivationCode : String = "resendActivationCode"
    static let registeringActivationCode : String = "registeringActivationCode"

    static let giftRegisteredSuccessfully : String = "giftRegisteredSuccessfully"
    static let editedSuccessfully : String = "editedSuccessfully"
    static let draftSavedSuccessfully : String = "draftSavedSuccessfully"
    static let uploadedSuccessfully : String = "uploadedSuccessfully"
    static let gettingPriceReason : String = "gettingPriceReason"
    
    static let imageUploadingError : String = "imageUploadingError"
    static let titleError : String = "titleError"
    static let categoryError : String = "categoryError"
    static let newOrUsedError : String = "newOrUsedError"
    static let descriptionError : String = "descriptionError"
    static let priceError : String = "priceError"
    static let addressError : String = "addressError"
    static let giftRemovingPrompt : String = "giftRemovingPrompt"
    static let phoneNumberIncorrectError : String = "phoneNumberIncorrectError"
    static let phoneNumberTryAgainError : String = "phoneNumberTryAgainError"
    static let activationCodeError : String = "activationCodeError"
    static let activationCodeIncorrectError : String = "activationCodeIncorrectError"
    static let guideOfSendingActivationCode : String = "guideOfSendingActivationCode"
    static let guideOfRegitering_part1 : String = "guideOfRegitering_part1"
    static let guideOfRegitering_part2 : String = "guideOfRegitering_part2"

}
