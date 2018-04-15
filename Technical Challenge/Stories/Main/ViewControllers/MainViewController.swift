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
        
        self.title = "Technical Challenge"
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        self.view.addSubview(activityIndicator)
        
        activityIndicator.bindWithCenterOfViewBounds(otherView: resultTableView)
        
        viewModel.delegate = self
        searchBar.delegate = self
        searchBar.placeholder = "Search a repository"
        
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.register(RepositoryCell.self)
        resultTableView.register(LoadingCell.self)
        resultTableView.keyboardDismissMode = .interactive
        
        // Removes empty cells
        resultTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Add refresh control to TableView
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        resultTableView.refreshControl = refreshControl
        
        registerKeyboardNotifications()
    }
    
    deinit {
        removeKeyboardNotifications()
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func animateWithKeyboard(_ notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        let moveUp = (notification.name == .UIKeyboardWillShow)
        
        if moveUp {
            resultTableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0)
        } else {
            resultTableView.contentInset = UIEdgeInsets.zero
        }
    }
    
    @objc private func refreshAction() {
        guard let searchText = searchBar.text else {
            return
        }
        viewModel.userDidRefresh(with: searchText)
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
            self.resultTableView.reloadSections([1], with: .automatic)
            self.resultTableView.endUpdates()
        }
    }
    
    func mainViewModel(viewModel: MainViewModel, didChange status: MainStatus) {
        switch status {
        case .idle:
            self.activityIndicator.stopAnimating()
            self.resultTableView.refreshControl?.endRefreshing()
        case .fetchingFirstPage:
            self.activityIndicator.startAnimating()
        case .refreshing:
            self.activityIndicator.stopAnimating()
        default:
            return
        }
    }
}

extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.totalRepositories
        } else {
            if viewModel.totalRepositories > 0 {
                return 1
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell : RepositoryCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            let model = viewModel.repositoryCellModel(at: indexPath)
            cell.configure(with: model)
            return cell
        } else {
            
            self.viewModel.fetchNextRepositories(with: searchBar.text)
            
            let loadingCell: LoadingCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            let model = viewModel.loadingCellModel()
            loadingCell.configure(with: model)
            return loadingCell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewModel = viewModel.userDidSelectCell(indexPath: indexPath)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : DetailViewController = storyboard.instantiateViewController(withIdentifier: "detailViewController") as! DetailViewController
        vc.viewModel = detailViewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
