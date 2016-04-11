/*
 * JLToastView.swift
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

public class JLToastWindow: UIWindow {

    public static let sharedWindow = JLToastWindow(frame: UIScreen.mainScreen().bounds)

    /// Will not return `rootViewController` while this value is `true`. Or the rotation will be fucked in iOS 9.
    var isStatusBarOrientationChanging = false

    override public var rootViewController: UIViewController? {
        get {
            guard !self.isStatusBarOrientationChanging else { return nil }
            return UIApplication.sharedApplication().windows.first?.rootViewController
        }
        set { /* Do nothing */ }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.userInteractionEnabled = false
        self.windowLevel = CGFloat.max
        self.backgroundColor = .clearColor()
        self.hidden = false
        self.handleRotate(UIApplication.sharedApplication().statusBarOrientation)

        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "bringWindowToTop:",
            name: UIWindowDidBecomeVisibleNotification,
            object: nil
        )
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "statusBarOrientationWillChange",
            name: UIApplicationWillChangeStatusBarOrientationNotification,
            object: nil
        )
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "statusBarOrientationDidChange",
            name: UIApplicationDidChangeStatusBarOrientationNotification,
            object: nil
        )
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Bring JLToastWindow to top when another window is being shown.
    func bringWindowToTop(notification: NSNotification) {
        if !(notification.object is JLToastWindow) {
            self.dynamicType.sharedWindow.hidden = true
            self.dynamicType.sharedWindow.hidden = false
        }
    }

    dynamic func statusBarOrientationWillChange() {
        self.isStatusBarOrientationChanging = true
    }

    dynamic func statusBarOrientationDidChange() {
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        self.handleRotate(orientation)
        self.isStatusBarOrientationChanging = false
    }

    func handleRotate(orientation: UIInterfaceOrientation) {
        let angle = self.angleForOrientation(orientation)
        self.transform = CGAffineTransformMakeRotation(CGFloat(angle))

        if orientation.isPortrait {
            self.frame.size.width = UIScreen.mainScreen().bounds.size.width
            self.frame.size.height = UIScreen.mainScreen().bounds.size.height
        } else {
            self.frame.size.width = UIScreen.mainScreen().bounds.size.height
            self.frame.size.height = UIScreen.mainScreen().bounds.size.width
        }

        self.frame.origin = .zero
    }

    func angleForOrientation(orientation: UIInterfaceOrientation) -> Double {
        switch orientation {
        case .LandscapeLeft: return -M_PI_2
        case .LandscapeRight: return M_PI_2
        case .PortraitUpsideDown: return M_PI
        default: return 0
        }
    }

}
