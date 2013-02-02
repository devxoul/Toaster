/*
 * JLToast.h
 *
 *            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
 *                    Version 2, February 2013
 *
 * Copyright (C) 2013 Joyfl
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

#import <UIKit/UIKit.h>

#define JLToastShortDelay	2.0f
#define JLToastLongDelay	3.5f

@class JLToastView;

@interface JLToast : NSOperation
{
	BOOL _isExecuting;
	BOOL _isFinished;
}

@property (nonatomic, strong) JLToastView *view;
@property (nonatomic, weak) NSString *text;
@property (nonatomic) NSTimeInterval delay;
@property (nonatomic) NSTimeInterval duration;

+ (id)makeText:(NSString *)text;
+ (id)makeText:(NSString *)text duration:(NSTimeInterval)duration;
+ (id)makeText:(NSString *)text delay:(NSTimeInterval)delay duration:(NSTimeInterval)duration;

- (void)show;
- (void)cancel;

@end
