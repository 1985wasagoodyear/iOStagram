//
//  ImageService.swift
//  Created 7/14/20
//  Using Swift 5.0
// 
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import Foundation
import CommonUtility
import UIKit

final public class ImageDownloadService {
    
    // MARK: - Properties
    
    var enqueued = SafeSet<String>()
    private let cache = NSCache<NSString, NSData>()
    private let session: URLSession
    
    // MARK: - Init
    
    public init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    // MARK: - Method
    
    public func downloadImage(_ url: URL,
                       _ completion: @escaping (Data?)->()) {
        let nsStr = NSString(string: url.absoluteString)
        if let nsDat = cache.object(forKey: nsStr) {
            completion(Data(referencing: nsDat))
            return
        }
        completion(nil)
        if enqueued.contains(url.absoluteString) {
            return
        }
        enqueued.insert(url.absoluteString)
        session.dataTask(with: url) { (data, _, _) in
            guard let dat = data else {
                completion(nil)
                return
            }
            self.cache.setObject(NSData(data: dat), forKey: nsStr)
            self.enqueued.remove(url.absoluteString)
            completion(dat)
        }.resume()
    }
}

extension ImageDownloadService {
    
    
    public func downloadImage(_ url: URL,
                              forSize size: CGSize,
                              _ completion: @escaping (UIImage?)->()) {
        let nsStr = NSString(string: url.absoluteString + "\(size.width)x\(size.height)")
        if let nsDat = cache.object(forKey: nsStr),
            let image = UIImage(data: Data(referencing: nsDat)) {
            completion(image)
            return
        }
        completion(nil)
        if enqueued.contains(url.absoluteString) {
            return
        }
        enqueued.insert(url.absoluteString)
        session.dataTask(with: url) { (data, _, _) in
            guard let dat = data,
                let image = UIImage(data: dat),
                let resizedImage = image.resized(for: size),
                let resizedData = resizedImage.pngData() else {
                    completion(nil)
                    return
            }
            self.cache.setObject(NSData(data: resizedData), forKey: nsStr)
            self.enqueued.remove(url.absoluteString)
            completion(resizedImage)
        }.resume()
    }
}
