//
//  AceTarget.swift
//  Onboarding Search Filter
//
//  Created by Dhio Etanasti on 08/10/18.
//

import Moya

internal enum AceTarget {
    case fetchSearchResult(filter: Filter, start: Int)
}

extension AceTarget: TargetType {
    var baseURL: URL {
        return URL(string: "https://ace.tokopedia.com")!
    }
    
    var path: String {
        switch self {
        case .fetchSearchResult:
            return "/search/v2.5/product"
        }
    }
    
    var method: Method {
        switch self {
        case .fetchSearchResult: return .get
        }
    }
    
    var sampleData: Data {
        return "{ \"data\": 123 }".data(using: .utf8)!
    }
    
    internal var parameters: [String: Any]? {
        switch self {
        case let .fetchSearchResult(filter, start):
            return [
                "q": filter.q,
                "pmin": filter.pmin,
                "pmax": filter.pmax,
                "wholesale": filter.wholesale,
                "official": filter.official,
                "fshop": filter.fshop,
                "start": start,
                "rows": filter.rows
            ]
        }
    }
    
    internal var parameterEncoding: ParameterEncoding {
        switch self {
        default: return URLEncoding.default
        }
    }
    
    var task: Task {
        return .requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
