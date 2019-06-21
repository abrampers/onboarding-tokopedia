//
//  SearchViewModel.swift
//  Onboarding Search Filter
//
//  Created by Dhio Etanasti on 07/10/18.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

public final class SearchViewModel: NSObject, ViewModelType {
    
    private var filter: Filter
    private let useCase: SearchUseCase

    init(filter: Filter, useCase: SearchUseCase) {
        self.filter = filter
        self.useCase = useCase
    }

    public struct Input {
        let viewDidLoadTrigger: Driver<Void>
        let loadMoreTrigger: Driver<Void>
        let filterButtonTapTrigger: Driver<Void>
        let newFilterTrigger: PublishSubject<Filter>
    }
    
    public struct Output {
        let searchList: Driver<[Product]>
        let openFilter: Driver<Filter>
    }
    
    private var newFilterTrigger: PublishSubject<Filter>?
    
    public func transform(input: Input) -> Output {
        let currentProducts = BehaviorRelay(value: [Product]())
        var startPage = 0
        
        newFilterTrigger = input.newFilterTrigger
            
        let currNewFilterTrigger = newFilterTrigger?.asDriver(onErrorRecover: { (_) -> SharedSequence<DriverSharingStrategy, Filter> in
            return .empty()
        })
            .map({ _ in })
            .do(onNext: { _ in
                currentProducts.accept([Product]())
                startPage = 0
            }) ?? Driver<Void>.empty()
        
        let filterDriver = input.newFilterTrigger.startWith(self.filter).asDriver { (_) -> SharedSequence<DriverSharingStrategy, Filter> in
            return .empty()
        }
        let refreshDataTrigger = Driver.merge(input.loadMoreTrigger, input.viewDidLoadTrigger, currNewFilterTrigger)
        
        let response = refreshDataTrigger
            .withLatestFrom(filterDriver)
            .flatMapLatest({ (filter) -> Driver<SearchResponse> in
                return self.useCase
                    .requestSearch(filter: self.filter, start: startPage)
                    .asDriver(onErrorRecover: { (error) -> Driver<SearchResponse> in
                        return .empty()
                    })
            })
        
        let products = response.map { response -> [Product] in
            let products = response.products
            if products.count > 0 {
                let newProducts = currentProducts.value + products
                startPage += 10
                currentProducts.accept(newProducts)
            }
            return currentProducts.value
        }
        
        let openFilter = input.filterButtonTapTrigger
            .withLatestFrom(filterDriver) { (_, filter) -> Filter in
                return filter
        }
        
        return Output(searchList: products, openFilter: openFilter)
    }

}

extension SearchViewModel: FilterDelegate {
    func recvFilter(filter: Filter) {
        self.filter = filter
        newFilterTrigger?.onNext(filter)
    }
}

//class FilterVC {
//    var filterResult: Driver<Filter>
//    
//    func viewDidLoad() {
//        button.rx.tap.map {
//            // ....
//            return filterData
//        }
//    }
//}
//
//let vc = FilterVC()
//
//vc.filterResult.drive(onNext: {
//    
//})
//
//vc.onFilterSelected = { filter in
//    
//}
//
//func bindVIewModel() {
//    
//    let filterData = button.rx.tap.map {
//        let vc = FilterVC()
//        return vc.filterData
//    }
//    
//    let input = Input(filter: filterData)
//}
