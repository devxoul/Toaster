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

    /// Don't rotate manually if the application:
    ///
    /// - is running on iPad
    /// - is running on iOS 9
    /// - supports all orientations
    /// - doesn't require full screen
    /// - has launch storyboard
    ///
    var shouldRotateManually: Bool {
        let iPad = UIDevice.currentDevice().userInterfaceIdiom == .Pad
        let application = UIApplication.sharedApplication()
        let window = application.delegate?.window ?? nil
        let supportsAllOrientations = application.supportedInterfaceOrientationsForWindow(window) == .All

        let info = NSBundle.mainBundle().infoDictionary
        let requiresFullScreen = info?["UIRequiresFullScreen"]?.boolValue == true
        let hasLaunchStoryboard = info?["UILaunchStoryboardName"] != nil

        if #available(iOS 9, *), iPad && supportsAllOrientations && !requiresFullScreen && hasLaunchStoryboard {
            return false
        }
        return true
    }

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
            selector: #selector(self.bringWindowToTop),
            name: UIWindowDidBecomeVisibleNotification,
            object: nil
        )
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(self.statusBarOrientationWillChange),
            name: UIApplicationWillChangeStatusBarOrientationNotification,
            object: nil
        )
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(self.statusBarOrientationDidChange),
            name: UIApplicationDidChangeStatusBarOrientationNotification,
            object: nil
        )
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(self.applicationDidBecomeActive),
            name: UIApplicationDidBecomeActiveNotification,
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

    func applicationDidBecomeActive() {
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        self.handleRotate(orientation)
    }

    func handleRotate(orientation: UIInterfaceOrientation) {
        let angle = self.angleForOrientation(orientation)
        if self.shouldRotateManually {
            self.transform = CGAffineTransformMakeRotation(CGFloat(angle))
        }

        if let window = UIApplication.sharedApplication().windows.first {
            if orientation.isPortrait || !self.shouldRotateManually {
                self.frame.size.width = window.bounds.size.width
                self.frame.size.height = window.bounds.size.height
            } else {
                self.frame.size.width = window.bounds.size.height
                self.frame.size.height = window.bounds.size.width
            }
        }

        self.frame.origin = .zero

        dispatch_async(dispatch_get_main_queue()) {
            JLToastCenter.defaultCenter().currentToast?.view.updateView()
        }
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
