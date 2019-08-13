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

let MAX_CONCURRENT_TOASTS: Int = 10

protocol JLToastDelegate: class {
    func getTotalCount() -> Int
}

@objc public class JLToastCenter: NSObject, JLToastDelegate {

    private var _queue: OperationQueue!

    private struct Singletone {
        static let defaultCenter = JLToastCenter()
    }
    
    public class func defaultCenter() -> JLToastCenter {
        return Singletone.defaultCenter
    }
    
    override init() {
        super.init()
        self._queue = OperationQueue()
        self._queue.maxConcurrentOperationCount = MAX_CONCURRENT_TOASTS
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(JLToastCenter.deviceOrientationDidChange(_:)),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }

    // MARK: - Delegate

    public func getTotalCount() -> Int {
        return self._queue.operationCount
    }

    // MARK: -

    public func addToast(_ toast: JLToast) {
        toast.view.delegate = self
        if let topY = JLToast.topY {
            if self._queue.operationCount == 0 || self._queue.operationCount >= MAX_CONCURRENT_TOASTS || topY <= CGFloat(0) {
                JLToast.topY = nil
            }
        }

        self._queue.addOperation(toast)
    }

    @objc func deviceOrientationDidChange(_ sender: AnyObject?) {
        if self._queue.operations.count > 0 && self._queue.operations.count <= self._queue.maxConcurrentOperationCount {
            for toast in self._queue.operations {
                let thisToast: JLToast = toast as! JLToast
                JLToast.updateView(thisToast.view)
            }
        } else if self._queue.operations.count > self._queue.maxConcurrentOperationCount {
            for index in 0..<self._queue.maxConcurrentOperationCount {
                let thisToast: JLToast = self._queue.operations[index] as! JLToast
                JLToast.updateView(thisToast.view)
            }
        }
    }
}
