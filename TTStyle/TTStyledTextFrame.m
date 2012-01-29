//
//  TTStyledTextFrame.m
//  TTStyle
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTStyledTextFrame.h"

@implementation TTStyledTextFrame

@synthesize font = _font;
@synthesize text = _text;
@synthesize textColor = _textColor;

- (id)initWithText:(NSString *)text {
    if (self = [super init]) {
        _text = [text copy];
    }
    return self;
}

- (void)dealloc {
    [_text release];
    [super dealloc];
}

- (void)drawInRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    [_textColor setFill];
    [_text drawInRect:rect withFont:_font lineBreakMode:UILineBreakModeClip];
    CGContextRestoreGState(ctx);
}

@end
