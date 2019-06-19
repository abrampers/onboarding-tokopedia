//
//  SearchCollectionCellNode.swift
//  Onboarding Search Filter
//
//  Created by Abram Situmorang on 19/06/19.
//

import AsyncDisplayKit

class SearchCollectionCellNode: ASCellNode {
    private lazy var cellRootNode = SearchCollectionCellRootNode(image: UIImage(named: "tesla")!, title: "Tesla", price: 5000)
    
    private lazy var shadowNode = ShadowContainerNode(rootNode: cellRootNode, cornerRadius: 8)//ShadowContainerNode(rootNode: cellRootNode, cornerRadius: 8)
    
    override init() {
        super.init()
        
        self.automaticallyManagesSubnodes = true
        
        cellRootNode.cornerRadius = 8
        cellRootNode.clipsToBounds = true
        self.clipsToBounds = false
        
        bindViewModel()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASWrapperLayoutSpec(layoutElement: shadowNode)
    }
    
    private func bindViewModel() {
        
    }
    
    func bind(product: Product) {

    }
}


private class SearchCollectionCellRootNode: ASDisplayNode {
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID")
        return formatter
    }()
    
    // TODO: nanti diganti network image node kalo networking udah ada
    private let searchCollectionImageNode: ASImageNode = {
        let node = ASImageNode()
        
        node.style.preferredSize = CGSize(width: 150, height: 150)
        
        return node
    }()
    
    private let searchCollectionTitleNode: ASTextNode = {
        let node = ASTextNode()
        
        node.truncationMode = .byTruncatingTail
        node.truncationAttributedText = NSAttributedString(string: "...")
        
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
    
    private let searchCollectionPriceNode = ASTextNode()
    
    required init(image: UIImage, title: String, price: Int) {
        super.init()
        
        self.backgroundColor = .white
        
        searchCollectionImageNode.image = image
        searchCollectionTitleNode.attributedText = NSAttributedString(string: title,
                                                                      attributes: [
                                                                        .font: UIFont.systemFont(ofSize: 15, weight: .heavy),
                                                                        .foregroundColor: #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)])
        searchCollectionPriceNode.attributedText = NSAttributedString(string: self.currencyFormatter.string(for: price) ?? "",
                                                                      attributes: [
                                                                        .font: UIFont.systemFont(ofSize: 15, weight: .medium),
                                                                        .foregroundColor: #colorLiteral(red: 0.9333333333, green: 0.4470588235, blue: 0.2901960784, alpha: 1)])
        
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let bottomVStackSpec = ASStackLayoutSpec(direction: .vertical,
                                                 spacing: 0,
                                                 justifyContent: .start,
                                                 alignItems: .start,
                                                 children: [searchCollectionTitleNode, searchCollectionPriceNode])
        
        let insetBottomSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6), child: bottomVStackSpec)
        
        let vStackSpec = ASStackLayoutSpec(direction: .vertical,
                                           spacing: 6,
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
