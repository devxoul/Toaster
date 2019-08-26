//
//  ScreenObserver.m
//  Toaster
//
//  Created by 홍성호 on 27/08/2019.
//  Copyright © 2019 Suyeol Jeon. All rights reserved.
//

#import "ScreenObserver.h"
#import <UIKit/UIKit.h>

@implementation ScreenObserver

+ (void)load {
    [ScreenObserver shared];
}

+ (instancetype)shared {
    static ScreenObserver *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self
                   selector:@selector(statusBarOrientationWillChange:)
                       name:UIApplicationWillChangeStatusBarFrameNotification
                     object:nil];
        [center addObserver:self
                   selector:@selector(statusBarOrientationDidChange:)
                       name:UIApplicationDidChangeStatusBarOrientationNotification
                     object:nil];
        [center addObserver:self
                   selector:@selector(applicationDidBecomeActive:)
                       name:UIApplicationDidBecomeActiveNotification
                     object:nil];
        [center addObserver:self
                   selector:@selector(keyboardWillShow:)
                       name:UIKeyboardWillShowNotification
                     object:nil];
        [center addObserver:self
                   selector:@selector(keyboardDidHide:)
                       name:UIKeyboardDidHideNotification
                     object:nil];
    }
    return self;
}

- (void)statusBarOrientationWillChange:(NSNotification*)notification {
    [self.delegate screenObserver:self statusBarOrientationWillChange:notification];
}

- (void)statusBarOrientationDidChange:(NSNotification*)notification {
    [self.delegate screenObserver:self statusBarOrientationDidChange:notification];
}

- (void)applicationDidBecomeActive:(NSNotification*)notification {
    [self.delegate screenObserver:self applicationDidBecomeActive:notification];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    self.didKeyboardShow = YES;
    [self.delegate screenObserver:self keyboardWillShow:notification];
}

- (void)keyboardDidHide:(NSNotification*)notification {
    self.didKeyboardShow = NO;
    [self.delegate screenObserver:self keyboardDidHide:notification];
}

@end
