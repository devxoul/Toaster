//
//  JLToastCenter.swift
//  JLToastSample
//
//  Created by 전수열 on 6/3/14.
//  Copyright (c) 2014 Joyfl. All rights reserved.
//

import UIKit

class JLToastCenter: NSObject {

    var _queue = NSOperationQueue()

    struct SingleInstance {
        static let defaultCenter: JLToastCenter = {
            let center = JLToastCenter()
            NSNotificationCenter.defaultCenter().addObserver(center,
                selector: "deviceOrientationDidChange:",
                name: UIDeviceOrientationDidChangeNotification,
                object: nil)
            return center
        }()
    }

    class func defaultCenter() -> JLToastCenter {
        return SingleInstance.defaultCenter
    }

    init() {
        _queue.maxConcurrentOperationCount = 1
    }

    func addToast(toast: JLToast) {
        _queue.addOperation(toast)
    }

    func deviceOrientationDidChange(sender: AnyObject?) {
        if _queue.operations.count > 0 {
            let lastToast: JLToast = _queue.operations[0] as JLToast
            lastToast._view!.updateView()
        }
    }
}
