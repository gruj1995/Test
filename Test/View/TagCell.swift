//
//  ItemCell.swift
//  Test
//
//  Created by 李品毅 on 2023/2/16.
//

import UIKit

class TagCell: UICollectionViewCell {
    
    @IBOutlet weak var tagLabel: UILabel!
    
    class var reuseIdentifier: String {
        return String(describing: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        layer.cornerRadius = 5
    }
    
    func configuration(tag: String) {
        tagLabel.text = tag
        tagLabel.font = .systemFont(ofSize: 16, weight: .regular)
        tagLabel.textColor = .orange
        self.backgroundColor = UIColor(hex: "FBECDA")
    }
}
