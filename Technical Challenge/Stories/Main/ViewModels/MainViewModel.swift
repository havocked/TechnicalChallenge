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
    case insert(indexPaths: [IndexPath])
}

enum MainStatus {
    case idle
    case refreshing
    case fetchingNextPage
}

protocol MainViewModelDelegate: class {
    func mainViewModel(viewModel: MainViewModel, didChange status: MainStatus)
    func mainViewModel(viewModel: MainViewModel, didSend event: MainEvent)
}

final class MainViewModel {
    
    private var searchTask : DispatchWorkItem?
    private var currentQuery: URLSessionDataTask?
    private var lastResponse: PaginatedResponse<Repository>?
    
    public private(set) var loadedRepositories = [Repository]()
    public private(set) var loadingStatus : MainStatus = .idle {
        didSet {
            self.delegate?.mainViewModel(viewModel: self, didChange: loadingStatus)
        }
    }
    
    public weak var delegate : MainViewModelDelegate?
    
    var totalRepositories : Int {
        get {
            return loadedRepositories.count
        }
    }
    
    func fetchNextRepositories(with filter: String) {
        
        currentQuery?.cancel()
        
        if let nextLink = lastResponse?.nextLinkURL {
            self.loadingStatus = .fetchingNextPage
            currentQuery = NetworkManager.default.fetchRepositories(url: nextLink, completionHandler: { (response : PaginatedResponse<Repository>) in
                self.lastResponse = response
                self.loadedRepositories.append(contentsOf: response.items)
                self.delegate?.mainViewModel(viewModel: self, didSend: .update)
                self.loadingStatus = .idle
            }, failureHandler: { error in
                print(error.message)
                self.loadingStatus = .idle
            })
        } else {
            self.loadedRepositories.removeAll()
            self.delegate?.mainViewModel(viewModel: self, didSend: .update)
            self.loadingStatus = .refreshing
            currentQuery = NetworkManager.default.fetchRepositories(filter: filter, sorted: .forks, order: .desc, completionHandler: { (response : PaginatedResponse<Repository>) in
                self.lastResponse = response
                self.loadedRepositories = response.items
                self.delegate?.mainViewModel(viewModel: self, didSend: .update)
                self.loadingStatus = .idle
            }, failureHandler: { error in
                print(error.message)
                self.loadingStatus = .idle
            })
        }
    }
    
    func userDidTap(_ searchText: String) {
        
        let checkSearchText = searchText.trimWhitespaces()
        if checkSearchText.count > 0 {
            print("Search action: [\(searchText)]")
            searchTask?.cancel()
            searchTask = DispatchWorkItem {
                print("Start request ! [\(searchText)]")
                self.lastResponse = nil
                self.fetchNextRepositories(with: searchText)
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: searchTask!)
        }
    }
    
    func repositoryCellModel(at indexPath: IndexPath) -> RepositoryCellModel {
        let repository = loadedRepositories[indexPath.row]
        let model = RepositoryCellModel(repository: repository)
        return model
    }
}
