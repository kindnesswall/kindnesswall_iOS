//
//  KeychainService.swift
//  app
//
//  Created by Hamed Ghadirian on 08.12.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import KeychainSwift

enum KeychainKey {
    case deviceIdentifier
    case pushToken
    case passCode
    case authorization
    case isAdmin
    case isCharity
    case userId
    
    var key: String {
        switch self {
        case .deviceIdentifier:
            return AppConst.KeyChain.DeviceIdentifier
        case .pushToken:
            return AppConst.KeyChain.PushToken
        case .passCode:
            return AppConst.KeyChain.PassCode
        case .authorization:
            return AppConst.KeyChain.Authorization
        case .isAdmin:
            return AppConst.KeyChain.IsAdmin
        case .isCharity:
            return AppConst.KeyChain.IsCharity
        case .userId:
            return AppConst.KeyChain.UserID
        }
    }
}

class KeychainService {
    private let keychain = KeychainSwift()

    func clearUserSensitiveData() {
        delete(.userId)
        delete(.isAdmin)
        delete(.authorization)
        delete(.passCode)
    }

    func set(authOutput: AuthOutput) {
        if let userID = authOutput.token.userID?.description, let token = authOutput.token.token {
            set(.userId, value: userID)
            let authorization = AppConst.KeyChain.BEARER + " " + token
            set(.authorization, value: authorization)
        }

        set(.isAdmin, value: authOutput.isAdmin)
        set(.isCharity, value: authOutput.isCharity)
    }
    
    func isUserLogedIn() -> Bool {
        return getString(.authorization) != nil
    }
    
    public func isPasscodeSaved() -> Bool {
        return getString(.passCode) != nil
    }
    
    func isAdmin() -> Bool {
        return keychain.getBool(AppConst.KeyChain.IsAdmin) ?? false
    }
    
    func isCharity() -> Bool {
        return keychain.getBool(AppConst.KeyChain.IsCharity) ?? false
    }
    
    func set(_ key: KeychainKey, value: String) {
        switch key {
        case .deviceIdentifier, .pushToken, .passCode, .authorization, .userId:
            keychain.set(value, forKey: key.key)
        case .isAdmin, .isCharity:
            fatalError("Associated value is not String!")
        }
    }
    
    func set(_ key: KeychainKey, value: Bool) {
        switch key {
        case .isAdmin, .isCharity:
            keychain.set(value, forKey: key.key)
        case .deviceIdentifier, .pushToken, .passCode, .authorization, .userId:
            fatalError("Associated value is not Boolean!")
        }
    }
    
    func delete(_ key: KeychainKey) {
        keychain.delete(key.key)
    }
    
    func getString(_ key: KeychainKey) -> String? {
        switch key {
        case .deviceIdentifier, .pushToken, .passCode, .authorization, .userId:
            return keychain.get(key.key)
        case .isAdmin, .isCharity:
            print("Error: Associated value is not String!")
            return nil
        }
    }
    
    func clear() {
        keychain.clear()
    }
    
}
