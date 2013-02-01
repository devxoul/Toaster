//
//  JLToastView.h
//  SleepIfUCan
//
//  Created by 전수열 on 13. 2. 1..
//  Copyright (c) 2013년 전수열. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLToastView : UIView

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic) UIEdgeInsets textInsets;

@end
