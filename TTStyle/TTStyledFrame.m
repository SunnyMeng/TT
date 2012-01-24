//
//  TTStyledFrame.m
//  TTUI
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTStyledElement.h"
#import "TTStyledFrame.h"

@implementation TTStyledFrame

@synthesize bounds = _bounds;
@synthesize nextFrame = _nextFrame;

- (void)dealloc {
    [_nextFrame release];
    [super dealloc];
}

- (CGFloat)x {
    return _bounds.origin.x;
}

- (void)setX:(CGFloat)x {
    _bounds.origin.x = x;
}

- (CGFloat)y {
    return _bounds.origin.y;
}

- (void)setY:(CGFloat)y {
    _bounds.origin.y = y;
}

- (CGFloat)width {
    return _bounds.size.width;
}

- (void)setWidth:(CGFloat)width {
    _bounds.size.width = width;
}

- (CGFloat)height {
    return _bounds.size.height;
}

- (void)setHeight:(CGFloat)height {
    _bounds.size.height = height;
}

- (void)drawInRect:(CGRect)rect {
}

- (NSString *)description {
    NSString *result = [NSString stringWithFormat:@"%@%@", [self class], NSStringFromCGRect(_bounds)];
    if (self.nextFrame) {
        result = [result stringByAppendingFormat:@" -> %@", [_nextFrame description]];
    }
    return result;
}

@end
