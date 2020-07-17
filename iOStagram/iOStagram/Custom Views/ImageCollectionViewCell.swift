//
//  ImageCollectionViewCell.swift
//  Created 7/10/20
//  Using Swift 5.0
// 
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import UIKit
import CommonUtility

class ImageCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addImageView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addImageView()
    }
    
    private func addImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.fillIn(contentView)
    }
}
