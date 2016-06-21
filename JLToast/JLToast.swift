/*
 * JLToast.swift
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

public struct JLToastDelay {
    public static let ShortDelay: TimeInterval = 2.0
    public static let LongDelay: TimeInterval = 10
}

@objc public class JLToast: Operation {

    public var view: JLToastView = JLToastView()
    public static var topY: CGFloat? = nil
    
    public var text: String? {
        get {
            return self.view.textLabel.text
        }
        set {
            self.view.textLabel.text = newValue
        }
    }

    public var delay: TimeInterval = 0
    public var duration: TimeInterval = JLToastDelay.LongDelay

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

    // Use ONLY for debugging / staging builds
    public class func showDebugText(_ text: String) {
        NSLog("showDebugText: \(text)")
        #if DEBUG || RELEASE || PURPLE
        // Temporarily change colour to red for debug text
        if let bgColour = JLToastView.defaultValueForAttributeName(JLToastViewBackgroundColorAttributeName, forUserInterfaceIdiom: .unspecified) as? UIColor {
            JLToastView.setDefaultValue(
                UIColor.red(),
                forAttributeName: JLToastViewBackgroundColorAttributeName,
                userInterfaceIdiom: .unspecified
            )
            JLToast.makeText(text).show()
            JLToastView.setDefaultValue(
                bgColour,
                forAttributeName: JLToastViewBackgroundColorAttributeName,
                userInterfaceIdiom: .unspecified
            )
        }
        #endif
    }

    public class func makeText(_ text: String) -> JLToast {
        return JLToast.makeText(text, delay: 0, duration: JLToastDelay.ShortDelay)
    }
    
    public class func makeText(_ text: String, duration: TimeInterval) -> JLToast {
        return JLToast.makeText(text, delay: 0, duration: duration)
    }
    
    public class func makeText(_ text: String, delay: TimeInterval, duration: TimeInterval) -> JLToast {
        let toast = JLToast()
        toast.text = text
        toast.delay = delay
        toast.duration = duration
        return toast
    }
    
    public func show() {
        JLToastCenter.defaultCenter().addToast(self)
    }
    
    override public func start() {
        if !Thread.isMainThread() {
            DispatchQueue.main.async(execute: {
                self.start()
            })
        } else {
            super.start()
        }
    }

    public static func updateView(_ toastView: JLToastView) {
        toastView.updateView()
        if let topY = JLToast.topY {
            JLToast.topY = min(topY, toastView.frame.origin.y)
        } else {
            JLToast.topY = toastView.frame.origin.y
        }
    }

    override public func main() {
        self.isExecuting = true

        DispatchQueue.main.async(execute: {
            JLToast.updateView(self.view)
            self.view.alpha = 0
            JLToastWindow.sharedWindow.addSubview(self.view)
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
    
    public func finish() {
        self.isExecuting = false
        self.isFinished = true
    }

}
