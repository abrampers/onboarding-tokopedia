//
//  TestViewController.swift
//  Onboarding Search Filter
//
//  Created by Abram Situmorang on 19/06/19.
//

import AsyncDisplayKit

class TestViewController: ASViewController<ASDisplayNode> {
    
    let customNode = SearchCollectionCellNode(product: Product(id: 1, name: "asdf", price: "asdf", imageURLString: "https://github.com/RxSwiftCommunity/RxCocoa-Texture/raw/master/resources/logo.png"))
    
    init() {
        super.init(node: ASDisplayNode())
        self.title = "Layout Example"
        
        self.node.addSubnode(customNode)
        
        self.node.backgroundColor = .lightGray
        
        self.node.layoutSpecBlock = { [weak self] node, constrainedSize in
            guard let customNode = self?.customNode else { return ASLayoutSpec() }
            return ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: customNode)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
