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
    
    override func tearDown() {
        super.tearDown()
        ToastCenter.default.cancelAll()
    }
    
    // Regression test for https://github.com/devxoul/Toaster/issues/111
    func testCurrentToastIsNilAfterCancelAll() {
        Toast(text: "text").show()
        ToastCenter.default.cancelAll()
        XCTAssertNil(ToastCenter.default.currentToast)
    }
    
    func testCurrentToastShouldIgnoreFinishedAndCancelledToasts() {
        
        // Show Toast 1, make sure it's the current toast
        let toast1 = Toast(text: "text1")
        toast1.show()
        XCTAssertEqual(ToastCenter.default.currentToast, toast1)

        // Cancel Toast 1, make sure there's no current toast
        toast1.cancel()
        XCTAssertNil(ToastCenter.default.currentToast)
        
        // Show Toast 2, make sure it's the current toast
        let toast2 = Toast(text: "text2", duration: 0.3)
        toast2.show()
        XCTAssertEqual(ToastCenter.default.currentToast, toast2)
        
        // Wait for Toast 2 to finish
        let expectation = self.expectation(description: "Toast 2 should finish")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            expectation.fulfill()
            XCTAssertTrue(toast2.isFinished)
        }
        wait(for: [expectation], timeout: 3)
        
        // Make sure there's no current toast
        XCTAssertNil(ToastCenter.default.currentToast)
    }
    
    func testBasicToast() {
        
        XCTAssertEqual(ToastWindow.shared.subviews.count, 0)
        
        let toast = Toast(text: "text", duration: 0.5)
        toast.show()
        
        let appearExpectation = self.expectation(description: "Wait for toast to appear")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            appearExpectation.fulfill()
            
            XCTAssertEqual(ToastWindow.shared.subviews.count, 1)
            guard let toastView = ToastWindow.shared.subviews.first as? ToastView else {
                return XCTFail("Subview should be a ToastView")
            }
            
            XCTAssertEqual(toastView.text, "text")
        }
        wait(for: [appearExpectation], timeout: 1)
        
        let disappearExpectation = self.expectation(description: "Wait for toast to disappear")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            disappearExpectation.fulfill()
            XCTAssertEqual(ToastWindow.shared.subviews.count, 0)
        }
        wait(for: [disappearExpectation], timeout: 3)
    }
    
    func testToastWindowNotToBeKeyWindow() {
        let existingKeyWindow = UIWindow(frame: .zero)
        existingKeyWindow.makeKey()
        let toastWindow = ToastWindow(frame: .zero, mainWindow: existingKeyWindow)
        toastWindow.makeKey()
        XCTAssertTrue(existingKeyWindow.isKeyWindow)
        XCTAssertFalse(toastWindow.isKeyWindow)
    }
    
}
