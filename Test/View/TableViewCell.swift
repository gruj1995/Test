//
//  TableViewCell.swift
//  Test
//
//  Created by 李品毅 on 2023/2/16.
//

import UIKit
import Kingfisher

class TableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var collectionView: ContentSizedCollectionView!
    

    class var reuseIdentifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        collectionView.isScrollEnabled = false
        
        let columnLayout = CustomViewFlowLayout()
        columnLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView.collectionViewLayout = columnLayout
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarImageView.layoutIfNeeded()
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
        avatarImageView.clipsToBounds = true
    }

    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        self.layoutIfNeeded()
    }

    func configuration(nickName: String, imageUrl: String) {
        titleLabel.text = nickName
        titleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        self.avatarImageView.kf.setImage(with: URL(string: imageUrl),  placeholder: UIImage(named: "Image_Avatar_Dark"))
    }
}
