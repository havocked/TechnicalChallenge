//
//  Router.swift
//  Technical Challenge
//
//  Created by Nataniel Martin on 12/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation

enum HTTPMethod : String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

enum RepoSortType : String {
    case stars
    case forks
    case updated
}

enum RepoOrderType : String {
    case asc
    case desc
}

enum Router {
    
    static let baseURLString = Bundle.main.infoDictionary!["Github_base_url"] as! String
    
    case searchRepositories(search: String, sortedType: RepoSortType, order: RepoOrderType)
    
    var method : HTTPMethod {
        switch self {
        case .searchRepositories:
            return .get
        }
    }
    
    var path : String {
        switch self {
        case .searchRepositories:
            return "/search/repositories"
        }
    }
    
    fileprivate var requestHeaders: [String:String] {
        var headers = [String:String]()
        
        switch self {
        case .searchRepositories:
            headers["Content-Type"] = "application/json"
        }
        
        return headers
    }
    
    fileprivate var queryItems: [URLQueryItem] {
        switch self {
        case .searchRepositories(let filter, let sorted, let order):
            
            let filterQuery = URLQueryItem(name: "q", value: filter)
            let sortedQuery = URLQueryItem(name: "sort", value: sorted.rawValue)
            let orderQuery = URLQueryItem(name: "order", value: order.rawValue)
            
            return [filterQuery, sortedQuery, orderQuery]
        }
    }

    func asURLRequest() -> URLRequest {
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = Router.baseURLString
        urlComponent.path = path
        urlComponent.queryItems = queryItems
        
        guard let url = urlComponent.url else {
            fatalError("Url components is wrongly created!")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = requestHeaders
        
        return request
    }
}
