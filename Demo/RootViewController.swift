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
import Toaster

final class RootViewController: UIViewController {

  override func viewDidLoad() {
    let button = UIButton(type: .system)
    button.setTitle("Show", for: .normal)
    button.sizeToFit()
    button.addTarget(self, action: #selector(self.showButtonTouchUpInside), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    self.view.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(button)
    self.view.addConstraints([
      NSLayoutConstraint(
        item: button,
        attribute: .top,
        relatedBy: .equal,
        toItem: self.view,
        attribute: .top,
        multiplier: 1,
        constant: 60
      ),
      NSLayoutConstraint(
        item: button,
        attribute: .centerX,
        relatedBy: .equal,
        toItem: self.view,
        attribute: .centerX,
        multiplier: 1,
        constant: 0
      )
    ])

    self.configureAppearance()
  }

  func configureAppearance() {
    let appearance = ToastView.appearance()
    appearance.backgroundColor = .lightGray
    appearance.textColor = .black
    appearance.font = .boldSystemFont(ofSize: 16)
    appearance.textInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
    appearance.bottomOffsetPortrait = 100
    appearance.cornerRadius = 20
  }

  @objc dynamic func showButtonTouchUpInside() {
    Toast(text: "Basic Toast").show()
    Toast(text: "You can set duration. `Delay.short` means 2 seconds.\n" +
      "`Delay.long` means 3.5 seconds.",
          duration: Delay.long).show()
    Toast(text: "With delay, Toaster will be shown after delay.", delay: 1, duration: 5).show()
  }
}
