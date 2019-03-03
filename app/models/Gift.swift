//
//  Gift.swift
//  app
//
//  Created by Hamed.Gh on 12/14/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import Foundation

protocol GiftPresenter {
    var title:String? { get }
    var createdAt: Date? { get }
    var description:String? { get }
    var address:String? { get }
    var giftImages:[String]? { get }
//    var requestCount:String? { get }
    var isAd:Bool? { get }
}

protocol RegisterGiftInput {
    var title:String? { get set }
    var address:String? { get set }
    var description:String? { get set }
    var giftImages : [String]? { get set }
    var price:String? { get set }
    var categoryId:String? { get set }
    var isNew:Bool? { get set }
    var provinceId:Int? { get set }
    var cityId:Int? { get set }
}

class Gift: Codable,GiftPresenter,RegisterGiftInput {
    var isAd:Bool? = false
    
    var createdAt: Date?
    var updatedAt: Date?
    
    var provinceId:Int?
    var cityId:Int?
    
//    var requestCount:String?
    var title:String?
    var address:String?
//    var bookmark:Bool?
    var description:String?
    var price:String?
    var status:String?
    var userId:String?
//    var user:String?
//    var receivedUserId:String?
//    var receivedUser:String?
    var categoryId:String?
    var category:String?
//    var location:String?
//    var regionId:String?
//    var region:String?
    var giftImages:[String]?
    var id:String?
    var isNew:Bool?
//    var forWho:Int?
}
