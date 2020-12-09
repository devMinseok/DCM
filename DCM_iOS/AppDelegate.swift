//
//  AppDelegate.swift
//  DCM_iOS
//
//  Created by 강민석 on 2020/09/08.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import RxFlow
import RxSwift
import RxCocoa
import RealmSwift
import FirebaseCore
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var window: UIWindow?
    let appStepper = AppStepper()
    var coordinator = FlowCoordinator()
    
    lazy var appService = {
        return DCMService()
    }()
    
    lazy var rootFlow: AppFlow = {
        guard let window = window else { fatalError("Cannot get window: UIWindow?") }
        return AppFlow(window: window, services: self.appService)
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
//        do {
//            try Auth.auth().signOut()
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//        }
        
        self.coordinator.rx.willNavigate.subscribe(onNext: { (flow, step) in
            print("will navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)
        
        self.coordinator.rx.didNavigate.subscribe(onNext: { (flow, step) in
            print("did navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)
        
        self.coordinator.coordinate(flow: self.rootFlow, with: self.appStepper)
        
        return true
    }
}
