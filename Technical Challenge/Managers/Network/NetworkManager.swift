//
//  NetworkManager.swift
//  Technical Challenge
//
//  Created by Nataniel Martin on 12/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation
import WebLinking

// This protocol will allow to mock the network layer when unit test the project
protocol NetworkRessource {
    func fetchRepositories(url: URL, completionHandler: @escaping (PaginatedResponse<Repository>) -> (), failureHandler: @escaping FailureHandler) -> URLSessionDataTask
    func fetchRepositories(search: String, sorted: RepoSortType, order: RepoOrderType, completionHandler: @escaping (PaginatedResponse<Repository>) -> (), failureHandler: @escaping FailureHandler) -> URLSessionDataTask
}

public typealias FailureHandler = (TCError)->(Void)

struct NetworkManager {
    
    public static let `default` = NetworkManager()
    
    // MARK: Methods
    
    init() { }
    
    @discardableResult
    public func callRequest<T: Codable>(request: URLRequest, withSuccess success: @escaping (PaginatedResponse<T>)->Void, andFailure failure: @escaping FailureHandler) -> URLSessionDataTask {
        print("Start REQUEST")
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    let customError = TCError.error(error)
                    failure(customError)
                }
            } else {
                let decoder = JSONDecoder()
                if let data = data, let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.isStatusOK {
                        var decodedResponse = try! decoder.decode(PaginatedResponse<T>.self, from: data)
                        let nextLink = httpResponse.findLink(relation: "next")
                        let previousLink = httpResponse.findLink(relation: "prev")
                        decodedResponse.setLinks(previous: previousLink?.uri, next: nextLink?.uri)
                        DispatchQueue.main.async {
                            success(decodedResponse)
                        }
                    } else {
                        
                        DispatchQueue.main.async {
                            let error = TCError.message(title: "Error API", message: "\(httpResponse)")
                            failure(error)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        let error = TCError.message(title: "Error decoding", message: "Failed to decode object")
                        failure(error)
                    }
                }
            }
        }
        task.resume()
        return task
    }
}

extension NetworkManager : NetworkRessource {
    func fetchRepositories(url: URL, completionHandler: @escaping (PaginatedResponse<Repository>) -> (), failureHandler: @escaping FailureHandler) -> URLSessionDataTask {
        let request = URLRequest(url: url)
        return self.callRequest(request: request, withSuccess: completionHandler, andFailure: failureHandler)
    }
    
    func fetchRepositories(search: String, sorted: RepoSortType = .forks, order: RepoOrderType = .desc, completionHandler: @escaping (PaginatedResponse<Repository>) -> (), failureHandler: @escaping FailureHandler) -> URLSessionDataTask {
        let request = Router.searchRepositories(search: search, sortedType: sorted, order: order).asURLRequest()
        return self.callRequest(request: request, withSuccess: completionHandler, andFailure: failureHandler)
    }
}
