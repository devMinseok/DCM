//
//  SubmitViewController.swift
//  DCM_iOS
//
//  Created by 강민석 on 2020/09/09.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import RxGesture

class SubmitViewController: BaseViewController, StoryboardSceneBased {

    static let sceneStoryboard = UIStoryboard(name: "Submit", bundle: nil)
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextField!
    @IBOutlet weak var reasonTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindProfileImage()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = self.viewModel as? SubmitViewModel else { fatalError("ViewModel Casting Falid!") }
     
        let input = SubmitViewModel.Input(submitTrigger: submitButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        nameTextField.rx.text.orEmpty
            .bind(to: viewModel.name)
            .disposed(by: disposeBag)
        
        priceTextField.rx.text.orEmpty
            .bind(to: viewModel.price)
            .disposed(by: disposeBag)
        
        contentTextField.rx.text.orEmpty
            .bind(to: viewModel.content)
            .disposed(by: disposeBag)
        
        reasonTextField.rx.text.orEmpty
            .bind(to: viewModel.reason)
            .disposed(by: disposeBag)
        
    }
}

// MARK: - BindImagePicker
extension SubmitViewController {
    func bindProfileImage() {
        guard let viewModel = viewModel as? SubmitViewModel else { fatalError("ViewModel Casting Falid!") }
        
        let imagePicker = imagePickerScene(
            on: self,
            modalPresentationStyle: .formSheet,
            modalTransitionStyle: .none
        )

        imageView.rx.tapGesture()
            .when(.recognized)
            .flatMapLatest { _ in Observable.create(imagePicker) }
            .compactMap { $0[.originalImage] as? UIImage }
            .bind { image in
                self.imageView.clipsToBounds = true
                self.imageView.image = image
                viewModel.profileImage.accept(image)
            }
            .disposed(by: disposeBag)
    }
}
