/*
 * JLToastView.swift
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

@objc public class JLToastView: UIView {
    
    var backgroundView: UIView!
    var textLabel: UILabel!
    var textInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
    
    override init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

        self.backgroundView = UIView()
        self.backgroundView.frame = self.bounds
        self.backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        self.backgroundView.layer.cornerRadius = 5
        self.backgroundView.clipsToBounds = true
        self.addSubview(self.backgroundView)

        self.textLabel = UILabel()
        self.textLabel.frame = self.bounds
        self.textLabel.textColor = UIColor.whiteColor()
        self.textLabel.backgroundColor = UIColor.clearColor()
        self.textLabel.font = UIFont.systemFontOfSize(JLToastViewValue.FontSize)
        self.textLabel.numberOfLines = 0
        self.textLabel.textAlignment = .Center;
        self.addSubview(self.textLabel)
    }
    
    required convenience public init(coder aDecoder: NSCoder) {
        self.init()
    }
    
    func updateView() {
        let deviceWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let font = self.textLabel.font
        let constraintSize = CGSize(width: deviceWidth * (280.0 / 320.0), height: CGFloat.max)
        var textLabelSize = self.textLabel.sizeThatFits(constraintSize)
        self.textLabel.frame = CGRect(
            x: self.textInsets.left,
            y: self.textInsets.top,
            width: textLabelSize.width,
            height: textLabelSize.height
        )
        self.backgroundView.frame = CGRect(
            x: 0,
            y: 0,
            width: self.textLabel.frame.size.width + self.textInsets.left + self.textInsets.right,
            height: self.textLabel.frame.size.height + self.textInsets.top + self.textInsets.bottom
        )

        var x: CGFloat
        var y: CGFloat
        var width:CGFloat
        var height:CGFloat

        let screenSize = UIScreen.mainScreen().bounds.size
        let backgroundViewSize = self.backgroundView.frame.size

        let orientation = UIApplication.sharedApplication().statusBarOrientation
        let systemVersion = (UIDevice.currentDevice().systemVersion as NSString).floatValue

        if UIInterfaceOrientationIsLandscape(orientation) && systemVersion < 8.0 {
            width = screenSize.height
            height = screenSize.width
            y = JLToastViewValue.LandscapeOffsetY
        } else {
            width = screenSize.width
            height = screenSize.height
            if UIInterfaceOrientationIsLandscape(orientation) {
                y = JLToastViewValue.LandscapeOffsetY
            } else {
                y = JLToastViewValue.PortraitOffsetY
            }
        }

        x = (width - backgroundViewSize.width) * 0.5
        y = height - (backgroundViewSize.height + y)
        self.frame = CGRect(x: x, y: y, width: width, height: height);
    }
    
    override public func hitTest(point: CGPoint, withEvent event: UIEvent!) -> UIView? {
        return nil
    }
}
