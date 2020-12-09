//
//  BaseViewController.swift
//  DCM_iOS
//
//  Created by 강민석 on 2020/09/08.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NVActivityIndicatorView
import SwiftMessages

class BaseViewController: UIViewController, ViewModelBased, NVActivityIndicatorViewable {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    var viewModel: BaseViewModel!
    let isLoading = BehaviorRelay(value: false)
    let error = PublishSubject<String>()
    
    // MARK: - View life cycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    // MARK: - BindViewModel
    public func bindViewModel() {
        viewModel.loading.bind(to: self.isLoading).disposed(by: disposeBag)
        viewModel.error.bind(to: self.error).disposed(by: disposeBag)
        
        isLoading.subscribe(onNext: { [weak self] isLoading in
            self?.view.endEditing(true)
            UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
        }).disposed(by: disposeBag)
        
        isLoading.asDriver().drive(onNext: { [weak self] isLoading in
            isLoading ? self?.startAnimating(type: .circleStrokeSpin) : self?.stopAnimating()
        }).disposed(by: disposeBag)
        
        error.subscribe(onNext: { error in
            let errorView = MessageView.viewFromNib(layout: .cardView)
            errorView.configureTheme(.error)
            errorView.configureContent(title: error, body: "")
            errorView.button?.isHidden = true
            SwiftMessages.show(view: errorView)
        }).disposed(by: disposeBag)
    }
}
