//
//  ListViewModel.swift
//  DCM_iOS
//
//  Created by 강민석 on 2020/09/09.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxSwift
import RxCocoa
import FirebaseFirestore

class ListViewModel: BaseViewModel {
    
    struct Input {
        let selection: Driver<MyListSectionItem>
        let segmented: Driver<Int>
        let submitButton: Driver<Void>
    }
    
    struct Output {
        let items: BehaviorRelay<[MyListSection]>
    }
    
    let elements = BehaviorRelay<[MyListSection]>(value: [])
    
    func transform(input: Input) -> Output {
        input.selection
            .drive(onNext: { item in
                switch item {
                case .rentItem(let model):
                    self.steps.accept(DCMStep.productIsRequired(product: model))
                case .submitItem(var model):
                    model.isSubmit = true
                    self.steps.accept(DCMStep.productIsRequired(product: model))
                }
            }).disposed(by: disposeBag)
        
        input.segmented
            .drive(onNext: { [weak self] index in
                print(index)
                self?.productRequest(index: index)
            }).disposed(by: disposeBag)
        
        input.submitButton
            .drive(onNext: { [weak self] in
                self?.steps.accept(DCMStep.submitIsRequired)
            }).disposed(by: disposeBag)
        
        return Output(items: elements)
    }
    
    func productRequest(index: Int) {
        let db = Firestore.firestore()
        
        self.loading.accept(true)
        
        if index == 0 {
            db.collection("product")
                .whereField("rentUser", isEqualTo: KeychainManager.getToken())
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
                    
                    var items: [MyListSectionItem] = []
                    product.forEach { (model) in
                        items.append(MyListSectionItem.rentItem(model: model))
                    }
                    self.elements.accept([MyListSection.list(title: "", items: items)])
                }
        } else {
            db.collection("submit")
                .whereField("submitUser", isEqualTo: KeychainManager.getToken())
                .whereField("submitAble", isEqualTo: 0)
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
                        let submitAble = data["submitAble"] as? Int ?? 0
                        let submitUser = data["submitUser"] as? String ?? ""
                        let createAt = data["createAt"] as? String ?? ""
                        
                        return ProductModel(name: name,
                                            imageUrl: imageUrl,
                                            content: content,
                                            rentAble: submitAble,
                                            rentUser: submitUser,
                                            createAt: createAt)
                    }
                    self.loading.accept(false)
                    
                    var items: [MyListSectionItem] = []
                    product.forEach { (model) in
                        items.append(MyListSectionItem.submitItem(model: model))
                    }
                    self.elements.accept([MyListSection.list(title: "", items: items)])
                }
        }
    }
}
