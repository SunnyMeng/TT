//
//  TTPopoverBackgroundView.m
//  TTUI
//
//  Created by shaohua on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTPopoverBackgroundView.h"
#import "UIImageAdditions.h"
#import "UIViewAdditions.h"

@implementation TTPopoverBackgroundView

@synthesize arrowDirection = _arrowDirection;
@synthesize arrowOffset = _arrowOffset;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIColor *fillColor = [[self class] fillColor];
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = fillColor;
        _bgView.layer.cornerRadius = 10;
        _bgView.layer.shadowOffset = CGSizeMake(0, 5);
        _bgView.layer.shadowRadius = 10;
        _bgView.layer.shadowOpacity = .5;
        [self addSubview:_bgView];

        CGFloat w = [[self class] arrowBase];
        CGFloat h = [[self class] arrowHeight];
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage triangleImage:CGSizeMake(w, h) color:fillColor]];
        [self addSubview:_arrowView];
    }
    return self;
}

- (void)dealloc {
    [_bgView release];
    [_arrowView release];
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    NSAssert(_arrowDirection == UIPopoverArrowDirectionUp, @"other directions not supported yet");
    _arrowView.centerX = self.width / 2 + _arrowOffset;

    _bgView.top = _arrowView.bottom;
    _bgView.width = self.width;
    _bgView.height = self.height - _arrowView.height;
}

+ (UIEdgeInsets)contentViewInsets {
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

+ (CGFloat)arrowHeight {
    return 6;
}

+ (CGFloat)arrowBase {
    return 12;
}

+ (UIColor *)fillColor {
    return [UIColor colorWithRed:0.2078 green:0.2353 blue:0.2431 alpha:1];
}

@end
