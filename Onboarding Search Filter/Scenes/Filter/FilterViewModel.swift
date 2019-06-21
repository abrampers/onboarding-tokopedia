//
//  FilterViewModel.swift
//  Onboarding Search Filter
//
//  Created by Dhio Etanasti on 08/10/18.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

@objc public final class FilterViewModel: NSObject, ViewModelType {
    
    private let filter: Filter
    
    public init(filter: Filter) {
        self.filter = filter
    }
    
    public struct Input {
    }
    
    public struct Output {
//        let applyButtonTapTrigger: Driver<Void>
    }
    
    public func transform(input: Input) -> Output {
        
        return Output()
    }
}
