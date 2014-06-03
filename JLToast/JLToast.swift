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

struct JLToastDelay {
    static let ShortDelay: NSTimeInterval = 2.0
    static let LongDelay: NSTimeInterval = 3.5
}

struct JLToastViewValue {
    static var FontSize: CGFloat {
    get {
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            return 12
        } else {
            return 16
        }
    }
    }

    static var PortraitOffsetY:CGFloat {
    get {
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            return 30
        } else {
            return 60
        }
    }
    }

    static var LandscapeOffsetY:CGFloat {
    get {
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            return 20
        } else {
            return 40
        }
    }
    }
}

class JLToast: NSOperation {
    var _view: JLToastView?

    var text: String {
    get {
        return _view!._textLabel!.text
    }
    set(text) {
        _view!._textLabel!.text = text
    }
    }
    var delay: NSTimeInterval?
    var duration: NSTimeInterval?

    var _executing: Bool = false
    override var executing: Bool {
    get {
        return self._executing
    }
    }

    var _finished: Bool = false
    override var finished: Bool {
    get {
        return self._finished
    }
    }


    class func makeText(text: String) -> JLToast {
        return JLToast.makeText(text, delay: 0, duration: JLToastDelay.ShortDelay)
    }

    class func makeText(text: String, duration: NSTimeInterval) -> JLToast {
        return JLToast.makeText(text, delay: 0, duration: duration)
    }

    class func makeText(text: String, delay: NSTimeInterval, duration: NSTimeInterval) -> JLToast {
        var toast = JLToast()
        toast.text = text
        toast.delay = delay
        toast.duration = duration
        return toast
    }

    init() {
        _view = JLToastView()
    }

    func show() {
        JLToastCenter.defaultCenter().addToast(self)
    }

    override func start() {
        if !NSThread.mainThread()? {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in self.start() })
        } else {
            super.start()
        }
    }

    override func main() {
        self.willChangeValueForKey("executing")
        self._executing = true
        self.didChangeValueForKey("executing")

        dispatch_async(dispatch_get_main_queue(), {
            () -> Void in
            self._view!.updateView()
            self._view!.alpha = 0
            UIApplication.sharedApplication().keyWindow.addSubview(self._view!)
            UIView.animateWithDuration(0.5,
                delay: self.delay!,
                options: UIViewAnimationOptions.BeginFromCurrentState,
                animations: { () -> Void in self._view!.alpha = 1 },
                completion: { (completed: Bool) -> Void in
                    UIView.animateWithDuration(self.duration!,
                        animations: { () -> Void in self._view!.alpha = 1.0001 },
                        completion: { (completed: Bool) -> Void in
                            self.finish()
                            UIView.animateWithDuration(0.5, animations: { () -> Void in
                                self._view!.alpha = 0
                                })
                        })
                })
            })
    }

    func finish() {
        self.willChangeValueForKey("isExecuting")
        self._executing = false
        self.didChangeValueForKey("isExecuting")

        self.willChangeValueForKey("isFinished")
        self._finished = true
        self.didChangeValueForKey("isFinished")
    }
}