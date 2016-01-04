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

    public static let sharedWindow: JLToastWindow = {
        let window = JLToastWindow(frame: UIScreen.mainScreen().bounds)
        window.userInteractionEnabled = false
        window.windowLevel = CGFloat.max
        window.backgroundColor = .clearColor()
        window.rootViewController = JLToastWindowRootViewController()
        window.hidden = false
        return window
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "bringWindowToTop:",
            name: UIWindowDidBecomeVisibleNotification,
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

}


private class JLToastWindowRootViewController: UIViewController {

    private convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    private override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0)
    }

    private override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIApplication.sharedApplication().statusBarStyle
    }

    private override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .All
    }

}
