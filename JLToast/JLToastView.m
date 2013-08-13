/*
 * JLToastView.m
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

#import "JLToastView.h"
#import <QuartzCore/CALayer.h>

#define JLTOAST_LABEL_FONT_SIZE ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 12 : 16)
#define JLTOAST_OFFSET_PORTRAIT_Y ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 30 : 60)
#define JLTOAST_OFFSET_LANDSCAPE_Y ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 20 : 40)

@implementation JLToastView

- (id)init
{
	self = [super init];
    if( self )
    {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, 100, 100 )];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        _backgroundView.layer.cornerRadius = 5;
        _backgroundView.clipsToBounds = YES;
        [self addSubview:_backgroundView];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, 100, 100 )];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = [UIFont systemFontOfSize:JLTOAST_LABEL_FONT_SIZE];
        _textLabel.numberOfLines = 0;
        [self addSubview:_textLabel];
        
        _textInsets = UIEdgeInsetsMake( 6, 10, 6, 10 );
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
    CGFloat deviceWidth = [UIScreen mainScreen].bounds.size.width;
    
    UIFont *font = _textLabel.font;
	CGSize constraintSize = CGSizeMake( deviceWidth * (280.0f/320.0f), INT_MAX );
	CGSize textLabelSize = [_textLabel.text sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    
	_textLabel.frame = CGRectMake( _textInsets.left, _textInsets.top, textLabelSize.width, textLabelSize.height );
	_backgroundView.frame = CGRectMake( 0, 0,
									   _textLabel.frame.size.width + _textInsets.left + _textInsets.right,
									   _textLabel.frame.size.height + _textInsets.top + _textInsets.bottom );
    
	NSInteger x, y, width, height;
	CGFloat angle;
	switch( [UIDevice currentDevice].orientation )
	{
		case UIDeviceOrientationPortraitUpsideDown:
			width = _backgroundView.frame.size.width;
			height = _backgroundView.frame.size.height;
			x = ([UIScreen mainScreen].bounds.size.width - width) / 2;
			y = JLTOAST_OFFSET_PORTRAIT_Y;
			angle = M_PI;
			break;
            
		case UIDeviceOrientationLandscapeLeft:
			width = _backgroundView.frame.size.height;
			height = _backgroundView.frame.size.width;
			x = JLTOAST_OFFSET_LANDSCAPE_Y;
			y = ([UIScreen mainScreen].bounds.size.height - height) / 2;
			angle = M_PI_2;
			break;
            
		case UIDeviceOrientationLandscapeRight:
			width = _backgroundView.frame.size.height;
			height = _backgroundView.frame.size.width;
			x = [UIScreen mainScreen].bounds.size.width - width - JLTOAST_OFFSET_LANDSCAPE_Y;
			y = ([UIScreen mainScreen].bounds.size.height - height) / 2;
			angle = -M_PI_2;
			break;
            
		default:
			width = _backgroundView.frame.size.width;
			height = _backgroundView.frame.size.height;
			x = ([UIScreen mainScreen].bounds.size.width - width) / 2;
			y = [UIScreen mainScreen].bounds.size.height - height - JLTOAST_OFFSET_PORTRAIT_Y;
			angle = 0;
			break;
            
	}
    
	self.transform = CGAffineTransformMakeRotation( angle );
	self.frame = CGRectMake( x, y, width, height );
}

#pragma mark - hit test

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    //    NSLog(@"%@ hitTest", [self class]);
    return nil;
}

@end
