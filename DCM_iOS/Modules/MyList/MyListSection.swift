//
//  MyListSection.swift
//  DCM_iOS
//
//  Created by 강민석 on 2020/11/03.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxSwift
import RxDataSources

enum MyListSection {
    case list(title: String, items: [MyListSectionItem])
}

enum MyListSectionItem {
    case rentItem(model: ProductModel)
    case submitItem(model: ProductModel)
}

extension MyListSection: SectionModelType {
    typealias Item = MyListSectionItem
    
    var title: String {
        switch self {
        case .list(let title, _):
            return title
        }
    }
    
    var items: [Item] {
        switch self {
        case .list(_ , let items):
            return items.map { $0 }
        }
    }
    
    init(original: MyListSection, items: [Item]) {
        switch original {
        case .list(let title, let items):
            self = .list(title: title, items: items)
        }
    }
}
