//
//  HomeViewModel.swift
//  DCM_iOS
//
//  Created by 강민석 on 2020/09/08.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxSwift
import RxCocoa
import FirebaseFirestore

class HomeViewModel: BaseViewModel {
    
    struct Input {
        let selection: Driver<ProductModel>
        let segmented: Driver<Int>
    }
    
    struct Output {
        let items: BehaviorRelay<[ProductModel]>
    }
    
    let elements = BehaviorRelay<[ProductModel]>(value: [])
    
    func transform(input: Input) -> Output {
        input.selection
            .drive(onNext: { item in
                self.steps.accept(DCMStep.productIsRequired(product: item))
            }).disposed(by: disposeBag)
        
        input.segmented
            .drive(onNext: { [weak self] index in
                self?.productRequest(index: index - 1)
            }).disposed(by: disposeBag)
        
        return Output(items: elements)
    }
    
    func productRequest(index: Int) {
        
        print(index)
        
        let db = Firestore.firestore()
        
        self.loading.accept(true)
        
        let productRef = db.collection("product")
        
        if index == -1 {
            productRef.whereField("rentAble", isGreaterThan: index)
                .addSnapshotListener { (querySnapShot, error) in
                    guard let documents = querySnapShot?.documents else {
                        print("No documents")
                        return
                    }
                    
                    let product = documents.compactMap { (queryDocumentSnapshot) -> ProductModel? in
                        let data = queryDocumentSnapshot.data()
                        
                        let name = data["name"] as? String ?? ""
                        let imageUrl = data["imageUrl"] as? String ?? ""
                        let content = data["content"] as? String ?? ""
                        let rentAble = data["rentAble"] as? Int ?? 0
                        let rentUser = data["rentUser"] as? String ?? ""
                        let createAt = data["createAt"] as? String ?? ""
                        
                        return ProductModel(name: name,
                                            imageUrl: imageUrl,
                                            content: content,
                                            rentAble: rentAble,
                                            rentUser: rentUser,
                                            createAt: createAt)
                    }
                    self.loading.accept(false)
                    self.elements.accept(product)
            }
        } else {
            productRef.whereField("rentAble", isEqualTo: index)
                .addSnapshotListener { (querySnapShot, error) in
                    guard let documents = querySnapShot?.documents else {
                        print("No documents")
                        return
                    }
                    
                    let product = documents.compactMap { (queryDocumentSnapshot) -> ProductModel? in
                        let data = queryDocumentSnapshot.data()
                        
                        let name = data["name"] as? String ?? ""
                        let imageUrl = data["imageUrl"] as? String ?? ""
                        let content = data["content"] as? String ?? ""
                        let rentAble = data["rentAble"] as? Int ?? 0
                        let rentUser = data["rentUser"] as? String ?? ""
                        let createAt = data["createAt"] as? String ?? ""
                        
                        return ProductModel(name: name,
                                            imageUrl: imageUrl,
                                            content: content,
                                            rentAble: rentAble,
                                            rentUser: rentUser,
                                            createAt: createAt)
                    }
                    self.loading.accept(false)
                    self.elements.accept(product)
            }
        }
    }
}
