//
//  ShadowContainerNode.swift
//  Onboarding Search Filter
//
//  Created by Abram Situmorang on 19/06/19.
//

import AsyncDisplayKit

public final class ShadowContainerNode: ASDisplayNode {
    private let containerView = ASDisplayNode()
    private let rootNode: ASDisplayNode
    
    private struct ShadowContainerValue {
        let cornerRadius: CGFloat
        let color: CGColor
        let opacity: Float
        let offset: CGSize
        let radius: CGFloat
    }
    
    private let shadowContainerValue: ShadowContainerValue
    
    public init(rootNode: ASDisplayNode, cornerRadius: CGFloat = 4, color: CGColor = UIColor.black.cgColor, opacity: Float = 0.12, offset: CGSize = CGSize(width: 0, height: 2), shadowRadius: CGFloat = 4) {
        self.shadowContainerValue = ShadowContainerValue(cornerRadius: cornerRadius, color: color, opacity: opacity, offset: offset, radius: shadowRadius)
        self.rootNode = rootNode
        super.init()
        self.automaticallyManagesSubnodes = true
        containerView.cornerRadius = cornerRadius
        containerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
    }
    
    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASBackgroundLayoutSpec(child: rootNode, background: containerView)
    }
    
    public override func layoutDidFinish() {
        super.layoutDidFinish()
        // configure shadow in layoutDidFinish, because the "layer" property should be accessed in Main Thread
        configureShadow(shadowContainerValue: shadowContainerValue)
    }
    
    private func configureShadow(shadowContainerValue: ShadowContainerValue) {
        containerView.layer.shadowColor = shadowContainerValue.color
        containerView.layer.shadowOpacity = shadowContainerValue.opacity
        containerView.layer.shadowOffset = shadowContainerValue.offset
        containerView.layer.shadowRadius = shadowContainerValue.radius
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: shadowContainerValue.cornerRadius).cgPath
    }
}
