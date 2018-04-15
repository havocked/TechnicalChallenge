//
//  NetworkMockTest.swift
//  Technical Challenge
//
//  Created by Nataniel Martin on 12/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import UIKit

struct NetworkMockTest : NetworkRessource {
    func fetchRepositories(url: URL, completionHandler: @escaping (PaginatedResponse<Repository>) -> (), failureHandler: @escaping FailureHandler) -> URLSessionDataTask {
        
        
        return URLSessionDataTask()
    }
    
    func fetchRepositories(search: String, sorted: RepoSortType, order: RepoOrderType, completionHandler: @escaping (PaginatedResponse<Repository>) -> (), failureHandler: @escaping FailureHandler) -> URLSessionDataTask {
        
        let bundle = Bundle.main
        
        guard let url = bundle.url(forResource: "repositories", withExtension: "json") else {
            fatalError("Missing repositories.json")
        }
        
        let jsonData = try! Data(contentsOf: url)
        let response : PaginatedResponse<Repository> = try! JSONDecoder().decode(PaginatedResponse<Repository>.self, from: jsonData)
        
        completionHandler(response)
        
        return URLSessionDataTask()
    }
}
