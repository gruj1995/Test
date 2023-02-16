//
//  CollectionCellAutoLayout.swift
//  Test
//
//  Created by 李品毅 on 2023/2/16.
//

import UIKit

public protocol CollectionCellAutoLayout: AnyObject {
    var cachedSize: CGSize? { get set }
}

public extension CollectionCellAutoLayout where Self: UICollectionViewCell {

    func preferredLayoutAttributes(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        newFrame.size.width = CGFloat(ceilf(Float(size.width)))
        layoutAttributes.frame = newFrame
        cachedSize = newFrame.size
        return layoutAttributes
    }
}
