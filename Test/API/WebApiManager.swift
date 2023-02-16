//
//  WebApiHelper.swift
//  Test
//
//  Created by 李品毅 on 2023/2/16.
//

import Foundation
import Alamofire
import SwiftyJSON

/// 回應正確
typealias ResponseSuccess = (_ data: Data?) -> Void

/// 回應失敗
typealias ResponseFail = (_ data : Data?, _ code: Int?, _ error : AFError?) -> Void

class WebApiManager{
    final class MoneyRequestInterceptor: Alamofire.RequestInterceptor{
        func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
            var urlRequest = urlRequest
//            if urlRequest.url?.absoluteString.hasPrefix(MONEY_URL) == true && urlRequest.url?.path != MONEY_API_LOGIN {
//                urlRequest.setValue("Bearer \(UserInfoTaker.sharedInstance.load().accessToken ?? "")", forHTTPHeaderField: "X-MONEY")
//
//            }
            completion(.success(urlRequest))
        }
    }
    
    static let shared = WebApiManager()
    
    private var alamofireManager : Alamofire.Session!
    
    private init(){
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20 // 連線逾時上限(秒)
        alamofireManager = Alamofire.Session(configuration: configuration, eventMonitors: [ApiLogger()])
    }
    
    func get(url:String, params:Dictionary<String,Any>?, success:@escaping ResponseSuccess, fail:@escaping ResponseFail){
        request(url: url, method: .get, params: params, success: success, fail: fail)
    }
    
    func post(url:String, params:Dictionary<String,Any>?, success:@escaping ResponseSuccess, fail:@escaping ResponseFail){
        request(url: url, method: .post, params: params, success: success, fail: fail)
    }

    func put(url:String, params:Dictionary<String,Any>?, success:@escaping ResponseSuccess, fail:@escaping ResponseFail){
        request(url: url, method: .put, params: params, success: success, fail: fail)
    }
    
    func upload(url:String, params:Dictionary<String,String> = [:], fileURL: URL, withName name: String, fileName: String, progressHandler:@escaping (Progress) -> Void, success:@escaping ResponseSuccess, fail:@escaping ResponseFail){
        let interceptor = MoneyRequestInterceptor()
        alamofireManager.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(fileURL, withName: name, fileName: fileName, mimeType: "application/octet-stream")
            for (key, value) in params {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
            }
        }, to: url, interceptor: interceptor).uploadProgress(closure: progressHandler)
            .validate(statusCode: 200 ..< 300)
//            .responseJSON { (response) in
            .responseData { (response) in
            switch response.result {
            case .success:
                success(response.data)
                break
            case .failure:
                fail(response.data, response.response?.statusCode, response.error)
                break
            }
        }
    }
    
    func download(url:String, params:Dictionary<String,String> = [:], downloadDestination: @escaping DownloadRequest.Destination, progressHandler:@escaping (Progress) -> Void, success:@escaping ResponseSuccess, fail:@escaping ResponseFail){
        let interceptor = MoneyRequestInterceptor()
        alamofireManager.download(url, method: .get, parameters: params, encoding: URLEncoding.default, interceptor: interceptor, to: downloadDestination)
            .downloadProgress(closure: progressHandler)
            .validate(statusCode: 200 ..< 400)
            .responseData { (response) in
            switch response.result {
            case .success:
                success(response.resumeData)
                break
            case .failure:
                fail(response.resumeData, response.response?.statusCode, response.error)
                break
            }
        }
    }
    
    private func request(url:String, method:HTTPMethod, params:Dictionary<String,Any>?, success:@escaping ResponseSuccess, fail:@escaping ResponseFail){
        let interceptor = MoneyRequestInterceptor()
        alamofireManager.request(url, method: method, parameters: params, encoding: URLEncoding.default, interceptor: interceptor)
            .validate(statusCode: 200 ..< 400)
            .responseJSON { (response) in
            switch response.result {
            case .success:
                success(response.data)
                break
            case .failure:
                fail(response.data, response.response?.statusCode, response.error)
                break
            }
        }
    }
}

class ApiLogger: EventMonitor{
    let queue = DispatchQueue(label: "com.pinyi.Test")
    
    func requestDidFinish(_ request: Request) {
        print("\(request.description)")
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        guard let data = response.data else {
            return
        }
        if let json = try? JSONSerialization
          .jsonObject(with: data, options: .mutableContainers){
            print("\(json)")
        }
    }
}
