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
        
        subscriberCollectionView.delegate = self
        subscriberCollectionView.dataSource = self
        subscriberCollectionView.register(SubscriberCell.self)
        
        subscribersLabel.bigTitle()
        subscribersLabel.text = viewModel.totalSubscribers
    }
}

// MARK : UICollectionViewDelegate

extension DetailViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var subscriberCell : SubscriberCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        
        return subscriberCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
    
    // Whenever the colectionView refreshes, this delegate will recalculate
    // cell size in order to always have number of cell == range value
    // horizontally and vertically
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let range : CGFloat = 8
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
