/*
 * JLToast.m
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

#import "JLToast.h"
#import "JLToastView.h"
#import "JLToastCenter.h"
#import <dispatch/dispatch.h>

@implementation JLToast

+ (id)makeText:(NSString *)text
{
	return [JLToast makeText:text delay:0 duration:JLToastShortDelay];
}

+ (id)makeText:(NSString *)text duration:(NSTimeInterval)duration
{
	return [JLToast makeText:text delay:0 duration:duration];
}

+ (id)makeText:(NSString *)text delay:(NSTimeInterval)delay duration:(NSTimeInterval)duration
{
	JLToast *toast = [[JLToast alloc] init];
	toast.text = text;
	toast.delay = delay;
	toast.duration = duration;
	
	return toast;
}

- (id)init
{
	self = [super init];
    if( self )
    {
        _view = [[JLToastView alloc] init];
    }
	return self;
}

- (void)show
{
	[[JLToastCenter defaultCenter] addToast:self];
}

- (void)cancel
{
	
}


#pragma mark -
#pragma mark Getter/Setter

- (NSString *)text
{
	return _view.textLabel.text;
}

- (void)setText:(NSString *)text
{
	_view.textLabel.text = text;
    //	[_view layoutSubviews];
}


#pragma mark -
#pragma mark NSOperation Overriding

- (BOOL)isConcurrent
{
	return YES;
}

- (void)start
{
	if( ![NSThread isMainThread] )
	{
		[self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
		return;
	}
    [super start];
}

- (void)main{
	[self willChangeValueForKey:@"isExecuting"];
	
	_isExecuting = YES;
	
	[self didChangeValueForKey:@"isExecuting"];
	
    dispatch_async(dispatch_get_main_queue(), ^{ // Non-main thread cannot modify user interface
        _view.alpha = 0;
        [[[UIApplication sharedApplication] keyWindow] addSubview:_view];
        [UIView animateWithDuration:0.5 delay:_delay options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _view.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:_duration animations:^{
                _view.alpha = 1.0001;
            } completion:^(BOOL finished) {
                [self finish];
                [UIView animateWithDuration:0.5 animations:^{
                    _view.alpha = 0;
                }];
            }];
        }];
    });
}

- (void)finish
{
	[self willChangeValueForKey:@"isExecuting"];
	[self willChangeValueForKey:@"isFinished"];
	
	_isExecuting = NO;
	_isFinished = YES;
	
	[self didChangeValueForKey:@"isExecuting"];
	[self didChangeValueForKey:@"isFinished"];
}

- (BOOL)isExecuting
{
	return _isExecuting;
}

- (BOOL)isFinished
{
	return _isFinished;
}

@end
