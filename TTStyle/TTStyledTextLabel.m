//
//  TTStyledTextLabel.m
//  TTUI
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTStyledText.h"
#import "TTStyledTextLabel.h"
#import "UIViewAdditions.h"

@implementation TTStyledTextLabel

@synthesize text = _text;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [_text drawAtPoint:CGPointZero];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _text.width = self.width;
}

- (CGSize)sizeThatFits:(CGSize)size {
    [self layoutIfNeeded];
    return CGSizeMake(_text.width, _text.height);
}

#pragma mark -
#pragma mark Public
- (void)setText:(TTStyledText*)text {
    if (_text != text) {
        _text.delegate = nil;
        [_text release];

        _text = [text retain];
        _text.delegate = self;
        [self setNeedsLayout];
        [self setNeedsDisplay];
    }
}

#pragma mark -
#pragma mark TTStyledTextDelegate
- (void)styledTextNeedsDisplay:(TTStyledText  *)text {
    [self setNeedsDisplay];
}

@end
