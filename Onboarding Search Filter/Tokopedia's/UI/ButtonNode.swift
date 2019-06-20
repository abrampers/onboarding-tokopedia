//
//  ButtonNode.swift
//  Onboarding Search Filter
//
//  Created by Abram Situmorang on 20/06/19.
//

import AsyncDisplayKit

internal func ButtonNode(named name: String) -> ASButtonNode {
    let node = ASButtonNode()
    node.backgroundColor = UIColor.tpGreen
    node.setAttributedTitle(NSAttributedString(string: name, attributes: [
        .foregroundColor: UIColor.white,
        .font: UIFont.systemFont(ofSize: 14)
        ]), for: .normal)
    
    node.style.width = ASDimensionMake("100%")
    node.style.height = ASDimensionMake(40)
    
    // Use precomposition for rounding corners
    node.cornerRoundingType = ASCornerRoundingType.defaultSlowCALayer // kenapa gabisa pake .clipping or .precomposited
    node.cornerRadius = 8.0
    
    return node
}
