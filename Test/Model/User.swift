//
//  User.swift
//  Test
//
//  Created by 李品毅 on 2023/2/16.
//

import Foundation

struct User: Codable, CustomStringConvertible {
    
    var description: String{
        let str = "nickName \(nickName)\n"
        + "imageUrl: \(imageUrl)\n"
        return str
    }
    
    private enum CodingKeys:String, CodingKey{
        case nickName, imageUrl
    }
    
    var nickName: String
    var imageUrl: String
}
