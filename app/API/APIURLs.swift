//
//  APIURLs.swift
//  app
//
//  Created by Hamed.Gh on 10/13/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import Foundation

class APIURLs {
    static let BASE_URL="http://api.kindnesswall.ir/api/"
    static let API_VERSION = "v01/"

    static var BookmarkGift : String {
        return self.BASE_URL + self.API_VERSION + "BookmarkGift"
    }
    
    static var Gift : String {
        return self.BASE_URL + self.API_VERSION + "Gift/"
    }
}
