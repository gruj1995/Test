//
//  CustomViewFlowLayout.swift
//  Test
//
//  Created by 李品毅 on 2023/2/16.
//

import UIKit

class CustomViewFlowLayout: UICollectionViewFlowLayout {
    /// collectionView cell 上下間距
    let lineSpace: CGFloat = 10
    /// collectionView cell 左右間距
    let itemSpace: CGFloat = 10

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        self.minimumLineSpacing = lineSpace
        self.sectionInset = .zero
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + itemSpace
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        return attributes
    }
}
