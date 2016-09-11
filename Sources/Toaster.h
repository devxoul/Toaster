/*
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

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT double ToasterVersionNumber;
FOUNDATION_EXPORT const unsigned char ToasterVersionString[];

#if __OBJC__
static NSTimeInterval const ToastShortDelay = 2.0;
static NSTimeInterval const ToastLongDelay = 3.5;
static NSString * const ToastViewBackgroundColorAttributeName = @"ToastViewBackgroundColorAttributeName";
static NSString * const ToastViewCornerRadiusAttributeName = @"ToastViewCornerRadiusAttributeName";
static NSString * const ToastViewTextInsetsAttributeName = @"ToastViewTextInsetsAttributeName";
static NSString * const ToastViewTextColorAttributeName = @"ToastViewTextColorAttributeName";
static NSString * const ToastViewFontAttributeName = @"ToastViewFontAttributeName";
static NSString * const ToastViewPortraitOffsetYAttributeName = @"ToastViewPortraitOffsetYAttributeName";
static NSString * const ToastViewLandscapeOffsetYAttributeName = @"ToastViewLandscapeOffsetYAttributeName";
#endif
