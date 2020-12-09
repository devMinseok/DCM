//
//  DBManager.swift
//  DCM_iOS
//
//  Created by 강민석 on 2020/09/09.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RealmSwift

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let realm: Realm
    
    private init() {
        self.realm = try! Realm()
    }
    
    /**
     realm 로컬 DB로 사용자 정보를 저장합니다.
     
     - parameters:
        - userData: DB에 추가할 사용자 정보
     */
    func saveUser(_ userData: UserModel) {
        do {
            try realm.write {
                realm.add(userData)
            }
        } catch {
            fatalError("DB Error!")
        }
    }
    
    func removeCurrentUser() {
        
    }
    
    
    
}
