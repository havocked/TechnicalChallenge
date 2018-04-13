//
//  MasterViewController.swift
//  Technical Challenge
//
//  Created by Nataniel Martin on 12/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var viewModel = MainViewModel()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        searchBar.delegate = self
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.register(RepositoryCell.self)
        
        // Add refresh control to TableView
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        resultTableView.refreshControl = refreshControl
    }
    
    @objc private func refreshAction() {
        guard let searchText = searchBar.text else {
            return
        }
        viewModel.userDidTap(searchText)
    }
}

extension MainViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.userDidTap(searchText)
    }
}

extension MainViewController : MainViewModelDelegate {
    func mainViewModel(viewModel: MainViewModel, didSend event: MainEvent) {
        switch event {
        case .update:
            self.resultTableView.reloadData()
        }
    }
    
    func mainViewModelDidStopRefreshing(viewModel: MainViewModel) {
        resultTableView.refreshControl?.endRefreshing()
    }
}

extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalRepositories
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : RepositoryCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let model = viewModel.repositoryCellModel(at: indexPath)
        cell.configure(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = viewModel.loadedRepositories[indexPath.row]
        print("Did touch repo : \(repository.fullName)")
    }
}
