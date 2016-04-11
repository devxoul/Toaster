/*
 * RootViewController.swift
 *
 *            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
 *                    Version 2, December 2004
 *
 * Copyright (C) 2013-2015 Suyeol Jeon <devxoul@gmail.com>
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
import JLToast

class RootViewController: UIViewController {

    override func viewDidLoad() {
        let button = UIButton(type: .System)
        button.setTitle("Show", forState: .Normal)
        button.sizeToFit()
        button.center.x = self.view.frame.width / 2
        button.center.y = 60
        button.addTarget(self, action: #selector(self.showButtonTouchUpInside), forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
    }

    func showButtonTouchUpInside() {
        JLToast.makeText("Basic JLToast").show()
        JLToast.makeText("You can set duration. `JLToastDelay.ShortDelay` means 2 seconds.\n" +
                         "`JLToastDelay.LongDelay` means 3.5 seconds.", duration: JLToastDelay.LongDelay).show()
        JLToast.makeText("With delay, JLToast will be shown after delay.", delay: 1, duration: 5).show()
    }
}
