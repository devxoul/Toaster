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

    public static let sharedWindow = JLToastWindow(frame: UIScreen.main().bounds)

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
        let iPad = UIDevice.current().userInterfaceIdiom == .pad
        let application = UIApplication.shared()
        let window = application.delegate?.window ?? nil
        let supportsAllOrientations = application.supportedInterfaceOrientations(for: window) == .all

        let info = Bundle.main.infoDictionary
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
            return UIApplication.shared().windows.first?.rootViewController
        }
        set { /* Do nothing */ }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
        self.windowLevel = CGFloat.greatestFiniteMagnitude
        self.backgroundColor = .clear()
        self.isHidden = false
        self.handleRotate(UIApplication.shared().statusBarOrientation)

        NotificationCenter.default.addObserver(self,
            selector: #selector(self.bringWindowToTop),
            name: NSNotification.Name.UIWindowDidBecomeVisible,
            object: nil
        )
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.statusBarOrientationWillChange),
            name: NSNotification.Name.UIApplicationWillChangeStatusBarOrientation,
            object: nil
        )
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.statusBarOrientationDidChange),
            name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation,
            object: nil
        )
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.applicationDidBecomeActive),
            name: NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil
        )
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Bring JLToastWindow to top when another window is being shown.
    func bringWindowToTop(_ notification: Notification) {
        if !(notification.object is JLToastWindow) {
            self.dynamicType.sharedWindow.isHidden = true
            self.dynamicType.sharedWindow.isHidden = false
        }
    }

    dynamic func statusBarOrientationWillChange() {
        self.isStatusBarOrientationChanging = true
    }

    dynamic func statusBarOrientationDidChange() {
        let orientation = UIApplication.shared().statusBarOrientation
        self.handleRotate(orientation)
        self.isStatusBarOrientationChanging = false
    }

    func applicationDidBecomeActive() {
        let orientation = UIApplication.shared().statusBarOrientation
        self.handleRotate(orientation)
    }

    func handleRotate(_ orientation: UIInterfaceOrientation) {
        let angle = self.angleForOrientation(orientation)
        if self.shouldRotateManually {
            self.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
        }

        if let window = UIApplication.shared().windows.first {
            if orientation.isPortrait || !self.shouldRotateManually {
                self.frame.size.width = window.bounds.size.width
                self.frame.size.height = window.bounds.size.height
            } else {
                self.frame.size.width = window.bounds.size.height
                self.frame.size.height = window.bounds.size.width
            }
        }

        self.frame.origin = .zero

        DispatchQueue.main.async {
            JLToastCenter.defaultCenter().currentToast?.view.updateView()
        }
    }

    func angleForOrientation(_ orientation: UIInterfaceOrientation) -> Double {
        switch orientation {
        case .landscapeLeft: return -M_PI_2
        case .landscapeRight: return M_PI_2
        case .portraitUpsideDown: return M_PI
        default: return 0
        }
    }

}
