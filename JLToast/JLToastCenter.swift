/*
 * JLToastCenter.swift
 *
 *            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
 *                    Version 2, December 2004
 *
 * Copyright (C) 2013-2014 Su Yeol Jeon
 *
 * Everyone is permitted to copy and distribute verbatim or modified
 * copies of this license document, and changing it is allowed as long
 * as the name is changed.
 *
 *            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
 *   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
 *
 *  0. You just DO WHAT THE FUCK YOU WANT TO.
 *
 */

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
