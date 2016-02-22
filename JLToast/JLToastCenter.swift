/*
 * JLToastCenter.swift
 *
 *            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
 *                    Version 2, December 2004
 *
 * Copyright (C) 2013-2015 Su Yeol Jeon
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

protocol JLToastDelegate: class {
    func getTotalCount() -> Int
}

@objc public class JLToastCenter: NSObject, JLToastDelegate {

    private var _queue: NSOperationQueue!

    private struct Singletone {
        static let defaultCenter = JLToastCenter()
    }
    
    public class func defaultCenter() -> JLToastCenter {
        return Singletone.defaultCenter
    }
    
    override init() {
        self._queue = NSOperationQueue()
        self._queue.maxConcurrentOperationCount = 20
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "deviceOrientationDidChange:",
            name: UIDeviceOrientationDidChangeNotification,
            object: nil
        )
    }

    public func getTotalCount() -> Int {
        return self._queue.operationCount
    }

    public func addToast(toast: JLToast) {
        toast.view.delegate = self
        self._queue.addOperation(toast)
    }
    
    func deviceOrientationDidChange(sender: AnyObject?) {
        if self._queue.operations.count > 0 {
            let lastToast: JLToast = _queue.operations[0] as! JLToast
            lastToast.view.updateView()
        }
    }
}
