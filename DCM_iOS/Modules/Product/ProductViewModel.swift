//
//  ProductViewModel.swift
//  DCM_iOS
//
//  Created by 강민석 on 2020/09/08.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxSwift
import RxCocoa
import FirebaseFirestore

class ProductViewModel: BaseViewModel {
    
    let elements = BehaviorRelay<[ProductModel]>(value: [])
    let productModel: ProductModel
    let buttonStatus = BehaviorRelay(value: false)
    
    init(product: ProductModel) {
        self.productModel = product
    }
    
    struct Input {
        let viewTrigger: Observable<Void>
        let buttonTrigger: Driver<Void>
    }
    
    struct Output {
        let item: BehaviorRelay<[ProductModel]>
        let buttonEnabled: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        input.viewTrigger
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.elements.accept([self.productModel])
                
                if self.productModel.rentAble == 1 {
                    self.buttonStatus.accept(true)
                }
            }).disposed(by: disposeBag)
        
        input.buttonTrigger
            .drive(onNext: { [weak self] in
                self?.requestRent()
            }).disposed(by: disposeBag)
        
        return Output(item: elements, buttonEnabled: buttonStatus.asDriver())
    }
    
    func requestRent() {
        let db = Firestore.firestore()
        
        self.loading.accept(true)
        db.collection("product").document(self.productModel.createAt)
            .setData([
                "name": self.productModel.name,
                "imageUrl": self.productModel.imageUrl,
                "content": self.productModel.content,
                "rentAble": 2, // 대기중으로 전환
                "rentUser": KeychainManager.getToken(), // 로그인시 받은 유저 고유값
                "createAt": self.productModel.createAt
            ]) { error in
                if let error = error {
                    self.loading.accept(false)
                    print("Error adding document: \(error)")
                } else {
                    print("Added")
                    self.loading.accept(false)
                    self.steps.accept(DCMStep.popToRoot)
                }
        }
    }
}
