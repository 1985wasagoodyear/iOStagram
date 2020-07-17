//
//  UIImageView+Utility.swift
//  Created 7/14/20
//  Using Swift 5.0
// 
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import UIKit

public extension UIImageView {
    func setImage(data: Data?, clearIfNil: Bool = false) {
        DispatchQueue.main.async {
            let image: UIImage?
            if let data = data {
                image = UIImage(data: data)
            } else {
                image = clearIfNil ? nil : self.image
            }
            self.image = image
        }
    }
    func setImage(image: UIImage?, clearIfNil: Bool = false) {
        DispatchQueue.main.async {
            self.image = image
        }
    }
}

public extension UIImage {
    func resized(for size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }.withRenderingMode(self.renderingMode)
    }
}
