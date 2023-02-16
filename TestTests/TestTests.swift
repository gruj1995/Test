//
//  TestTests.swift
//  TestTests
//
//  Created by 李品毅 on 2023/2/16.
//

import Foundation
import OHHTTPStubs // 模擬網路請求
import Alamofire

import XCTest
@testable import Test

/*
XCTAssert(): 判斷是否為True
XCTAssertFalse(): 判斷是否為False
XCTAssertEqual(): 判斷是否相同
XCTAssertNotEqual(): 判斷是否不相同
XCTAssertEqualWithAccuracy(): 判斷浮點數是否相等
XCTAssertNil(): 判斷是否為空
XCTAssertNotNil(): 判斷是否不為空
XCTFail(): 無條件失敗
 */

final class TestTests: XCTestCase {

    override func setUpWithError() throws {
        super.setUp()
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }

    // MARK: - Test https://www.money.com.tw/a/version
    private func stubGetVersionCheck(updateMode: String, error: Error?){
        
        let API_CHECK_VERSION = "/a/version"
        
        stub(condition: isPath(API_CHECK_VERSION)) { (request) -> HTTPStubsResponse in
            if let _error = error {
                return HTTPStubsResponse(error: _error)
            }else{
                let obj = ["isNeedUpdate":updateMode, "statusCode" : 200] as [String : Any]
                return HTTPStubsResponse(jsonObject: obj, statusCode: 200, headers: ["Content-Type":"application/json"])
            }
        }
    }
    
    /// 測試無需版本更新
    func testGetVersionCheckUnhandler() {
        let currentTime = Date().timeIntervalSince1970
//        let oneWeekAgo = currentTime - WEEK_TIME_INTERVAL
//
//        Utils.setIntSet(Int(oneWeekAgo), key: LAST_CHECK_VERSION_UPDATE_TIMESTAMP)
        
        stubGetVersionCheck(updateMode: "0", error: nil)
        
        // 測試異步行為 (成功完成後傳送訊息)
        let requestExpectation = expectation(description: "不需更新")
        
//        VersionCheckHelper.versionCheck{ (level)  in
//            XCTAssertEqual(level, VersionCheckHelper.VersionCheckLevel.NotRequired)
//            requestExpectation.fulfill()
//        }
        // 搭配expectation
        wait(for: [requestExpectation], timeout: 1)
    }

}
