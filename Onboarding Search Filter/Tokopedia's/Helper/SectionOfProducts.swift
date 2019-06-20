//
//  SectionOfProducts.swift
//  Onboarding Search Filter
//
//  Created by Abram Situmorang on 20/06/19.
//

import Foundation
import RxDataSources

struct SectionOfProducts {
    var items: [Item]
}

extension SectionOfProducts: SectionModelType {
    typealias Item = Product
    init(original: SectionOfProducts, items: [Item]) {
        self = original
        self.items = items
    }
}
