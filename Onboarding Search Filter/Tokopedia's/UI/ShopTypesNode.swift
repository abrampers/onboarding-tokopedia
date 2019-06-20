//
//  ShopTypesNode.swift
//  Onboarding Search Filter
//
//  Created by Abram Situmorang on 20/06/19.
//

import AsyncDisplayKit

internal func ShopTypeNode(title: String) -> ASDisplayNode {
    let node = ASDisplayNode()
    
    node.cornerRadius = 17
    node.clipsToBounds = true
    node.borderColor = UIColor.n75.cgColor
    node.borderWidth = 1
    node.style.height = ASDimensionMake(34)
    
    let textNode = ASTextNode()
    
    let titleAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.n300,
        .font: UIFont.systemFont(ofSize: 15, weight: .regular)
    ]
    textNode.attributedText = NSAttributedString(string: title, attributes: titleAttributes)
    
    let circleNode = ASDisplayNode()
    circleNode.backgroundColor = .n50
    circleNode.cornerRadius = 17
    circleNode.borderColor = UIColor.n75.cgColor
    circleNode.borderWidth = 1
    circleNode.style.preferredSize = CGSize(width: 34, height: 34)
    
    node.automaticallyManagesSubnodes = true
    
    node.layoutSpecBlock = { _, _ -> ASLayoutSpec in
        let textInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0), child: textNode)
        
        return ASStackLayoutSpec(direction: .horizontal, spacing: 15, justifyContent: .spaceBetween, alignItems: .center, children: [textInsetSpec, circleNode])
    }
    
    return node
}
