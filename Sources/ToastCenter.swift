/*
 * ToastCenter.swift
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

@objc public class ToastCenter: NSObject {

    private var _queue: OperationQueue!

    public var currentToast: Toast? {
        return self._queue.operations.first as? Toast
    }

    private struct Singletone {
        static let defaultCenter = ToastCenter()
    }

    public class func defaultCenter() -> ToastCenter {
        return Singletone.defaultCenter
    }

    override init() {
        super.init()
        self._queue = OperationQueue()
        self._queue.maxConcurrentOperationCount = 1
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.deviceOrientationDidChange),
            name: NSNotification.Name.UIDeviceOrientationDidChange,
            object: nil
        )
    }

    public func addToast(_ toast: Toast) {
        self._queue.addOperation(toast)
    }

    func deviceOrientationDidChange(_ sender: AnyObject?) {
        if self._queue.operations.count > 0 {
            let lastToast: Toast = _queue.operations[0] as! Toast
            lastToast.view.updateView()
        }
    }

    public func cancelAllToasts() {
        for toast in self._queue.operations {
            toast.cancel()
        }
    }

}
