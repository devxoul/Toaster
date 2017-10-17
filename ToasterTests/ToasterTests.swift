//
//  ToasterTests.swift
//  ToasterTests
//
//  Created by Lois Di Qual on 10/16/17.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import XCTest

@testable import Toaster

class ToasterTests: XCTestCase {
    
    // Regression test for https://github.com/devxoul/Toaster/issues/111
    func testCurrentToastIsNilAfterCancelAll() {
        Toast(text: "text").show()
        ToastCenter.default.cancelAll()
        XCTAssertNil(ToastCenter.default.currentToast)
    }
    
    func testCurrentToastShouldIgnoreFinishedAndCancelledToasts() {
        
        let toast1 = Toast(text: "text1")
        toast1.show()
        XCTAssertEqual(ToastCenter.default.currentToast, toast1)

        toast1.cancel()
        XCTAssertNil(ToastCenter.default.currentToast)
        
        let toast2 = Toast(text: "text2", duration: 0.3)
        toast2.show()
        XCTAssertEqual(ToastCenter.default.currentToast, toast2)
        
        let expectation = self.expectation(description: "Toast 2 should finish")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            expectation.fulfill()
            XCTAssertTrue(toast2.isFinished)
        }
        wait(for: [expectation], timeout: 3)
        
        XCTAssertNil(ToastCenter.default.currentToast)
    }
    
}
