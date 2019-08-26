//
//  ScreenObserver.h
//  Toaster
//
//  Created by 홍성호 on 27/08/2019.
//  Copyright © 2019 Suyeol Jeon. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ScreenObserver;
@protocol ScreenObserverDelegate
- (void)screenObserver:(ScreenObserver *)screenObserver statusBarOrientationWillChange:(NSNotification*)notification;
- (void)screenObserver:(ScreenObserver *)screenObserver statusBarOrientationDidChange:(NSNotification*)notification;
- (void)screenObserver:(ScreenObserver *)screenObserver applicationDidBecomeActive:(NSNotification*)notification;
- (void)screenObserver:(ScreenObserver *)screenObserver keyboardWillShow:(NSNotification*)notification;
- (void)screenObserver:(ScreenObserver *)screenObserver keyboardDidHide:(NSNotification*)notification;
@end

@interface ScreenObserver : NSObject
@property (nonatomic, weak) id<ScreenObserverDelegate> delegate;
@property (nonatomic, assign) BOOL didKeyboardShow;
+ (instancetype)shared;
@end

NS_ASSUME_NONNULL_END
