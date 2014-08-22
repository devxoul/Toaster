/*
 * JLToast.swift
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

public struct JLToastDelay {
    public static let ShortDelay: NSTimeInterval = 2.0
    public static let LongDelay: NSTimeInterval = 3.5
}

public struct JLToastViewValue {
    static var FontSize: CGFloat {
        get { return UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone ? 12 : 16 }
    }
    
    static var PortraitOffsetY: CGFloat {
        get { return UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone ? 30 : 60 }
    }
    
    static var LandscapeOffsetY: CGFloat {
        get { return UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone ? 20 : 40 }
    }
}

@objc public class JLToast: NSOperation {
    var _view: JLToastView?
    
    var text: String {
        get { return _view!._textLabel!.text }
        set { _view!._textLabel!.text = newValue }
    }

    var delay: NSTimeInterval?
    var duration: NSTimeInterval?
    
    override public var executing: Bool {
        get { return _executing }
        set {
            willChangeValueForKey("isExecuting")
            _executing = newValue
            didChangeValueForKey("isExecuting")
        }
    }
    var _executing: Bool = false
    
    override public var finished: Bool {
        get { return _finished }
        set {
            willChangeValueForKey("isFinished")
            _finished = newValue
            didChangeValueForKey("isFinished")
        }
    }
    var _finished: Bool = false
    
    
    public class func makeText(text: String) -> JLToast {
        return JLToast.makeText(text, delay: 0, duration: JLToastDelay.ShortDelay)
    }
    
    public class func makeText(text: String, duration: NSTimeInterval) -> JLToast {
        return JLToast.makeText(text, delay: 0, duration: duration)
    }
    
    public class func makeText(text: String, delay: NSTimeInterval, duration: NSTimeInterval) -> JLToast {
        var toast = JLToast()
        toast.text = text
        toast.delay = delay
        toast.duration = duration
        return toast
    }
    
    override init() {
        _view = JLToastView()
    }
    
    public func show() {
        JLToastCenter.defaultCenter().addToast(self)
    }
    
    override public func start() {
        if !NSThread.isMainThread() {
            dispatch_async(dispatch_get_main_queue(), { () in self.start() })
        } else {
            super.start()
        }
    }
    
    override public func main() {
        executing = true
        
        dispatch_async(dispatch_get_main_queue(), { () in
            self._view!.updateView()
            self._view!.alpha = 0
            UIApplication.sharedApplication().keyWindow.addSubview(self._view!)
            UIView.animateWithDuration(0.5,
                delay: self.delay!,
                options: UIViewAnimationOptions.BeginFromCurrentState,
                animations: { () in self._view!.alpha = 1 },
                completion: { (completed: Bool) in
                    UIView.animateWithDuration(self.duration!,
                        animations: { () in self._view!.alpha = 1.0001 },
                        completion: { (completed: Bool) in
                            self.finish()
                            UIView.animateWithDuration(0.5, animations: { () in self._view!.alpha = 0 })
                    })
            })
        })
    }
    
    public func finish() {
        executing = false
        finished = true
    }
}