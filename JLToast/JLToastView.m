/*
 * JLToastView.m
 *
 *            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
 *                    Version 2, December 2004
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
        _textLabel.font = [UIFont systemFontOfSize:12];
        _textLabel.numberOfLines = 0;
        [self addSubview:_textLabel];
        
        _textInsets = UIEdgeInsetsMake( 6, 10, 6, 10 );
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIFont *font = _textLabel.font;
    CGSize constraintSize = CGSizeMake( 280, INT_MAX );
    CGSize textLabelSize = [_textLabel.text sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    _textLabel.frame = (CGRect){{(NSInteger)( 320 - textLabelSize.width ) / 2, [UIScreen mainScreen].bounds.size.height - textLabelSize.height - 30}, textLabelSize};
    _backgroundView.frame = CGRectMake( _textLabel.frame.origin.x - _textInsets.left,
                                       _textLabel.frame.origin.y - _textInsets.top,
                                       _textLabel.frame.size.width + _textInsets.left + _textInsets.right,
                                       _textLabel.frame.size.height + _textInsets.top + _textInsets.bottom );
}

@end
