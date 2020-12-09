//
//  UserModel.swift
//  DCM_iOS
//
//  Created by 강민석 on 2020/09/09.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import RealmSwift

class UserModel: Object {
    @objc dynamic var email = ""
    @objc dynamic var username = ""
}
