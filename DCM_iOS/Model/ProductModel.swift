//
//  ProductModel.swift
//  DCM_iOS
//
//  Created by 강민석 on 2020/09/08.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation

struct ProductModel: Codable {
    let name: String
    let imageUrl: String
    let content: String
    let rentAble: Int
    let rentUser: String
    let createAt: String
    
    var isSubmit: Bool = false
}
