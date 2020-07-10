//
//  GalleryViewController.swift
//  Created 7/10/20
//  Using Swift 5.0
// 
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import UIKit

final class GalleryViewController: UIViewController {
    
    @IBOutlet var optionSegmentedControl: UISegmentedControl!
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            guard let collectionView = collectionView else { return }
            collectionView.dataSource = self
        }
    }
    
    var items: [Any] = []
    var currentOption: SegmentOptions = .mine
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    @IBAction func optionSegmentedControlAction(_ sender: UISegmentedControl) {
        guard let selection = SegmentOptions(rawValue: sender.selectedSegmentIndex),
            selection != currentOption else {
            return
        }
        currentOption = selection
        fetchData()
    }
    
    func fetchData() {
        // fetch data for the option
    }
    
}

extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCollectionViewCell = collectionView.dequeue(reuseId: Constants.cellReuseId,
                                                                   for: indexPath)
        
        return cell
    }
    
}

extension GalleryViewController {
    enum Constants {
        static let cellReuseId = "ImageCollectionViewCell"
    }
    
    enum SegmentOptions: Int {
        case mine = 0
        case enhanceIT
    }
    
}

extension UICollectionView {
    func dequeue<CellType: UICollectionViewCell>(reuseId: String,
                                                 for indexPath: IndexPath) -> CellType {
        guard let cell = dequeueReusableCell(withReuseIdentifier: reuseId,
                                             for: indexPath) as? CellType else {
            fatalError("Could not dequeue cell with reuseIdentifier: \(reuseId)")
        }
        return cell
    }
}
