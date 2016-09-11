/*
 * Toast.swift
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

public struct ToastDelay {
    public static let ShortDelay: TimeInterval = 2.0
    public static let LongDelay: TimeInterval = 3.5
}

@objc public class Toast: Operation {

    public var view: ToastView = ToastView()
    
    public var text: String? {
        get {
            return self.view.textLabel.text
        }
        set {
            self.view.textLabel.text = newValue
        }
    }

    public var delay: TimeInterval = 0
    public var duration: TimeInterval = ToastDelay.ShortDelay

    private var _executing = false
    override public var isExecuting: Bool {
        get {
            return self._executing
        }
        set {
            self.willChangeValue(forKey: "isExecuting")
            self._executing = newValue
            self.didChangeValue(forKey: "isExecuting")
        }
    }

    private var _finished = false
    override public var isFinished: Bool {
        get {
            return self._finished
        }
        set {
            self.willChangeValue(forKey: "isFinished")
            self._finished = newValue
            self.didChangeValue(forKey: "isFinished")
        }
    }
    
    public class func makeText(_ text: String) -> Toast {
        return Toast.makeText(text, delay: 0, duration: ToastDelay.ShortDelay)
    }
    
    public class func makeText(_ text: String, duration: TimeInterval) -> Toast {
        return Toast.makeText(text, delay: 0, duration: duration)
    }
    
    public class func makeText(_ text: String, delay: TimeInterval, duration: TimeInterval) -> Toast {
        let toast = Toast()
        toast.text = text
        toast.delay = delay
        toast.duration = duration
        return toast
    }
    
    public func show() {
        ToastCenter.defaultCenter().addToast(self)
    }
    
    override public func start() {
        if !Thread.isMainThread {
            DispatchQueue.main.async(execute: {[weak self] in
                self?.start()
            })
        } else {
            super.start()
        }
    }

    override public func main() {
        self.isExecuting = true

        DispatchQueue.main.async(execute: {
            self.view.updateView()
            self.view.alpha = 0
            ToastWindow.sharedWindow.addSubview(self.view)
            UIView.animate(
                withDuration: 0.5,
                delay: self.delay,
                options: .beginFromCurrentState,
                animations: {
                    self.view.alpha = 1
                },
                completion: { completed in
                    UIView.animate(
                        withDuration: self.duration,
                        animations: {
                            self.view.alpha = 1.0001
                        },
                        completion: { completed in
                            self.finish()
                            UIView.animate(
                                withDuration: 0.5,
                                animations: {
                                    self.view.alpha = 0
                                },
                                completion:{ completed in
                                    self.view.removeFromSuperview()
                                    
                            })
                        }
                    )
                }
            )
        })
    }

    public override func cancel() {
        super.cancel()
        self.finish()
        self.view.removeFromSuperview()
    }
    
    public func finish() {
        self.isExecuting = false
        self.isFinished = true
    }

}
