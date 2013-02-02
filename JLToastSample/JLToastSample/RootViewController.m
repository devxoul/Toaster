//
//  RootViewController.m
//  JLToastSample
//
//  Created by 전수열 on 13. 2. 2..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "RootViewController.h"
#import "JLToast.h"

@implementation RootViewController

- (id)init
{
	self = [super init];
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	button.frame = CGRectMake( 10, 10, 300, 60 );
	[button setTitle:@"Show" forState:UIControlStateNormal];
	[button addTarget:self action:@selector(showbuttonTouchUpInsideHandler) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:button];
	
	return self;
}

- (void)showbuttonTouchUpInsideHandler
{
	[[JLToast makeText:@"Basic JLToast"] show];
	[[JLToast makeText:@"You can set duration. JLToastShortDelay means 2 seconds. JLToastLongDelay means 3.5 seconds." duration:JLToastLongDelay] show];
	[[JLToast makeText:@"If delay is set, JLToast will be shown after delay." delay:1 duration:5] show];
}

@end
