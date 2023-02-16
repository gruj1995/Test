//
//  MainViewModel.swift
//  Test
//
//  Created by 李品毅 on 2023/2/16.
//

import Foundation

class MainViewModel {
    
    private(set) var sectionData = [Item]()

    init() {}
    
    func item(forCellAt row: Int) -> Item? {
        guard row < sectionData.count else { return nil}
        return sectionData[row]
    }

    func fetchItems(_ completion: @escaping (Bool) -> Void) {

        APIManager.shared.getItems(params: [:]) { result in
            switch result {
            case .success(let items):
                self.sectionData = items
                completion(true)
            case .failure(let error):
                print("\(error.errorDescription)")
                completion(false)
            }
        }
    }
}

