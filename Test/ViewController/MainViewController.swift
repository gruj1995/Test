//
//  MainViewController.swift
//  Test
//
//  Created by 李品毅 on 2023/2/16.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: MainViewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchItems {[weak self] isSuccess in
            guard let self = self else {return}
            self.tableView.reloadData()
        }
    }
    
    private func setTableView() {

        // 設定Cell的高度能自我適應
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorInset = .init(top: 0, left: 15, bottom: 0, right: 15)
        tableView.backgroundColor = .lightGray
    }

}


// MARK: - Extension UITableViewDataSource
extension MainViewController: UITableViewDataSource{

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
        return cell
    }
}

// MARK: - Extension UITableViewDelegate
extension MainViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? TableViewCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let item = viewModel.item(forCellAt: collectionView.tag) else {
            return 0
        }
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
        print("__++ \(item.tags[indexPath.item])")
        return cell
    }
}