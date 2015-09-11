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

public let JLToastViewBackgroundColorAttributeName = "JLToastViewBackgroundColorAttributeName"
public let JLToastViewCornerRadiusAttributeName = "JLToastViewCornerRadiusAttributeName"
public let JLToastViewTextInsetsAttributeName = "JLToastViewTextInsetsAttributeName"
public let JLToastViewTextColorAttributeName = "JLToastViewTextColorAttributeName"
public let JLToastViewFontAttributeName = "JLToastViewFontAttributeName"
public let JLToastViewPortraitOffsetYAttributeName = "JLToastViewPortraitOffsetYAttributeName"
public let JLToastViewLandscapeOffsetYAttributeName = "JLToastViewLandscapeOffsetYAttributeName"

@objc public class JLToastView: UIView {
    
    public var backgroundView: UIView!
    public var textLabel: UILabel!
    public var textInsets: UIEdgeInsets!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

        let userInterfaceIdiom = UIDevice.currentDevice().userInterfaceIdiom

        self.userInteractionEnabled = false

        self.backgroundView = UIView()
        self.backgroundView.frame = self.bounds
        self.backgroundView.backgroundColor = self.dynamicType.defaultValueForAttributeName(
            JLToastViewBackgroundColorAttributeName,
            forUserInterfaceIdiom: userInterfaceIdiom
        ) as? UIColor
        self.backgroundView.layer.cornerRadius = self.dynamicType.defaultValueForAttributeName(
            JLToastViewCornerRadiusAttributeName,
            forUserInterfaceIdiom: userInterfaceIdiom
        ) as! CGFloat
        self.backgroundView.clipsToBounds = true
        self.addSubview(self.backgroundView)

        self.textLabel = UILabel()
        self.textLabel.frame = self.bounds
        self.textLabel.textColor = self.dynamicType.defaultValueForAttributeName(
            JLToastViewTextColorAttributeName,
            forUserInterfaceIdiom: userInterfaceIdiom
        ) as? UIColor
        self.textLabel.backgroundColor = UIColor.clearColor()
        self.textLabel.font = self.dynamicType.defaultValueForAttributeName(
            JLToastViewFontAttributeName,
            forUserInterfaceIdiom: userInterfaceIdiom
        ) as! UIFont
        self.textLabel.numberOfLines = 0
        self.textLabel.textAlignment = .Center;
        self.addSubview(self.textLabel)

        self.textInsets = (self.dynamicType.defaultValueForAttributeName(
            JLToastViewTextInsetsAttributeName,
            forUserInterfaceIdiom: userInterfaceIdiom
        ) as! NSValue).UIEdgeInsetsValue()
    }
    
    required convenience public init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    func updateView() {
        let deviceWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let constraintSize = CGSize(width: deviceWidth * (280.0 / 320.0), height: CGFloat.max)
        let textLabelSize = self.textLabel.sizeThatFits(constraintSize)
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

        let userInterfaceIdiom = UIDevice.currentDevice().userInterfaceIdiom
        let portraitOffsetY = self.dynamicType.defaultValueForAttributeName(
            JLToastViewPortraitOffsetYAttributeName,
            forUserInterfaceIdiom: userInterfaceIdiom
        ) as! CGFloat
        let landscapeOffsetY = self.dynamicType.defaultValueForAttributeName(
            JLToastViewLandscapeOffsetYAttributeName,
            forUserInterfaceIdiom: userInterfaceIdiom
        ) as! CGFloat

        if UIInterfaceOrientationIsLandscape(orientation) && systemVersion < 8.0 {
            width = screenSize.height
            height = screenSize.width
            y = landscapeOffsetY
        } else {
            width = screenSize.width
            height = screenSize.height
            if UIInterfaceOrientationIsLandscape(orientation) {
                y = landscapeOffsetY
            } else {
                y = portraitOffsetY
            }
        }

        x = (width - backgroundViewSize.width) * 0.5
        y = height - (backgroundViewSize.height + y)
        self.frame = CGRect(x: x, y: y, width: backgroundViewSize.width, height: backgroundViewSize.height);
    }
    
    override public func hitTest(point: CGPoint, withEvent event: UIEvent!) -> UIView? {
        if self.superview != nil {
            let pointInWindow = self.convertPoint(point, toView: self.superview)
            let contains = CGRectContainsPoint(self.frame, pointInWindow)
            if contains && self.userInteractionEnabled {
                return self
            }
        }
        return nil
    }

}

public extension JLToastView {
    private struct Singleton {
        static var defaultValues: [String: [UIUserInterfaceIdiom: AnyObject]] = [
            // backgroundView.color
            JLToastViewBackgroundColorAttributeName: [
                .Unspecified: UIColor(white: 0, alpha: 0.7)
            ],

            // backgroundView.layer.cornerRadius
            JLToastViewCornerRadiusAttributeName: [
                .Unspecified: 5
            ],

            JLToastViewTextInsetsAttributeName: [
                .Unspecified: NSValue(UIEdgeInsets: UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10))
            ],

            // textLabel.textColor
            JLToastViewTextColorAttributeName: [
                .Unspecified: UIColor.whiteColor()
            ],

            // textLabel.font
            JLToastViewFontAttributeName: [
                .Unspecified: UIFont.systemFontOfSize(12),
                .Phone: UIFont.systemFontOfSize(12),
                .Pad: UIFont.systemFontOfSize(16),
            ],

            JLToastViewPortraitOffsetYAttributeName: [
                .Unspecified: 30,
                .Phone: 30,
                .Pad: 60,
            ],
            JLToastViewLandscapeOffsetYAttributeName: [
                .Unspecified: 20,
                .Phone: 20,
                .Pad: 40,
            ],
        ]
    }

    class func defaultValueForAttributeName(attributeName: String,
                                            forUserInterfaceIdiom userInterfaceIdiom: UIUserInterfaceIdiom)
                                            -> AnyObject {
        let valueForAttributeName = Singleton.defaultValues[attributeName]!
        if let value: AnyObject = valueForAttributeName[userInterfaceIdiom] {
            return value
        }
        return valueForAttributeName[.Unspecified]!
    }

    class func setDefaultValue(value: AnyObject,
                               forAttributeName attributeName: String,
                               userInterfaceIdiom: UIUserInterfaceIdiom) {
        var values = Singleton.defaultValues[attributeName]!
        values[userInterfaceIdiom] = value
        Singleton.defaultValues[attributeName] = values
    }
}
