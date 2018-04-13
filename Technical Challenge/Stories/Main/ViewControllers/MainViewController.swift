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
    
    private var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        self.view.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let centerXContraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: resultTableView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let centerYConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: resultTableView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        view.addConstraints([centerXContraint, centerYConstraint])
        
        viewModel.delegate = self
        searchBar.delegate = self
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.register(RepositoryCell.self)
        
        // Removes empty cells
        resultTableView.tableFooterView = UIView(frame: CGRect.zero)
        
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
        case .insert(let indexPaths):
            self.resultTableView.beginUpdates()
            self.resultTableView.insertRows(at: indexPaths, with: .automatic)
            self.resultTableView.endUpdates()
        }
    }
    
    func mainViewModel(viewModel: MainViewModel, didChange status: MainStatus) {
        switch status {
        case .idle:
            self.activityIndicator.stopAnimating()
            self.resultTableView.refreshControl?.endRefreshing()
        case .refreshing:
            self.activityIndicator.startAnimating()
        default:
            break
        }
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
