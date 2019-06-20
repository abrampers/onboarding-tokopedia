//
//  UIScrollView+Rx.swift
//  Onboarding Search Filter
//
//  Created by Abram Situmorang on 20/06/19.
//

import RxCocoa
import RxSwift
import UIKit

extension UIScrollView {
    public var rxReachedBottom: Observable<Void> {
        return rx.contentOffset
            .debounce(0.025, scheduler: MainScheduler.instance)
            .flatMap { [weak self] contentOffset -> Observable<Void> in
                guard let scrollView = self else {
                    return Observable.empty()
                }
                
                let visibleHeight = scrollView.frame.height - scrollView.contentInset.top - scrollView.contentInset.bottom
                let yPosition = contentOffset.y + scrollView.contentInset.top
                let threshold = max(0.0, scrollView.contentSize.height - (2.5 * visibleHeight))
                
                return yPosition > threshold ? Observable.just(()) : Observable.empty()
        }
        
    }
    
    public var rxReachBottomNode: Driver<Void> {
        let contentOffsetDriver = self.rx.observe(CGPoint.self, "contentOffset")
            .asDriver(onErrorDriveWith: Driver.empty())
        
        return contentOffsetDriver
            .filter({ [weak self] _ -> Bool in
                return self?.scrollIsAtBottom() ?? false
            })
            .map { _ in }
            .asDriver(onErrorDriveWith: Driver.empty())
    }
    
    public var rxReachedEnd: Observable<Void> {
        return rx.contentOffset
            .debounce(0.025, scheduler: MainScheduler.instance)
            .flatMap { [weak self] contentOffset -> Observable<Void> in
                guard let scrollView = self else {
                    return Observable.empty()
                }
                
                let visibleWidth = scrollView.frame.width - scrollView.contentInset.left - scrollView.contentInset.right
                let xPosition = contentOffset.x + scrollView.contentInset.left + visibleWidth // do the task, 1 item before last item
                let threshold = max(0.0, scrollView.contentSize.width - visibleWidth)
                
                return xPosition > threshold ? Observable.just(()) : Observable.empty()
        }
    }
}
