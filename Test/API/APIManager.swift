//
//  APIManager.swift
//  Test
//
//  Created by 李品毅 on 2023/2/16.
//

import Foundation
import Alamofire
import SwiftyJSON


class APIManager : NSObject{
    static let shared = APIManager()

}

extension APIManager {
    
    func getItems(params:[String:String],  _ completion: @escaping (Result<[Item], NetworkError>) -> Void){
        let url = "https://raw.githubusercontent.com/winwiniosapp/interview/main/interview.json"
        
        WebApiManager.shared.get(url: url, params: nil) { (data) in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            var result: [Item] = []
            let json = JSON(data)
            
//            if let items = json["data"]["items"].array {
//                result = items.map({ json in
//                    return Item(user: User(nickName: json["user"]["nickName"].stringValue, imageUrl: json["user"]["imageUrl"].stringValue), tags: json["tags"].arrayValue.map({return $0.stringValue
//                    }))
//                })
//                completion(.success(result))
//            }
//            completion(.failure(.decodeError))
            do{
                let itemData = try json["data"]["items"].rawData()
                let items = try JSONDecoder().decode([Item].self, from: itemData)
                completion(.success(items))
            }catch{
                completion(.failure(.decodeError))
            }
 
        } fail: { (data, statusCode, error) in
            if let data = data{
                print(JSON(data).rawString()!)
            }
            completion(.failure(.failed(errorMessage: error?.localizedDescription ?? "")))
        }
    }
}
