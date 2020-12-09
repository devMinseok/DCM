//
//  KeychainManager.swift
//  DCM_iOS
//
//  Created by 강민석 on 2020/09/09.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import KeychainAccess

class KeychainManager {
    
    static let shared = KeychainManager()
    
    private init() {}

    // MARK: - Properties
    fileprivate let tokenKey = "TokenKey"
    fileprivate let keychain = Keychain(service: "com.tistory.axe-num1.CoatCode")
    
    var token: String? {
        get {
            guard let token = keychain[tokenKey] else { return nil }
            return token
        }
        set {
            if let token = newValue {
                keychain[tokenKey] = token
            } else {
                keychain[tokenKey] = nil
            }
        }
    }
    
    class func getToken() -> String {
        if let token = KeychainManager.shared.token {
            return token
        } else {
            return ""
        }
    }

    class func setToken(token: String) {
        KeychainManager.shared.token = token
    }

    class func removeToken() {
        KeychainManager.shared.token = nil
    }
    
}
