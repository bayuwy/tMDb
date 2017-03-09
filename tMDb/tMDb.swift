//
//  tMDb.swift
//  tMDb
//
//  Created by Nurul Rachmawati on 3/9/17.
//  Copyright © 2017 DyCode. All rights reserved.
//

import Foundation
import RxSwift
import Moya

let tMDbApiKey = "9548fa0910e2897f79dfdc19e0b2e9a0"

let provider = RxMoyaProvider<tMDb>()
let disposeBag = DisposeBag()

enum tMDb {
    case discover(Date, Int)
    case movieDetail(Int)
}

extension tMDb: TargetType {
    
    /// The target's base `URL`.
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String {
        switch self {
        case .discover:
            return "/discover/movie"
            
        case .movieDetail(let movieID):
            return "/movie/\(movieID)"
        }
    }
    
    /// The HTTP method used in the request.
    var method: Moya.Method {
        switch self {
        case .discover, .movieDetail:
            return .get
        }
    }
    
    /// The parameters to be incoded in the request.
    var parameters: [String: Any]? {
        var parameters: [String: Any] = ["api_key": tMDbApiKey]
        
        switch self {
        case .discover(let date, let page):
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            parameters["primary_release_date.gte"] = dateFormatter.string(from: date)
            parameters["page"] = page
            
        default:
            break
        }
        
        return parameters
    }
    
    /// The method used for parameter encoding.
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .discover, .movieDetail:
            return URLEncoding.default
        }
    }
    
    /// Provides stub data for use in testing.
    var sampleData: Data {
        switch self {
        case .discover, .movieDetail:
            return "".data(using: .utf8)!
        }
    }
    
    /// The type of HTTP task to be performed.
    var task: Task {
        switch self {
        case .discover, .movieDetail:
            return .request
        }
    }
    
    /// Whether or not to perform Alamofire validation. Defaults to `false`.
    var validate: Bool {
        return false
    }
}
