//
//  DetailViewModel.swift
//  Technical Challenge
//
//  Created by Nataniel Martin on 15/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation

/// Events sended by the view model to viewController
enum DetailEvent {
    case update
    case insert(indexPaths: [IndexPath])
}

/// Loading status in the DetailViewModel
enum DetailStatus {
    case idle
    case fetchingNextPage
}

protocol DetailViewModelDelegate: class {
    func detailViewModel(viewModel: DetailViewModel, didChange status: DetailStatus)
    func detailViewModel(viewModel: DetailViewModel, didSend event: DetailEvent)
}

final class DetailViewModel {
    
    // MARK: Private Variables
    
    private var repository: Repository
    private var networkManager : NetworkRessource
    private var currentQuery: URLSessionDataTask?
    private var lastResponse: PaginatedResponse<[User]>?
    private var loadedUsersList = [User]()
    
    // MARK: Public Variables
    
    public weak var delegate : DetailViewModelDelegate?
    
    public private(set) var loadingStatus : DetailStatus = .idle {
        didSet {
            self.delegate?.detailViewModel(viewModel: self, didChange: loadingStatus)
        }
    }
    
    var totalSubscribers : String {
        get {
            let str = "DETAIL_TOTAL_WATCHERS"
                .localize(args: repository.totalWatchers)
                .capitalized
            return str
        }
    }
    
    var fetchedSubscribersCount : Int {
        get {
            return loadedUsersList.count
        }
    }
    
    var repoName : String {
        get {
            return repository.name
        }
    }
    
    // MARK: View model Methods
    
    init(repository: Repository, networkRessource: NetworkRessource = NetworkManager()) {
        self.repository = repository
        self.networkManager = networkRessource
    }
    
    deinit {
        currentQuery?.cancel()
    }
    
    func fetchNextSubscribers() {
        
        if currentQuery != nil {
            return
        }
        
        let nextLink = lastResponse?.nextLinkURL ?? repository.watchersURL
        
        currentQuery = networkManager.fetchSubscribers(url: nextLink, completionHandler: { response in
            self.lastResponse = response
            self.loadedUsersList.append(contentsOf: response.data)
            self.delegate?.detailViewModel(viewModel: self, didSend: .update)
            self.loadingStatus = .idle
            self.currentQuery = nil
        }, failureHandler: { error in
            print(error.message)
        })
    }
    
    func subscriberCellModel(for indexPath: IndexPath) -> SubscriberCellModel {
        let user = loadedUsersList[indexPath.row]
        let model = SubscriberCellModel(user: user)
        return model
    }
}
