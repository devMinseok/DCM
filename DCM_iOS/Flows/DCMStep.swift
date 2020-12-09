//
//  DCMStep.swift
//  DCM_iOS
//
//  Created by 강민석 on 2020/09/08.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxFlow

enum DCMStep: Step {
    case tabBarIsRequired
    case introIsRequired
    
    case loginIsRequired
 
    case homeIsRequired
    
    case profileIsRequired
    
    case listIsRequired
    
    case productIsRequired(product: ProductModel)
    
    case popToRoot
    
    case submitIsRequired
}
