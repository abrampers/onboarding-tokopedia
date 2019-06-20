//
//  SearchCollectionCellNode.swift
//  Onboarding Search Filter
//
//  Created by Abram Situmorang on 19/06/19.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa_Texture

internal class SearchCollectionCellNode: ASCellNode {
    private var product: Product
    private var cellRootNode: SearchCollectionCellRootNode
    
    private lazy var shadowNode = ShadowContainerNode(rootNode: cellRootNode, cornerRadius: 8)
    
    let disposeBag = DisposeBag()
    
    internal init(product: Product) {
        self.product = product
        self.cellRootNode = SearchCollectionCellRootNode(imageURLString: product.imageURLString, title: product.name ?? "Name not found", price: product.price ?? "Price not found")
        super.init()
        
        self.style.width = ASDimensionMake(175)
        
        self.automaticallyManagesSubnodes = true
        self.neverShowPlaceholders = true
        
        cellRootNode.cornerRadius = 8
        cellRootNode.clipsToBounds = true
        self.clipsToBounds = false
        
        bindViewModel()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASWrapperLayoutSpec(layoutElement: shadowNode)
    }
    
    private func bindViewModel() {
        let viewModel = SearchCellViewModel(product: product)
        
        let output = viewModel.transform(input: SearchCellViewModel.Input())
        
        output.title.drive(self.cellRootNode.searchCollectionTitleNode.rx.text(cellRootNode.titleAttributes)).disposed(by: disposeBag)
        output.price.drive(self.cellRootNode.searchCollectionPriceNode.rx.text(cellRootNode.priceAttributes)).disposed(by: disposeBag)
        output.url.drive(self.cellRootNode.searchCollectionImageNode.rx.url).disposed(by: disposeBag)
    }
    
//    func bind(product: Product) {
//
//    }
}


private class SearchCollectionCellRootNode: ASDisplayNode {
    
    fileprivate let titleAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 15, weight: .medium),
        .foregroundColor: #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
    ]
    
    fileprivate let priceAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 15, weight: .medium),
        .foregroundColor: UIColor.tpOrange
    ]
    
    // TODO: nanti diganti network image node kalo networking udah ada
    fileprivate let searchCollectionImageNode: ASNetworkImageNode = {
        let node = ASNetworkImageNode()
        
        node.style.preferredSize = CGSize(width: 175, height: 175)
        
        return node
    }()
    
    fileprivate let searchCollectionTitleNode: ASTextNode = {
        let node = ASTextNode()
        
        node.truncationMode = .byTruncatingTail
        node.truncationAttributedText = NSAttributedString(string: "...")
        node.maximumNumberOfLines = 2
        
        return node
    }()
    
    //    private let shadowNode: ASDisplayNode = {
    //        let node = ASDisplayNode()
    //
    //        // TODO: Fix shadow
    //        node.layer.masksToBounds = false
    //        node.shadowColor = UIColor.lightGray.cgColor
    //        node.shadowRadius = 3
    //        node.shadowOpacity = 0.5
    //
    //        return node
    //    }()
    
    fileprivate let searchCollectionPriceNode = ASTextNode()
    
    required init(imageURLString: String?, title: String, price: String) {
        super.init()
        
        self.backgroundColor = .white
        
        searchCollectionImageNode.url = URL(string: imageURLString ?? "")
        searchCollectionTitleNode.attributedText = NSAttributedString(string: title,
                                                                      attributes: self.titleAttributes)
        searchCollectionPriceNode.attributedText = NSAttributedString(string: price,
                                                                      attributes: self.priceAttributes)
        
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let bottomVStackSpec = ASStackLayoutSpec(direction: .vertical,
                                                 spacing: 2,
                                                 justifyContent: .start,
                                                 alignItems: .start,
                                                 children: [searchCollectionTitleNode, searchCollectionPriceNode])
        
        let insetBottomSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 2, left: 6, bottom: 6, right: 6), child: bottomVStackSpec)
        
        let vStackSpec = ASStackLayoutSpec(direction: .vertical,
                                           spacing: 2,
                                           justifyContent: .start,
                                           alignItems: .start,
                                           children: [searchCollectionImageNode, insetBottomSpec])
        
        return vStackSpec
    }
    
    // TODO: if needed
    override func didLoad() {
        
    }
    
    // TODO: if needed
    override func layout() {
        
    }
    
}
