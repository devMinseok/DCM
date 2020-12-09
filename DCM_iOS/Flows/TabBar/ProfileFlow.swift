//
//  ProfileFlow.swift
//  DCM_iOS
//
//  Created by 강민석 on 2020/09/08.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa
import UIKit

class ProfileFlow: Flow {
    
    // MARK: - Properties
    var root: Presentable {
        return self.rootViewController
    }
    
    private let rootViewController = UINavigationController()
    private let services: DCMService
    
    // MARK: - Init
    init(withServices services: DCMService) {
        self.services = services
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
    
    // MARK: - Navigation Swtich
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? DCMStep else { return .none }
        switch step {
        case .profileIsRequired:
            return navigateToProfile()
        default:
            return .none
        }
    }
}

extension ProfileFlow {
    func navigateToProfile() -> FlowContributors {
        let viewModel = ProfileViewModel()
        let viewController = ProfileViewController.instantiate(withViewModel: viewModel, andServices: self.services)
        
        self.rootViewController.pushViewController(viewController, animated: true)
        viewController.title = "프로필"
        return .none
    }
}
