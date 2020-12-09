//
//  BaseViewModel.swift
//  DCM_iOS
//
//  Created by 강민석 on 2020/09/08.
//  Copyright © 2020 MinseokKang. All rights reserved.
//


import RxFlow
import RxSwift
import RxCocoa

class BaseViewModel: ServicesViewModel, Stepper {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    let steps = PublishRelay<Step>()
    var services: DCMService!
    
    let loading = BehaviorRelay(value: false)
    let error = PublishSubject<String>()
    
    var page = 1
    
    // MARK: - Dummy
    struct Input {
    }
    
    struct Output {
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
