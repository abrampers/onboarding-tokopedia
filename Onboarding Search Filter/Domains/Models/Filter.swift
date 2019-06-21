//
//  Filter.swift
//  Onboarding Search Filter
//
//  Created by Dhio Etanasti on 07/10/18.
//

import Foundation

public struct Filter {
    var q: String
    var pmin: Int
    var pmax: Int
    var wholesale: Bool
    var official: Bool
    var fshop: Int
    var rows: Int
    
    init(q: String = "Samsung", pmin: Int = 0, pmax: Int = 0, wholesale: Bool = false, official: Bool = false, fshop: Int = 0, rows: Int = 10) {
        self.q = q
        self.pmin = pmin
        self.pmax = pmax
        self.wholesale = wholesale
        self.official = official
        self.fshop = fshop
        self.rows = rows
    }
}
