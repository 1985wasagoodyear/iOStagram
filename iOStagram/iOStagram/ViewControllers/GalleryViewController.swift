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
import CommonUtility
import InstagramBD

final class GalleryViewController: UIViewController {
    
    @IBOutlet var optionSegmentedControl: UISegmentedControl!
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            guard let collectionView = collectionView else { return }
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    var cellSize: CGSize {
        let width = ((collectionView.frame.size.width - (Constants.margin * 4.0)) / CGFloat(Constants.itemsPerRow)).rounded()
        return CGSize(width: width, height: width)
    }
    
    var items: [URL] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    var currentOption: SegmentOptions = .mine
    var user: InstaUser!
    var imageService = ImageDownloadService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchName()
        fetchMedia()
    }
    
    @IBAction func optionSegmentedControlAction(_ sender: UISegmentedControl) {
        guard let selection = SegmentOptions(rawValue: sender.selectedSegmentIndex),
            selection != currentOption else {
            return
        }
        currentOption = selection
        items.removeAll(keepingCapacity: true)
        if selection == .enhanceIT {
            fetchData()
        } else {
            fetchMedia()
        }
    }
    
    // MARK: TODO - adjust fetch data functionality here...
    func fetchData() {
        let url = URL(string: "https://www.instagram.com/enhanceitcommunity/")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print(response ?? error ?? "help")
                return;
            }
            guard let string = String(data: data, encoding: .utf8) else {
                print(response ?? error ?? "help")
                return
            }
            let links = Crawler.findLinks(from: string)
            self.items = links.filter { $0.absoluteString.contains("s150x150") }
        }.resume()
    }
    
    func fetchName() {
        user.getName { name in
            DispatchQueue.main.async {
                let title = name ?? "Mine"
                self.title = title
                self.optionSegmentedControl.setTitle(title, forSegmentAt: 0)
            }
        }
    }
    
    func fetchMedia() {
        user.getMedia { medias in
            self.items = medias
                .ofType(type: .image)
                .compactMap { $0.url }
        }
    }
    
}

extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCollectionViewCell = collectionView.dequeue(reuseId: Constants.cellReuseId,
                                                                   for: indexPath)
        imageService.downloadImage(items[indexPath.row], forSize: cellSize) { (image) in
            cell.imageView.setImage(image: image, clearIfNil: true)
        }
        return cell
    }
    
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.margin
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return Constants.margin
    }

}

extension GalleryViewController {
    enum Constants {
        static let cellReuseId = "ImageCollectionViewCell"
        static let margin: CGFloat = 3.0
        static let itemsPerRow: Int = 3
    }
    
    enum SegmentOptions: Int {
        case mine = 0
        case enhanceIT
    }
    
}

