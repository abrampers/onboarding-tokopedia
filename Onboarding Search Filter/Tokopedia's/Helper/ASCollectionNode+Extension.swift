//
//  ASCollectionNode.swift
//  TopChat
//
//  Created by Alfon Lavinski on 10/06/19.
//
import AsyncDisplayKit
import RxCocoa
import RxSwift

extension ASCollectionNode {
    
    public var rxReachBottom: Driver<Void> {
        return self.view.rxReachBottomNode
    }
}
