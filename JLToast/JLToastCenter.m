/*
 * JLToastCenter.m
 *
 *            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
 *                    Version 2, December 2004
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

#import "JLToastCenter.h"
#import "JLToast.h"

@implementation JLToastCenter

+ (id)defaultCenter
{
	static id center = nil;
    static dispatch_once_t onceToken; // It makes singleton object thread-safe
    dispatch_once(&onceToken, ^{
		center = [[JLToastCenter alloc] init];
		[[NSNotificationCenter defaultCenter] addObserver:center selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    });
	return center;
}

- (id)init
{
	self = [super init];
    if( self )
    {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 1;
    }
	return self;
}

- (void)addToast:(JLToast *)toast
{
	[_queue addOperation:toast];
}

- (void)deviceOrientationDidChange:(id)sender
{
	if( _queue.operations.count )
	{
		[[[_queue.operations objectAtIndex:0] view] layoutSubviews];
	}
}

@end
