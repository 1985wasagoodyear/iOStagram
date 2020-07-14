//
//  UICollectionView+Utility.swift
//  Created 7/14/20
//  Using Swift 5.0
// 
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import UIKit

public extension UICollectionView {
    func dequeue<CellType: UICollectionViewCell>(reuseId: String,
                                                 for indexPath: IndexPath) -> CellType {
        guard let cell = dequeueReusableCell(withReuseIdentifier: reuseId,
                                             for: indexPath) as? CellType else {
                                                fatalError("Could not dequeue cell with reuseIdentifier: \(reuseId)")
        }
        return cell
    }
}
