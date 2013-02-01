//
//  JLToastCenter.h
//  SleepIfUCan
//
//  Created by 전수열 on 13. 2. 1..
//  Copyright (c) 2013년 전수열. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JLToast;

@interface JLToastCenter : NSObject
{
	NSOperationQueue *_queue;
}

+ (id)defaultCenter;

- (void)addToast:(JLToast *)toast;

@end
