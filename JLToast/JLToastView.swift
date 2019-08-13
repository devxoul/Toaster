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
    weak var delegate: JLToastDelegate? = nil
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

        let userInterfaceIdiom = UIDevice.current.userInterfaceIdiom

        self.isUserInteractionEnabled = false

        self.backgroundView = UIView()
        self.backgroundView.frame = self.bounds
        self.backgroundView.backgroundColor = type(of: self).defaultValueForAttributeName(
            JLToastViewBackgroundColorAttributeName,
            forUserInterfaceIdiom: userInterfaceIdiom
        ) as? UIColor
        self.backgroundView.layer.cornerRadius = CGFloat(type(of: self).defaultValueForAttributeName(
            JLToastViewCornerRadiusAttributeName,
            forUserInterfaceIdiom: userInterfaceIdiom
        ) as! Double)
        self.backgroundView.clipsToBounds = true
        self.addSubview(self.backgroundView)

        self.textLabel = UILabel()
        self.textLabel.frame = self.bounds
        self.textLabel.textColor = type(of: self).defaultValueForAttributeName(
            JLToastViewTextColorAttributeName,
            forUserInterfaceIdiom: userInterfaceIdiom
        ) as? UIColor
        self.textLabel.backgroundColor = UIColor.clear
        self.textLabel.font = type(of: self).defaultValueForAttributeName(
            JLToastViewFontAttributeName,
            forUserInterfaceIdiom: userInterfaceIdiom
        ) as! UIFont
        self.textLabel.numberOfLines = 0
        self.textLabel.textAlignment = .center;
        self.addSubview(self.textLabel)

        self.textInsets = (type(of: self).defaultValueForAttributeName(
            JLToastViewTextInsetsAttributeName,
            forUserInterfaceIdiom: userInterfaceIdiom
        ) as! NSValue).uiEdgeInsetsValue
    }
    
    required convenience public init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    func updateView() {
        let deviceWidth = UIScreen.main.bounds.width
        let constraintSize = CGSize(width: deviceWidth * (280.0 / 320.0), height: CGFloat.greatestFiniteMagnitude)
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

        let screenSize = UIScreen.main.bounds.size
        let backgroundViewSize = self.backgroundView.frame.size

        let orientation = UIApplication.shared.statusBarOrientation
        let systemVersion = (UIDevice.current.systemVersion as NSString).floatValue

        let userInterfaceIdiom = UIDevice.current.userInterfaceIdiom
        let portraitOffsetY = CGFloat(type(of: self).defaultValueForAttributeName(
            JLToastViewPortraitOffsetYAttributeName,
            forUserInterfaceIdiom: userInterfaceIdiom
        ) as! Double)
        let landscapeOffsetY = CGFloat(type(of: self).defaultValueForAttributeName(
            JLToastViewLandscapeOffsetYAttributeName,
            forUserInterfaceIdiom: userInterfaceIdiom
        ) as! Double)

        if orientation.isLandscape && systemVersion < 8.0 {
            width = screenSize.height
            height = screenSize.width
            y = landscapeOffsetY
        } else {
            width = screenSize.width
            height = screenSize.height
            if orientation.isLandscape {
                y = landscapeOffsetY
            } else {
                y = portraitOffsetY
            }
        }

        x = (width - backgroundViewSize.width) * 0.5
        if let topY = JLToast.topY {
            y = topY - (backgroundViewSize.height + 5.0)
        } else {
            y = height - y - backgroundViewSize.height
        }
        self.frame = CGRect(x: x, y: y, width: backgroundViewSize.width, height: backgroundViewSize.height);
    }
    
    override public func hitTest(_ point: CGPoint, with event: UIEvent!) -> UIView? {
        if self.superview != nil {
            let pointInWindow = self.convert(point, to: self.superview)
            let contains = self.frame.contains(pointInWindow)
            if contains && self.isUserInteractionEnabled {
                return self
            }
        }
        return nil
    }

}

public extension JLToastView {
    private struct Singleton {
        static var defaultValues: [String: [UIUserInterfaceIdiom: Any]] = [
            // backgroundView.color
            JLToastViewBackgroundColorAttributeName: [
                .unspecified: UIColor(white: 0, alpha: 0.7)
            ],

            // backgroundView.layer.cornerRadius
            JLToastViewCornerRadiusAttributeName: [
                .unspecified: 5.0
            ],

            JLToastViewTextInsetsAttributeName: [
                .unspecified: NSValue(uiEdgeInsets: UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10))
            ],

            // textLabel.textColor
            JLToastViewTextColorAttributeName: [
                .unspecified: UIColor.white
            ],

            // textLabel.font
            JLToastViewFontAttributeName: [
                .unspecified: UIFont.systemFont(ofSize: 12),
                .phone: UIFont.systemFont(ofSize: 12),
                .pad: UIFont.systemFont(ofSize: 16),
            ],

            JLToastViewPortraitOffsetYAttributeName: [
                .unspecified: 30.0,
                .phone: 30.0,
                .pad: 60.0,
            ],
            JLToastViewLandscapeOffsetYAttributeName: [
                .unspecified: 20.0,
                .phone: 20.0,
                .pad: 40.0,
            ],
        ]
    }

    class func defaultValueForAttributeName(_ attributeName: String,
                                            forUserInterfaceIdiom userInterfaceIdiom: UIUserInterfaceIdiom)
                                            -> Any {
        let valueForAttributeName = Singleton.defaultValues[attributeName]!
        if let value = valueForAttributeName[userInterfaceIdiom] {
            return value
        }
        return valueForAttributeName[.unspecified]!
    }

    class func setDefaultValue(_ value: AnyObject,
                               forAttributeName attributeName: String,
                               userInterfaceIdiom: UIUserInterfaceIdiom) {
        var values = Singleton.defaultValues[attributeName]!
        values[userInterfaceIdiom] = value
        Singleton.defaultValues[attributeName] = values
    }
}
