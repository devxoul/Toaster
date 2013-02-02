/*
 * RootViewController.m
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
