//
//  Item.swift
//  Test
//
//  Created by 李品毅 on 2023/2/16.
//

import Foundation

struct Item: Codable, CustomStringConvertible {
    
    var description: String{
        let str = "user \(user.description)\n"
        + "tags: \(tags)\n"
        return str
    }
    
    private enum CodingKeys:String, CodingKey{
        case user, tags
    }
    
    var user: User
    var tags: [String]
}
