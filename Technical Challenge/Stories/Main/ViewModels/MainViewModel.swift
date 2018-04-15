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
    case fetchingFirstPage
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
    private var networkManager : NetworkRessource
    
    private var loadedRepositories = [Repository]()
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
    
    init(networkRessource: NetworkRessource = NetworkManager()) {
//        // Use Mock response when UI testing
//        if let _ = ProcessInfo.processInfo.environment["-ShouldMockResponse"] {
//            networkManager = NetworkMockTest()
//        }
        networkManager = networkRessource
    }
    
    func verifySearchText(str: String?) -> String? {
        guard let checkSearchText = str?.trimWhitespaces() else {
            return nil
        }
        if checkSearchText.count > 0 {
            return checkSearchText
        }
        
        return nil
    }
    
    func fetchNextRepositories(with searchText: String?) {
        
        guard let str = verifySearchText(str: searchText) else {
            return
        }
        
        if let nextLink = lastResponse?.nextLinkURL {
            
            if self.loadingStatus != .fetchingNextPage {
                self.loadingStatus = .fetchingNextPage
                currentQuery = networkManager.fetchRepositories(url: nextLink, completionHandler: { (response : PaginatedResponse<Repository>) in
                    self.lastResponse = response
                    self.loadedRepositories.append(contentsOf: response.items)
                    self.delegate?.mainViewModel(viewModel: self, didSend: .update)
                    self.loadingStatus = .idle
                }, failureHandler: { error in
                    print(error.message)
                    self.loadingStatus = .idle
                })
            }
        } else {
            self.loadingStatus = .fetchingFirstPage
            currentQuery = networkManager.fetchRepositories(search: str, sorted: .forks, order: .desc, completionHandler: { (response : PaginatedResponse<Repository>) in
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
    
    func userDidRefresh(with searchText: String?) {
        
        guard let str = verifySearchText(str: searchText) else {
            self.loadingStatus = .idle
            return
        }
        
        currentQuery?.cancel()
        
        self.loadingStatus = .refreshing
        currentQuery = networkManager.fetchRepositories(search: str, sorted: .forks, order: .desc, completionHandler: { (response : PaginatedResponse<Repository>) in
            self.lastResponse = response
            self.loadedRepositories = response.items
            self.delegate?.mainViewModel(viewModel: self, didSend: .update)
            self.loadingStatus = .idle
        }, failureHandler: { error in
            print(error.message)
            self.loadingStatus = .idle
        })
    }
    
    func userDidTap(_ searchText: String?) {
        searchTask?.cancel()
        searchTask = DispatchWorkItem {
            self.lastResponse = nil
            self.loadedRepositories.removeAll()
            self.delegate?.mainViewModel(viewModel: self, didSend: .update)
            self.fetchNextRepositories(with: searchText)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: searchTask!)
    }
    
    func userDidSelectCell(indexPath: IndexPath) -> DetailViewModel {
        let repository = self.loadedRepositories[indexPath.row]
        let model = DetailViewModel(repository: repository)
        return model
    }
    
    func repositoryCellModel(at indexPath: IndexPath) -> RepositoryCellModel {
        let repository = loadedRepositories[indexPath.row]
        let model = RepositoryCellModel(repository: repository)
        return model
    }
    
    func loadingCellModel() -> LoadingCellModel {
        let model = LoadingCellModel(loadingStatus: self.loadingStatus)
        return model
    }
}
