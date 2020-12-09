//
//  HomeFlow.swift
//  DCM_iOS
//
//  Created by 강민석 on 2020/09/08.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa
import UIKit

class HomeFlow: Flow {
    // MARK: - Properties
    var root: Presentable {
        return self.rootViewController
    }
    
    let rootViewController = UINavigationController()
    private let services: DCMService
    
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
        case .homeIsRequired:
            return navigateToHome()
        case .productIsRequired(let product):
            return navigateToProduct(product: product)
        case .popToRoot:
            return popToRoot()
        default:
            return .none
        }
    }
}

extension HomeFlow {
    func navigateToHome() -> FlowContributors {
        let viewModel = HomeViewModel()
        let viewController = HomeViewController.instantiate(withViewModel: viewModel, andServices: self.services)
        
        self.rootViewController.pushViewController(viewController, animated: true)
        
        viewController.title = "홈"
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                                 withNextStepper: viewModel))
    }
}

extension HomeFlow {
    func navigateToProduct(product: ProductModel) -> FlowContributors {
        let viewModel = ProductViewModel(product: product)
        let viewController = ProductViewController.instantiate(withViewModel: viewModel, andServices: self.services)
        
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                                 withNextStepper: viewModel))
    }
}

extension HomeFlow {
    func popToRoot() -> FlowContributors {
        self.rootViewController.popToRootViewController(animated: true)
        return .none
    }
}
