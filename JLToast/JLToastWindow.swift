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
        let window = JLToastWindow(frame: UIScreen.main().bounds)
        window.isUserInteractionEnabled = false
        window.windowLevel = CGFloat.greatestFiniteMagnitude
        window.backgroundColor = .clear()
        window.rootViewController = JLToastWindowRootViewController()
        window.isHidden = false
        return window
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default().addObserver(self,
            selector: "bringWindowToTop:",
            name: NSNotification.Name.UIWindowDidBecomeVisible,
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

}


private class JLToastWindowRootViewController: UIViewController {

    private convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    private override func viewDidLoad() {
        super.viewDidLoad()
    }

    private override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIApplication.shared().statusBarStyle
    }

    private override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .all
    }

}
