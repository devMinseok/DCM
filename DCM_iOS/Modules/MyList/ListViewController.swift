//
//  ListViewController.swift
//  DCM_iOS
//
//  Created by 강민석 on 2020/09/09.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import RxDataSources

class ListViewController: BaseViewController, StoryboardSceneBased {
    
    static let sceneStoryboard = UIStoryboard(name: "List", bundle: nil)
    
    @IBOutlet weak var topSegmented: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSegmentedControl()
        setButton()
        
        self.tableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    
    func configureSegmentedControl() {
        self.topSegmented.tintColor = UIColor(red: 0.02, green: 0.05, blue: 0.42, alpha: 1.00)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = self.viewModel as? ListViewModel else { fatalError("ViewModel Casting Falid!") }
        
        let input = ListViewModel.Input(selection: self.tableView.rx.modelSelected(MyListSectionItem.self).asDriver(),
                                        segmented: self.topSegmented.rx.selectedSegmentIndex.asDriver(),
                                        submitButton: self.submitButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        
        let dataSource = RxTableViewSectionedReloadDataSource<MyListSection>(configureCell: { dataSource, tableView, indexPath, item in
            switch item {
            case .rentItem(let model):
                let cell = (tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductCell)!
                
                let url = URL(string: model.imageUrl)
                cell.productImageView.kf.setImage(with: url)
                cell.nameLabel.text = model.name
                
                switch model.rentAble {
                case 0:
                    cell.stateLabel.textColor = UIColor(red: 0.78, green: 0.00, blue: 0.00, alpha: 1.00)
                    cell.stateLabel.text = "대여 중"
                case 1:
                    cell.stateLabel.textColor = UIColor(red: 0.11, green: 0.54, blue: 0.00, alpha: 1.00)
                    cell.stateLabel.text = "대여 가능"
                case 2:
                    cell.stateLabel.textColor = UIColor(red: 0.89, green: 0.64, blue: 0.00, alpha: 1.00)
                    cell.stateLabel.text = "대기 중"
                default:
                    cell.stateLabel.text = "Error!"
                }
                
                return cell
            case .submitItem(let model):
                let cell = (tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductCell)!
                
                let url = URL(string: model.imageUrl)
                cell.productImageView.kf.setImage(with: url)
                cell.nameLabel.text = model.name
                
                switch model.rentAble {
                case 0:
                    cell.stateLabel.textColor = UIColor(red: 0.89, green: 0.64, blue: 0.00, alpha: 1.00)
                    cell.stateLabel.text = "승인 대기 중"
                case 1:
                    cell.stateLabel.textColor = UIColor(red: 0.11, green: 0.54, blue: 0.00, alpha: 1.00)
                    cell.stateLabel.text = "승인됨"
                case 2:
                    cell.stateLabel.textColor = UIColor(red: 0.78, green: 0.00, blue: 0.00, alpha: 1.00)
                    cell.stateLabel.text = "승인 거절됨"
                default:
                    cell.stateLabel.text = "Error!"
                }
                
                return cell
            }
        })
        
        output.items
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    func setButton() {
        self.topSegmented.rx.selectedSegmentIndex
            .subscribe(onNext: { index in
                if index == 0 {
                    self.submitButton.isHidden = true
                } else {
                    self.submitButton.isHidden = false
                }
            }).disposed(by: disposeBag)
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
