//
//  JLToastView.swift
//  JLToastSample
//
//  Created by 전수열 on 6/3/14.
//  Copyright (c) 2014 Joyfl. All rights reserved.
//

import UIKit

class JLToastView: UIView {

    var _backgroundView: UIView?
    var _textLabel: UILabel?
    var _textInsets: UIEdgeInsets?

    init() {
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
        self.addSubview(_textLabel!)

        _textInsets = UIEdgeInsetsMake(6, 10, 6, 10)
    }

    func updateView() {
        let deviceWidth = UIScreen.mainScreen().bounds.size.width
        let font = self._textLabel!.font
        let constraintSize = CGSizeMake(deviceWidth * (280.0 / 320.0), CGFloat(INT_MAX))
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
        var width: CGFloat
        var height: CGFloat
        var angle: CGFloat

        switch UIApplication.sharedApplication().statusBarOrientation {
            case UIInterfaceOrientation.PortraitUpsideDown:
                width = self._backgroundView!.frame.size.width
                height = self._backgroundView!.frame.size.height
                x = (UIScreen.mainScreen().bounds.size.width - width) / 2
                y = JLToastViewValue.PortraitOffsetY

            case UIInterfaceOrientation.LandscapeRight:
                width = self._backgroundView!.frame.size.height
                height = self._backgroundView!.frame.size.width
                x = (UIScreen.mainScreen().bounds.size.width - height) / 2;
                y = UIScreen.mainScreen().bounds.size.height - width - JLToastViewValue.LandscapeOffsetY

            case UIInterfaceOrientation.LandscapeLeft:
                width = self._backgroundView!.frame.size.height
                height = self._backgroundView!.frame.size.width
                x = (UIScreen.mainScreen().bounds.size.width - height) / 2;
                y = UIScreen.mainScreen().bounds.size.height - width - JLToastViewValue.LandscapeOffsetY

            default:
                width = self._backgroundView!.frame.size.width
                height = self._backgroundView!.frame.size.height
                x = (UIScreen.mainScreen().bounds.size.width - width) / 2
                y = UIScreen.mainScreen().bounds.size.height - height - JLToastViewValue.PortraitOffsetY
        }

        self.frame = CGRectMake(x, y, width, height);
    }

    override func hitTest(point: CGPoint, withEvent event: UIEvent!) -> UIView? {
        return nil
    }
}
