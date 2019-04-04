//
//  AppDelegate.m
//  ToasterDemoObjC
//
//  Created by Antoine Cœur on 2019/4/4.
//  Copyright © 2019 Suyeol Jeon. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = UIColor.whiteColor;
    self.window.rootViewController = [RootViewController new];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
