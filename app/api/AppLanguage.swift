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
    
}

class AppLiteral {
    
    static var home : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "خانه"
        case .english:
            return "Home"
        }
    }
    
    static var myGifts : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "هدیه‌های من"
        case .english:
            return "My Gifts"
        }
    }
    
    static var registerGift : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "ثبت هدیه"
        case .english:
            return "Gift Registering"
        }
    }
    
    static var editGift : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "ویرایش هدیه"
        case .english:
            return "Gift Editing"
        }
    }
    
    static var allGifts : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "همه هدیه‌ها"
        case .english:
            return "All Gifts"
        }
    }
    
    static var allCities : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "همه شهر‌ها"
        case .english:
            return "All Cities"
        }
    }
    
    static var allRegions : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "همه منطقه‌ها"
        case .english:
            return "All Regions"
        }
    }
    
    static var category : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "دسته بندی"
        case .english:
            return "Category"
        }
    }
    
    static var giftCategory : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "دسته بندی هدیه"
        case .english:
            return "Gift Category"
        }
    }
    
    static var newOrSecondHand : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "نو یا دسته دو بودن"
        case .english:
            return "New or Secondhand"
        }
    }
    
    static var new : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "نو"
        case .english:
            return "New"
        }
    }
    
    static var secondHand : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "دسته‌دو"
        case .english:
            return "Secondhand"
        }
    }
    
    static var placeOfTheGift : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "محل هدیه"
        case .english:
            return "Place of the Gift"
        }
    }
    
    static var cancel : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "انصراف"
        case .english:
            return "Cancel"
        }
    }
    
    static var registered : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "ثبت شده"
        case .english:
            return "Registered"
        }
    }
    
    static var donated : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "اهدایی"
        case .english:
            return "Donated"
        }
    }
    
    static var clearPage : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "پاک کردن صفحه"
        case .english:
            return "Clear Page"
        }
    }
    
    static var saveDraft : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "ذخیره پیش‌ نویس"
        case .english:
            return "Save Draft"
        }
    }
    
    static var select : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "انتخاب"
        case .english:
            return "Select"
        }
    }
    
    static var camera : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "دوربین"
        case .english:
            return "Camera"
        }
    }
    
    static var gallery : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "گالری تصاویر"
        case .english:
            return "Gallery"
        }
    }
    
    static var title : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "عنوان"
        case .english:
            return "Title"
        }
    }
    
    static var description : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "توضیحات"
        case .english:
            return "Description"
        }
    }
    
    static var approximatePriceInToman : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "ارزش تقریبی به تومان"
        case .english:
            return "Approximate Price in Toman"
        }
    }
    
    static var addImage : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "افزودن عکس"
        case .english:
            return "Add Image"
        }
    }
    
}

//MARK: - AppLiteralForMessages

class AppLiteralForMessages{
    
    static var registeredSuccessfully : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "ثبت کالا با موفقیت انجام شد"
        case .english:
            return "The gift has registered successfully"
        }
    }
    
    static var editedSuccessfully : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "کالا با موفقیت ویرایش شد"
        case .english:
            return "The gift has edited successfully"
        }
    }
    
    static var draftSavedSuccessfully : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "پیش‌نویس با موفقیت ذخیره شد"
        case .english:
            return "The draft has saved successfully"
        }
    }
    
    static var uploadedSuccessfully : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "آپلود عکس با موفقیت انجام شد"
        case .english:
            return "The Image has uploaded successfully"
        }
    }
    
    
    
    static var gettingPriceReason : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return " (صرفا جهت برآورد و نمایش در قسمت آمار است و برای دیگران نمایش داده نمیشود) "
        case .english:
            return ""
        }
    }
    
    //MARK: Errors
    
    static var imageUploadingError : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "آپلود عکس با مشکل روبه‌رو شد"
        case .english:
            return "An error has occurred in image uploading"
        }
    }
    
    static var titleError : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "لطفا عنوان کالا را وارد نمایید"
        case .english:
            return "Please write the title of the gift"
        }
    }
    
    static var categoryError : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "لطفا دسته‌بندی کالا را انتخاب نمایید"
        case .english:
            return "Please select the category of the gift"
        }
    }
    
    static var newOrSecondhandError : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "لطفا وضعیت نو یا دسته دو بودن کالا را مشخص کنید."
        case .english:
            return "Please select one of the \"new or secondhand\" options"
        }
    }
    
    static var descriptionError : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "لطفا توضیحات کالا را وارد نمایید"
        case .english:
            return "Please write the description of the gift"
        }
    }
    
    static var priceError : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "لطفا قیمت کالا را وارد نمایید"
        case .english:
            return "Please write the price of the gift"
        }
    }
    
    static var addressError : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "لطفا محل کالا را انتخاب نمایید"
        case .english:
            return "Please select the place of the gift"
        }
    }
    
    
}
