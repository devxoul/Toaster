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
    
    // Regression test https://github.com/devxoul/Toaster/issues/107
    func testFinishDoesNothingIfNotExecuting() {
        
        let toast = Toast(text: "text")
        toast.show()
        toast.finish()
        XCTAssertFalse(toast.isExecuting)
        XCTAssertFalse(toast.isCancelled)
        XCTAssertFalse(toast.isFinished)
    }
    
    func testCurrentToastShouldIgnoreFinishedAndCancelledToasts() {
        
        let toast1 = Toast(text: "text1")
        toast1.show()
        toast1.cancel()
        
        let toast2 = Toast(text: "text2")
        toast2.show()
        toast2.finish()
        
        XCTAssertNil(ToastCenter.default.currentToast)
    }
    
}
