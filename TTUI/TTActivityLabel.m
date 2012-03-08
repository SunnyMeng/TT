//
//  TTActivityLabel.m
//  msnsf
//
//  Created by shaohua on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTActivityLabel.h"
#import "TTGlobalUI.h"
#import "UIViewAdditions.h"

@implementation TTActivityLabel

- (id)initWithStyle:(UIActivityIndicatorViewStyle)style text:(NSString *)text {
    if (self = [super init]) {
        _label = [[UILabel alloc] init];
        _label.text = text;
        _label.font = [UIFont systemFontOfSize:17];
        _label.textAlignment = UITextAlignmentCenter;
        [_label sizeToFit];

        _label.textColor = RGBCOLOR(99, 109, 125);
        [self addSubview:_label];

        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
        [_indicatorView startAnimating];
        [self addSubview:_indicatorView];
    }
    return self;
}

- (void)dealloc {
    [_label release];
    [_indicatorView release];
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _label.center = CGPointMake(self.width / 2, self.height / 2);
    _indicatorView.right = _label.left - 5;
    _indicatorView.centerY = _label.centerY;
}

@end
