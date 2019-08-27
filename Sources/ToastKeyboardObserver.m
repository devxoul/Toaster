//
//  KeyboardObserver.m
//  Toaster
//
//  Created by SeongHo on 27/08/2019.
//  Copyright © 2019 Suyeol Jeon. All rights reserved.
//

#import "ToastKeyboardObserver.h"
#import <UIKit/UIKit.h>

@implementation ToastKeyboardObserver

+ (void)load {
    [ToastKeyboardObserver shared];
}

+ (instancetype)shared {
    static ToastKeyboardObserver *shared = nil;
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

- (void)keyboardWillShow:(NSNotification*)notification {
    self.didKeyboardShow = YES;
}

- (void)keyboardDidHide:(NSNotification*)notification {
    self.didKeyboardShow = NO;
}

@end
