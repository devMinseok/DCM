//
//  TabBarFlow.swift
//  DCM_iOS
//
//  Created by 강민석 on 2020/09/08.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import RxFlow

class TabBarFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    let rootViewController = UITabBarController()
    private let services: DCMService
    
    init(withServices services: DCMService) {
        self.services = services
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? DCMStep else { return .none }
        
        switch step {
        case .tabBarIsRequired:
            return navigateToTabBar()
        default:
            return .none
        }
    }
    
    private func navigateToTabBar() -> FlowContributors {
        // stepper
        let homeFlow = HomeFlow(withServices: self.services)
        let listFlow = ListFlow(withServices: self.services)
        let profileFlow = ProfileFlow(withServices: self.services)
        
        Flows.use(homeFlow, listFlow, profileFlow, when: .created) { [unowned self] (root1, root2, root3: UINavigationController) in
            
            let tabBarItem1 = UITabBarItem(title: nil, image: UIImage(named: "Home_Icon"), selectedImage: nil)
            let tabBarItem2 = UITabBarItem(title: nil, image: UIImage(named: "List_Icon"), selectedImage: nil)
            let tabBarItem3 = UITabBarItem(title: nil, image: UIImage(named: "Profile_Icon"), selectedImage: nil)
            
            root1.tabBarItem = tabBarItem1
            root1.title = "홈"
            root2.tabBarItem = tabBarItem2
            root2.title = "목록"
            root3.tabBarItem = tabBarItem3
            root3.title = "프로필"
            
            self.rootViewController.setViewControllers([root1, root2, root3], animated: false)
        }
        
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: homeFlow,
                        withNextStepper: OneStepper(withSingleStep: DCMStep.homeIsRequired)),
            .contribute(withNextPresentable: listFlow,
                        withNextStepper: OneStepper(withSingleStep: DCMStep.listIsRequired)),
            .contribute(withNextPresentable: profileFlow,
                        withNextStepper: OneStepper(withSingleStep: DCMStep.profileIsRequired))
        ])
        
    }
}
