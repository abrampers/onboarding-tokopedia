//
//  FilterViewController.swift
//  Onboarding Search Filter
//
//  Created by Dhio Etanasti on 08/10/18.
//

import AsyncDisplayKit
import RxCocoa
import RxSwift

protocol FilterDelegate {
    func recvFilter(filter: Filter)
}

class FilterViewController: ASViewController<ASDisplayNode> {
    
    private let disposeBag = DisposeBag()
    private var viewModel: FilterViewModel
    
    public var delegate: FilterDelegate?
    
    private static let priceLabelAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.n200,
        .font: UIFont.systemFont(ofSize: 16, weight: .regular)
    ]
    
    private static let priceAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.n500,
        .font: UIFont.systemFont(ofSize: 22, weight: .regular)
    ]
    
    private let minimumPriceLabelNode: ASTextNode = {
        let node = ASTextNode()
        
        node.attributedText = NSAttributedString(string: "Minimum Price", attributes: FilterViewController.priceLabelAttributes)
        
        return node
    }()
    
    private let maximumPriceLabelNode: ASTextNode = {
        let node = ASTextNode()
        
        node.attributedText = NSAttributedString(string: "Maximum Price", attributes: FilterViewController.priceLabelAttributes)
        
        return node
    }()
    
    private let minimumPriceNode: ASTextNode = {
        let node = ASTextNode()
        
        node.attributedText = NSAttributedString(string: "Rp100", attributes: FilterViewController.priceAttributes)
        
        return node
    }()
    
    private let maximumPriceNode: ASTextNode = {
        let node = ASTextNode()
        
        node.attributedText = NSAttributedString(string: "Rp8.000.000", attributes: FilterViewController.priceAttributes)
        
        return node
    }()
    
    private var sliderNode: ASDisplayNode!
    
    private let slider = RangeSlider(minimumValue: 0.01, maximumValue: 10.0, lowerValue: 0.2, upperValue: 8.5, stepValue: 0.1)
    
    private let wholeSaleLabelNode: ASTextNode = {
        let node = ASTextNode()
        
        node.attributedText = NSAttributedString(string: "Wholesale", attributes: FilterViewController.priceAttributes)
        
        return node
    }()
    
    private var switchNode: ASDisplayNode!
    private let switchView: UISwitch = UISwitch()
    
    private let firstNode: ASDisplayNode =  {
        let node = ASDisplayNode()
        
        node.backgroundColor = .white
        node.style.width = ASDimensionMake("100%")
        
        return node
    }()
    
    private let shopTypeLabelNode: ASTextNode = {
        let node = ASTextNode()
        
        node.attributedText = NSAttributedString(string: "Shop Type", attributes: FilterViewController.priceAttributes)
        
        return node
    }()
    
    private let shopRightArrowNode: ASImageNode = {
        let node = ASImageNode()
        
        node.image = UIImage(named: "next")
        
        return node
    }()
    
    private let secondNode: ASDisplayNode =  {
        let node = ASDisplayNode()
        
        node.backgroundColor = .white
        node.style.width = ASDimensionMake("100%")
        
        return node
    }()
    
    private let buttonNode = ButtonNode(named: "Apply")
    private let goldMerchantNode = ShopTypeNode(title: "Gold Merchant")
    private let officialStoreNode = ShopTypeNode(title: "Official Store")
    
    public init(filterObject: Filter) {
        viewModel = FilterViewModel(filter: filterObject)
        
        let rootNode = ASDisplayNode()
        rootNode.backgroundColor = .n50
        
        super.init(node: rootNode)
        
        rootNode.automaticallyManagesSubnodes = true
        rootNode.automaticallyRelayoutOnSafeAreaChanges = true
        
        firstNode.automaticallyManagesSubnodes = true
        
        switchNode = ASDisplayNode(viewBlock: { () -> UIView in
            return self.switchView
        }) { [weak self] _ in
            guard let self = self else { return }
            self.switchView.isOn = false
        }
        
        switchNode.style.preferredSize = switchView.intrinsicContentSize
        
        sliderNode = ASDisplayNode(viewBlock: { () -> UIView in
            return self.slider
        })
        
        sliderNode.style.width = ASDimensionMake("100%")
        sliderNode.style.height = ASDimensionMake(30)
        
        
        // MARK: Upper layout spec
        firstNode.layoutSpecBlock = { [weak self] _, _ -> ASLayoutSpec in
            guard let self = self else { return ASLayoutSpec() }
            
            let leftPriceStack = ASStackLayoutSpec(direction: .vertical,
                                                   spacing: 6,
                                                   justifyContent: .start,
                                                   alignItems: .start,
                                                   children: [self.minimumPriceLabelNode, self.minimumPriceNode])
            
            let rightPriceStack = ASStackLayoutSpec(direction: .vertical,
                                                    spacing: 6,
                                                    justifyContent: .start,
                                                    alignItems: .end,
                                                    children: [self.maximumPriceLabelNode, self.maximumPriceNode])
            
            let priceStack = ASStackLayoutSpec(direction: .horizontal,
                                               spacing: 10,
                                               justifyContent: .spaceBetween,
                                               alignItems: .center,
                                               children: [leftPriceStack, rightPriceStack])
            
            let wholeSaleSwitchStack = ASStackLayoutSpec(direction: .horizontal,
                                                         spacing: 10,
                                                         justifyContent: .spaceBetween,
                                                         alignItems: .center,
                                                         children: [self.wholeSaleLabelNode, self.switchNode])
            
            let stack = ASStackLayoutSpec(direction: .vertical,
                                          spacing: 32,
                                          justifyContent: .center,
                                          alignItems: .stretch,
                                          children: [priceStack, self.sliderNode, wholeSaleSwitchStack])
            
            self.switchView.sizeToFit()
            
            return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16), child: stack)
        }
        
        secondNode.automaticallyManagesSubnodes = true
        
        // MARK: Lower layout spec
        secondNode.layoutSpecBlock = { [weak self] _, _ -> ASLayoutSpec in
            guard let self = self else { return ASLayoutSpec() }
            
            let upperStack = ASStackLayoutSpec(direction: .horizontal,
                                          spacing: 10,
                                          justifyContent: .spaceBetween,
                                          alignItems: .center,
                                          children: [self.shopTypeLabelNode, self.shopRightArrowNode])
            
            let lowerStack = ASStackLayoutSpec(direction: .horizontal,
                                               spacing: 12,
                                               justifyContent: .start,
                                               alignItems: .center,
                                               children: [self.goldMerchantNode, self.officialStoreNode])
            
            let stack = ASStackLayoutSpec(direction: .vertical, spacing: 16, justifyContent: .start, alignItems: .stretch, children: [upperStack, lowerStack])
            
            return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16), child: stack)
        }
        
        buttonNode.rx.tap.asObservable().subscribe(onNext: { [weak self] (_) in
            // TODO: Get data from this viewcontroller
            self?.delegate?.recvFilter(filter: Filter(q: "Apple", pmin: 800000, pmax: 50000, wholesale: false, official: false, fshop: 0, rows: 10))
            self?.navigationController?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        rootNode.layoutSpecBlock = { [weak self] _, _ -> ASLayoutSpec in
            guard let self = self else { return ASLayoutSpec() }
            let innerStack = ASStackLayoutSpec(direction: .vertical,
                                     spacing: 10,
                                     justifyContent: .start,
                                     alignItems: .center,
                                     children: [self.firstNode, self.secondNode])
            
            let buttonInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8), child: self.buttonNode)
            
            let outerStack = ASStackLayoutSpec(direction: .vertical,
                                               spacing: 16,
                                               justifyContent: .spaceBetween,
                                               alignItems: .stretch,
                                               children: [innerStack, buttonInsetSpec])
            
            return ASInsetLayoutSpec(insets: UIEdgeInsets(top: self.node.safeAreaInsets.top + 10,
                                                          left: self.node.safeAreaInsets.left,
                                                          bottom: self.node.safeAreaInsets.bottom,
                                                          right: self.node.safeAreaInsets.right),
                                     child: outerStack)
            
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupNavBar()
        bindViewModel()
    }
    
    private func setupNavBar() {
        title = "Filter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem?.tintColor = .tpGreen
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: nil, action: nil)
        navigationItem.leftBarButtonItem?.tintColor = .n500
    
        navigationItem.leftBarButtonItem?.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] (_) in
                self?.navigationController?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        
    }
}
