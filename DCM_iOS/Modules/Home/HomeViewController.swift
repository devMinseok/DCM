//
//  HomeViewController.swift
//  DCM_iOS
//
//  Created by 강민석 on 2020/09/08.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import RxViewController
import Kingfisher

class HomeViewController: BaseViewController, StoryboardSceneBased {
    
    static let sceneStoryboard = UIStoryboard(name: "Home", bundle: nil)
    
    @IBOutlet weak var topSegmented: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        configureSegmentedControl()
    }
    
    func configureSegmentedControl() {
        self.topSegmented.tintColor = UIColor(red: 0.02, green: 0.05, blue: 0.42, alpha: 1.00)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = self.viewModel as? HomeViewModel else { fatalError("ViewModel Casting Falid!") }
        
        let input = HomeViewModel.Input(selection: self.tableView.rx.modelSelected(ProductModel.self).asDriver(),
                                        segmented: self.topSegmented.rx.selectedSegmentIndex.asDriver())
        let output = viewModel.transform(input: input)
        
        output.items.bind(to: tableView.rx.items(cellIdentifier: "ProductCell", cellType: ProductCell.self)) { (index: Int, element: ProductModel, cell: ProductCell) in
            let url = URL(string: element.imageUrl)
            cell.productImageView.kf.setImage(with: url)
            cell.nameLabel.text = element.name
            
            switch element.rentAble {
            case 0:
                cell.stateLabel.textColor = UIColor(red: 0.78, green: 0.00, blue: 0.00, alpha: 1.00)
                cell.stateLabel.text = "대여 중"
            case 1:
                cell.stateLabel.textColor = UIColor(red: 0.11, green: 0.54, blue: 0.00, alpha: 1.00)
                cell.stateLabel.text = "대여 가능"
            case 2:
                cell.stateLabel.textColor = UIColor(red: 0.89, green: 0.64, blue: 0.00, alpha: 1.00)
                cell.stateLabel.text = "승인 대기 중"
            default:
                cell.stateLabel.text = "Error!"
            }
        }.disposed(by: disposeBag)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
