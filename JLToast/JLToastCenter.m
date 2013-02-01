//
//  JLToastCenter.m
//  SleepIfUCan
//
//  Created by 전수열 on 13. 2. 1..
//  Copyright (c) 2013년 전수열. All rights reserved.
//

#import "JLToastCenter.h"
#import "JLToast.h"

@implementation JLToastCenter

+ (id)defaultCenter
{
	static id center = nil;
	if( !center )
		center = [[JLToastCenter alloc] init];
	return center;
}

- (id)init
{
	self = [super init];
	_queue = [[NSOperationQueue alloc] init];
	_queue.maxConcurrentOperationCount = 1;
	return self;
}

- (void)addToast:(JLToast *)toast
{
	[_queue addOperation:toast];
}

@end
