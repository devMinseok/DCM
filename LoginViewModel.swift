//
//  LoginViewModel.swift
//  DCM_iOS
//
//  Created by 강민석 on 2020/09/08.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxSwift
import RxCocoa
import FirebaseAuth

let loggedIn = BehaviorRelay<Bool>(value: false)

class LoginViewModel: BaseViewModel {
    
    let email = BehaviorRelay(value: "")
    let password = BehaviorRelay(value: "")
    
    // MARK: - Struct
    struct Input {
        let signInTrigger: Driver<Void>
    }
    
    struct Output {
        let loginButtonEnabled: Driver<Bool>
    }
}

// MARK: - Transform
extension LoginViewModel {
    func transform(input: Input) -> Output {
        // MARK: - Button Trigger
        input.signInTrigger
            .drive(onNext: { [weak self] in
                self?.loginRequest()
            }).disposed(by: disposeBag)
        
        let loginButtonEnabled = BehaviorRelay.combineLatest(email, password, self.loading.asObservable()) {
            return !$0.isEmpty && !$1.isEmpty && !$2
        }.asDriver(onErrorJustReturn: false)
        
        return Output(loginButtonEnabled: loginButtonEnabled)
    }
}

extension LoginViewModel {
    func loginRequest() {
        self.loading.accept(true)
        Auth.auth().signIn(withEmail: self.email.value, password: password.value) { (user, error) in
            if let user = user {
                
                // 사용자 정보 저장
                user.user.email
                user.user.displayName
                
                KeychainManager.setToken(token: user.user.uid)
                self.loading.accept(false)
                loggedIn.accept(true)
            } else {
                self.loading.accept(false)
                self.error.onNext("로그인 실패")
            }
        }
    }
}
