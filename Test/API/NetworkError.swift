//
//  NetworkError.swift
//  Test
//
//  Created by 李品毅 on 2023/2/16.
//

import Foundation

/// API錯誤
enum NetworkError: LocalizedError, Equatable {
    case failed(errorMessage: String)
    case noData
    case notConnectedToInternet
    case timedOut
    case otherError
    case decodeError
    
    var errorDescription: String{
        switch self {
        case .failed(let errorMessage):
            return errorMessage
        case .noData:
            return ""
        case .notConnectedToInternet:
            return "請檢查網路連線"
        case .timedOut:
            return "連線逾時，請稍後再試"
        case .otherError:
            return "系統異常，請稍後再試"
        case .decodeError:
            return "Decode JSON失敗"
        }
    }
}
