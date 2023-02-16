//
//  ContentSizedCollectionView.swift
//  Test
//
//  Created by 李品毅 on 2023/2/16.
//

import UIKit

/// 自適應高度
final class ContentSizedCollectionView: UICollectionView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
