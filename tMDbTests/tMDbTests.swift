//
//  tMDbTests.swift
//  tMDbTests
//
//  Created by Nurul Rachmawati on 3/9/17.
//  Copyright © 2017 DyCode. All rights reserved.
//

import XCTest
@testable import tMDb
import Moya
import RxSwift
import EVReflection

class tMDbTests: XCTestCase {
    
    let testProvider = RxMoyaProvider<tMDb>(stubClosure: { (tMDb) -> StubBehavior in
        return StubBehavior.immediate
    })
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDiscoverMovie() {
        
        let e = expectation(description: "testDiscoverMovie")
        
        testProvider.request(.discoverMovie(Date(), 1))
            .map(to: DiscoverResponse.self)
            .subscribe { event in
                switch event {
                case .next(let response):
                    XCTAssert(response.page == 1)
                    XCTAssert(response.totalResults == 1541)
                    XCTAssert(response.totalPages == 78)
                    XCTAssert(response.results.count == 20)
                    
                case .error(let error):
                    XCTFail(error.localizedDescription)
                    
                case .completed:
                    e.fulfill()
                }
            }
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 3) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
}
