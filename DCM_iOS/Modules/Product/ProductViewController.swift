//
//  ProductViewController.swift
//  DCM_iOS
//
//  Created by 강민석 on 2020/09/08.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import Kingfisher
import RxViewController
import RxDataSources

class ProductViewController: BaseViewController, StoryboardSceneBased {
    
    static let sceneStoryboard = UIStoryboard(name: "Product", bundle: nil)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var requestButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "ProductDetailCell", bundle: nil), forCellReuseIdentifier: "ProductDetailCell")
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = self.viewModel as? ProductViewModel else { fatalError("ViewModel Casting Falid!") }
        
        let refresh = self.rx.viewWillAppear.map { _ in }
        let input = ProductViewModel.Input(viewTrigger: refresh, buttonTrigger: requestButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        output.item.bind(to: tableView.rx.items(cellIdentifier: "ProductDetailCell", cellType: ProductDetailCell.self)) { (index: Int, element: ProductModel, cell: ProductDetailCell) in
            
            let url = URL(string: element.imageUrl)
            cell.productImageView.kf.setImage(with: url)
            cell.nameLabel.text = element.name
            cell.contentTextView.text = element.content
            
            
            if element.isSubmit {
                switch element.rentAble {
                case 0:
                    self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(red: 0.89, green: 0.64, blue: 0.00, alpha: 1.00)]
                    self.navigationItem.title = "승인 대기 중"
                case 1:
                    self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(red: 0.11, green: 0.54, blue: 0.00, alpha: 1.00)]
                    self.navigationItem.title = "승인됨"
                case 2:
                    self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(red: 0.78, green: 0.00, blue: 0.00, alpha: 1.00)]
                    self.navigationItem.title = "승인 거절됨"
                default:
                    self.navigationItem.title = "Error!"
                }
            } else {
                switch element.rentAble {
                case 0:
                    self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(red: 0.78, green: 0.00, blue: 0.00, alpha: 1.00)]
                    self.navigationItem.title = "대여 중"
                case 1:
                    self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(red: 0.11, green: 0.54, blue: 0.00, alpha: 1.00)]
                    self.navigationItem.title = "대여 가능"
                case 2:
                    self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(red: 0.89, green: 0.64, blue: 0.00, alpha: 1.00)]
                    self.navigationItem.title = "대기 중"
                default:
                    self.navigationItem.title = "Error!"
                }
            }
        }.disposed(by: disposeBag)
        
        output.buttonEnabled
            .drive(requestButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
