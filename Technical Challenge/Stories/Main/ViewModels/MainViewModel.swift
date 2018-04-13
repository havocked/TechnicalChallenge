//
//  MainViewModel.swift
//  Technical Challenge
//
//  Created by Nataniel Martin on 13/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation


enum MainEvent {
    case update
}

protocol MainViewModelDelegate: class {
    func mainViewModelDidStopRefreshing(viewModel: MainViewModel)
    func mainViewModel(viewModel: MainViewModel, didSend event: MainEvent)
}

final class MainViewModel {
    
    private var searchTask : DispatchWorkItem?
    private var currentQuery: URLSessionDataTask?
    private var lastResponse: PaginatedResponse<Repository>?
    
    public private(set) var loadedRepositories = [Repository]()
    public weak var delegate : MainViewModelDelegate?
    
    var totalRepositories : Int {
        get {
            return loadedRepositories.count
        }
    }
    
    func fetchNextRepositories(with filter: String) {
        
        currentQuery?.cancel()
        
        if let nextLink = lastResponse?.nextLinkURL {
            currentQuery = NetworkManager.default.fetchRepositories(url: nextLink, completionHandler: { (response : PaginatedResponse<Repository>) in
                self.lastResponse = response
                self.loadedRepositories.append(contentsOf: response.items)
                self.delegate?.mainViewModel(viewModel: self, didSend: .update)
                self.delegate?.mainViewModelDidStopRefreshing(viewModel: self)
            }, failureHandler: { error in
                print(error.message)
                self.delegate?.mainViewModelDidStopRefreshing(viewModel: self)
            })
        } else {
            currentQuery = NetworkManager.default.fetchRepositories(filter: filter, sorted: .forks, order: .desc, completionHandler: { (response : PaginatedResponse<Repository>) in
                self.lastResponse = response
                self.loadedRepositories = response.items
                self.delegate?.mainViewModel(viewModel: self, didSend: .update)
                self.delegate?.mainViewModelDidStopRefreshing(viewModel: self)
            }, failureHandler: { error in
                print(error.message)
                self.delegate?.mainViewModelDidStopRefreshing(viewModel: self)
            })
        }
    }
    
    func userDidTap(_ searchText: String) {
        print("Search action: [\(searchText)]")
        searchTask?.cancel()
        searchTask = DispatchWorkItem {
            print("Start request ! [\(searchText)]")
            self.lastResponse = nil
            self.fetchNextRepositories(with: searchText)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: searchTask!)
    }
    
    func repositoryCellModel(at indexPath: IndexPath) -> RepositoryCellModel {
        let repository = loadedRepositories[indexPath.row]
        let model = RepositoryCellModel(repository: repository)
        return model
    }
}
