//
//  RootViewController.m
//  ToasterDemoObjC
//
//  Created by Antoine Cœur on 2019/4/4.
//  Copyright © 2019 Suyeol Jeon. All rights reserved.
//

#import "RootViewController.h"
@import Toaster;

@interface RootViewController ()

@end

@interface RespondingButton : UIButton<UIKeyInput>

@property(assign, nonatomic) BOOL hasText;
@property(assign, nonatomic) UITextAutocorrectionType autocorrectionType;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Show" forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self action:@selector(showButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    button.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    button.center = CGPointMake(self.view.center.x, 75);
    [self.view addSubview:button];
    
    RespondingButton *keyboardButton = [RespondingButton buttonWithType:UIButtonTypeSystem];
    [keyboardButton setTitle:@"Toggle keyboard" forState:UIControlStateNormal];
    [keyboardButton sizeToFit];
    [keyboardButton addTarget:self action:@selector(keyboardButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    keyboardButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    keyboardButton.center = CGPointMake(self.view.center.x, 125);
    [self.view addSubview:keyboardButton];
    
    [self configureAppearance];
    [self configureAccessibility];
}

- (void)configureAppearance {
    ToastView *appearance = [ToastView appearance];
    appearance.backgroundColor = UIColor.lightGrayColor;
    appearance.textColor = UIColor.blackColor;
    appearance.font = [UIFont boldSystemFontOfSize: 16];
    appearance.textInsets = UIEdgeInsetsMake(15, 20, 15, 20);
    appearance.bottomOffsetPortrait = 100;
    appearance.cornerRadius = 20;
}

- (void)configureAccessibility {
    [ToastCenter default].isSupportAccessibility = YES;
}

- (void)showButtonTouchUpInside {
    [[[Toast alloc] initWithText:@"Basic Toast" delay:0 duration:Delay.Short] show];
    [[[Toast alloc] initWithAttributedText:[[NSAttributedString alloc] initWithString:@"AttributedString Toast" attributes:@{NSBackgroundColorAttributeName: [UIColor yellowColor]}] delay:0 duration:Delay.Short] show];
    [[[Toast alloc] initWithText:@"You can set duration. `Delay.Short` means 2 seconds.\n`Delay.Long` means 3.5 seconds." delay:0 duration:Delay.Long] show];
    [[[Toast alloc] initWithText:@"With delay, Toaster will be shown after delay." delay:1 duration:5] show];
}

- (void)keyboardButtonTouchUpInside:(RespondingButton *)sender {
    if (sender.isFirstResponder) {
        [sender resignFirstResponder];
    } else {
        [sender becomeFirstResponder];
    }
}

@end

@implementation RespondingButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.hasText = YES;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    return self;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)insertText:(nonnull NSString *)text {}
- (void)deleteBackward {}

@end
