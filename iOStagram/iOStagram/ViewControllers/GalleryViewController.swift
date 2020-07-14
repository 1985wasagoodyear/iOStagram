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
        }
    }
    
    var items: [URL] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var currentOption: SegmentOptions = .mine
    var user: InstaUser!
    var imageService = ImageDownloadService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // fetchData()
        fetchName()
    }
    
    @IBAction func optionSegmentedControlAction(_ sender: UISegmentedControl) {
        guard let selection = SegmentOptions(rawValue: sender.selectedSegmentIndex),
            selection != currentOption else {
            return
        }
        currentOption = selection
        //fetchData()
    }
    
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
            DispatchQueue.main.async {
                self.items = links.filter { $0.absoluteString.contains("s150x150") }
            }
        }.resume()
    }
    
    func fetchName() {
        // fetch data for the option
        user.getName { name in
            DispatchQueue.main.async {
                self.title = name
                self.optionSegmentedControl.setTitle(name, forSegmentAt: 0)
            }
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
        imageService.downloadImage(items[indexPath.row]) { (data) in
            DispatchQueue.main.async {
                guard let data = data else {
                    cell.imageView.image = nil
                    return
                }
                let image = UIImage(data: data)
                cell.imageView.image = image
            }
        }
        
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

