//
//  LoginViewController.swift
//  DCM_iOS
//
//  Created by 강민석 on 2020/09/08.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

class LoginViewController: BaseViewController, StoryboardSceneBased {
    
    // MARK: - Properties
    static let sceneStoryboard = UIStoryboard(name: "Login" , bundle: nil)
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - BindViewModel
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = viewModel as? LoginViewModel else { fatalError("ViewModel Casting Falid!") }
        
        let input = LoginViewModel.Input(signInTrigger: loginButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        output.loginButtonEnabled
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
