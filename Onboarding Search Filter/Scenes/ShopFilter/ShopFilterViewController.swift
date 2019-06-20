//
//  ShopFilterViewController.swift
//  Onboarding Search Filter
//
//  Created by Dhio Etanasti on 08/10/18.
//

import UIKit
import RxCocoa
import RxSwift

class ShopFilterViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    let viewModel: ShopFilterViewModel
    
    public init(filterObject: Filter) {
        viewModel = ShopFilterViewModel(filter: filterObject)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        bindViewModel()
    }
    
    private func setupNavBar() {
        title = "Filter"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem?.tintColor = .tpGreen
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem?.tintColor = .n500
        
        self.navigationItem.leftBarButtonItem?.rx.tap.asObservable()
            .subscribe(onNext: { (_) in
                self.navigationController?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        
    }

}
