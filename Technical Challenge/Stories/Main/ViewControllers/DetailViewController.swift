//
//  DetailViewController.swift
//  Technical Challenge
//
//  Created by Nataniel Martin on 15/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import UIKit

class DetailViewController : UIViewController {
    
    var viewModel : DetailViewModel!
    
    @IBOutlet weak var subscribersLabel: UILabel!
    @IBOutlet weak var subscriberCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = viewModel.repoName
        
        viewModel.delegate = self
        
        subscriberCollectionView.delegate = self
        subscriberCollectionView.dataSource = self
        subscriberCollectionView.register(SubscriberCell.self)
        
        subscribersLabel.bigTitle()
        subscribersLabel.text = viewModel.totalSubscribers
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchNextSubscribers()
    }
}

// MARK: DetailViewModel Delegates

extension DetailViewController : DetailViewModelDelegate {
    func detailViewModel(viewModel: DetailViewModel, didChange status: DetailStatus) {
        
        switch status {
        case .idle:
            break
        case .fetchingNextPage:
            break
        }
    }
    
    func detailViewModel(viewModel: DetailViewModel, didSend event: DetailEvent) {
        
        switch event {
        case .update:
            self.subscriberCollectionView.reloadData()
        case .insert(let indexPaths):
            self.subscriberCollectionView.performBatchUpdates({
                self.subscriberCollectionView.insertItems(at: indexPaths)
            }, completion: nil)
        }
    }
    
    func detailViewModel(viewModel: DetailViewModel, showError error: TCError) {
        
        let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ALERT_OK_ACTION_TITLE".localized, style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK : UICollectionViewDelegate

extension DetailViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.fetchedSubscribersCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let subscriberCell : SubscriberCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        let model = viewModel.subscriberCellModel(for: indexPath)
        subscriberCell.configure(with: model)
        return subscriberCell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row >= self.viewModel.fetchedSubscribersCount - 1 {
            self.viewModel.fetchNextSubscribers()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.pulse()
    }
}

//MARK: - CollectionView FlowLayout Delegate

extension DetailViewController : UICollectionViewDelegateFlowLayout {
    
    private struct Constants {
        static let minimumSpacing:CGFloat = 5
        static let collectionViewPaddingLeft: CGFloat = 5
        static let collectionViewPaddingRight: CGFloat = 5
        static let collectionViewPaddingTop: CGFloat = 5
        static let collectionViewPaddingBottom: CGFloat = 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let range : CGFloat = 4
        let cellWidth : CGFloat = (collectionView.frame.width - (Constants.minimumSpacing * (range - 1)) - (Constants.collectionViewPaddingLeft + Constants.collectionViewPaddingRight)) / range
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    //Spacing around the UICollectionView
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.collectionViewPaddingTop,
                            left: Constants.collectionViewPaddingLeft,
                            bottom: Constants.collectionViewPaddingBottom,
                            right: Constants.collectionViewPaddingRight)
    }
    
    //Spacing vertically between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.minimumSpacing
    }
    
    //Spacing horizontally between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.minimumSpacing
    }
}
