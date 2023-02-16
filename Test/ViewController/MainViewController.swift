//
//  MainViewController.swift
//  Test
//
//  Created by 李品毅 on 2023/2/16.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var countLabel: UILabel!
    
    private var viewModel: MainViewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countLabel.font = .systemFont(ofSize: 30, weight: .medium)
        countLabel.textColor = .white
        setTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.fetchItems {[weak self] isSuccess in
            guard let self = self else {return}
            self.countLabel.text = "totalCount: \(self.viewModel.sectionData.count)"
            self.tableView.reloadData()
        }
    }
    
    private func setTableView() {

        // 設定Cell的高度能自我適應
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorInset = .zero
        tableView.backgroundColor = UIColor(hex: "F0F0F0")
    }
}


extension MainViewController: UITableViewDataSource, UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sectionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier) as? TableViewCell else{
            return UITableViewCell()
        }
        guard let item = viewModel.item(forCellAt: indexPath.row) else {
            return cell
        }
        cell.configuration(nickName: item.user.nickName, imageUrl: item.user.imageUrl)
        cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
//        guard let tableViewCell = cell as? TableViewCell else { return }
//
//        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
//    }
}


extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let item = viewModel.item(forCellAt: collectionView.tag) else {
            return 0
        }
        collectionView.isHidden = item.tags.isEmpty
        return item.tags.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.reuseIdentifier, for: indexPath) as? TagCell else {
            return UICollectionViewCell()
        }
        guard let item = viewModel.item(forCellAt: collectionView.tag) else {
            return cell
        }
        cell.configuration(tag: item.tags[indexPath.item])
        return cell
    }
}
