//
//  SubmitViewModel.swift
//  DCM_iOS
//
//  Created by 강민석 on 2020/09/09.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxSwift
import RxCocoa
import FirebaseFirestore
import FirebaseStorage

class SubmitViewModel: BaseViewModel {
    
    let profileImage = BehaviorRelay(value: UIImage())
    let name = BehaviorRelay(value: "")
    let price = BehaviorRelay(value: "")
    let content = BehaviorRelay(value: "")
    let reason = BehaviorRelay(value: "")
    
    // MARK: - Struct
    struct Input {
        let submitTrigger: Driver<Void>
    }
    
    struct Output {
        //        let submitButtonEnabled: Driver<Bool>
    }
    
    
    
    
}

extension SubmitViewModel {
    func transform(input: Input) -> Output {
        
        input.submitTrigger
            .drive(onNext: { [weak self] in
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
                let timeString = formatter.string(from: Date())
                self?.requestAdd(createAt: timeString)
            }).disposed(by: disposeBag)
        return Output()
    }
    
    func requestAdd(createAt: String) {
        // Data in memory
        let image = profileImage.value
        let data = image.pngData()
        
        // Create a reference to the file you want to upload
        let storageRef = Storage.storage().reference()
        let riversRef = storageRef.child("submit/\(createAt)")
        
        self.loading.accept(true)
        riversRef.putData(data!, metadata: nil) { (metadata, error) in
            riversRef.downloadURL { (url, error) in
                guard let url = url else { return }
                
                let db = Firestore.firestore()
                db.collection("submit").document(createAt).setData([
                    "name": self.name.value,
                    "reason": self.reason.value,
                    "price": self.price.value,
                    "content": self.content.value,
                    "submitUser": KeychainManager.getToken(),
                    "createAt": createAt,
                    "submitAble": 0,
                    "imageUrl": String(describing: url)
                ]) { err in
                    if let err = err {
                        self.loading.accept(false)
                        self.error.onNext("\(err)에러")
                    } else {
                        self.steps.accept(DCMStep.popToRoot)
                        self.loading.accept(false)
                    }
                }
                
            }
        }
    }
    
    
}
