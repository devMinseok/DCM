//
//  LoginFlow.swift
//  DCM_iOS
//
//  Created by 강민석 on 2020/09/08.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import UIKit
import RxFlow

class LoginFlow: Flow {
    
    // MARK: - Properties
    private let services: DCMService
    
    var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        // Navigation Bar를 transparent하게
        viewController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        viewController.navigationBar.shadowImage = UIImage()
        viewController.navigationBar.isTranslucent = true
        return viewController
    }()
    
    // MARK: - Init
    init(withServices services: DCMService) {
        self.services = services
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
    
    // MARK: - Navigation Switch
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? DCMStep else { return .none }
        
        switch step {
        case .loginIsRequired:
            return navigateToLogin()
        default:
            return .none
        }
    }
}

// MARK: - Navigate to Intro
extension LoginFlow {
    private func navigateToLogin() -> FlowContributors {
        let viewModel = LoginViewModel()
        let viewController = LoginViewController.instantiate(withViewModel: viewModel, andServices: self.services)
        
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                                 withNextStepper: viewModel))
    }
}
