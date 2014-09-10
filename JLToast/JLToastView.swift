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
    
    var _backgroundView: UIView?
    var _textLabel: UILabel?
    var _textInsets: UIEdgeInsets?
	var _position = JLToastPosition.Top
    
    override init() {
        super.init(frame: CGRectMake(0, 0, 100, 100))
        _backgroundView = UIView(frame: self.bounds)
        _backgroundView!.backgroundColor = UIColor(white: 0, alpha: 0.7)
        _backgroundView!.layer.cornerRadius = 5
        _backgroundView!.clipsToBounds = true
        self.addSubview(_backgroundView!)
        
        _textLabel = UILabel(frame: CGRectMake(0, 0, 100, 100))
        _textLabel!.textColor = UIColor.whiteColor()
        _textLabel!.backgroundColor = UIColor.clearColor()
        _textLabel!.font = UIFont.systemFontOfSize(JLToastViewValue.FontSize)
        _textLabel!.numberOfLines = 0
        _textLabel!.textAlignment = NSTextAlignment.Center;
        self.addSubview(_textLabel!)
        
        _textInsets = UIEdgeInsetsMake(6, 10, 6, 10)
    }
    
    required convenience public init(coder aDecoder: NSCoder) {
        self.init()
    }
    
    func updateView() {
        let deviceWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let font = self._textLabel!.font
        let constraintSize = CGSizeMake(deviceWidth * (280.0 / 320.0), CGFloat.max)
        var textLabelSize = self._textLabel!.sizeThatFits(constraintSize)
        self._textLabel!.frame = CGRect(
            x: self._textInsets!.left,
            y: self._textInsets!.top,
            width: textLabelSize.width,
            height: textLabelSize.height
        )
        self._backgroundView!.frame = CGRect(
            x: 0,
            y: 0,
            width: self._textLabel!.frame.size.width + self._textInsets!.left + self._textInsets!.right,
            height: self._textLabel!.frame.size.height + self._textInsets!.top + self._textInsets!.bottom
        )
        
		var x: CGFloat
		var y: CGFloat
		var wd:CGFloat
		var ht:CGFloat
		
		var width = self._backgroundView!.frame.size.width
		var height = self._backgroundView!.frame.size.height
		let sz = UIScreen.mainScreen().bounds.size
		let orientation = UIApplication.sharedApplication().statusBarOrientation
		let sver = UIDevice.currentDevice().systemVersion as NSString
		let ver = sver.floatValue
		if UIInterfaceOrientationIsLandscape(orientation) && ver < 8.0 {
			wd = sz.height
			ht = sz.width
			y = JLToastViewValue.LandscapeOffsetY
		} else {
			wd = sz.width
			ht = sz.height
			if UIInterfaceOrientationIsLandscape(orientation) {
				y = JLToastViewValue.LandscapeOffsetY
			} else {
				y = JLToastViewValue.PortraitOffsetY
			}
		}
		x = (wd - width) * 0.5
		if _position == JLToastPosition.Bottom {
			y = ht - (height + y)
		}
        self.frame = CGRectMake(x, y, width, height);
    }
    
    override public func hitTest(point: CGPoint, withEvent event: UIEvent!) -> UIView? {
        return nil
    }
}
