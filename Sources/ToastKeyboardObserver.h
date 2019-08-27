//
//  KeyboardObserver.h
//  Toaster
//
//  Created by SeongHo on 27/08/2019.
//  Copyright © 2019 Suyeol Jeon. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToastKeyboardObserver : NSObject
@property (nonatomic, assign) BOOL didKeyboardShow;
+ (instancetype)shared;
@end

NS_ASSUME_NONNULL_END
