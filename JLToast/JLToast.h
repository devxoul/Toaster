//
//  JLToastView.h
//  SleepIfUCan
//
//  Created by 전수열 on 13. 2. 1..
//  Copyright (c) 2013년 전수열. All rights reserved.
//

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
