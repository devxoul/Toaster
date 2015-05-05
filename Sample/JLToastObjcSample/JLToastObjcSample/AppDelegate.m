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

#import <JLToastObjcSample-Swift.h>
#import "JLToast.h"
#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(10, 10, 300, 60);
    [button setTitle:@"Show" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:button];
    
    return YES;
}

- (void)showButtonTouchUpInside
{
    
    [[JLToast makeText:@"Basic JLToast"] show];
    [[JLToast makeText:@"You can set duration. `JLToastDelay.ShortDelay` means 2 seconds.\n"
                        "JLToastDelay.LongDelay` means 3.5 seconds." duration:JLToastLongDelay] show];
    [[JLToast makeText:@"With delay, JLToast will be shown after delay." delay:1 duration:5] show];
}

@end
