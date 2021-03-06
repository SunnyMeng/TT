//
//  TTStyledFrame.m
//  TTStyle
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTStyledElement.h"
#import "TTStyledFrame.h"

@implementation TTStyledFrame

@synthesize parentFrame = _parentFrame;
@synthesize bounds = _bounds;
@synthesize nextFrame = _nextFrame;
@synthesize element = _element;

- (id)initWithElement:(TTStyledElement *)element {
    if (self = [super init]) {
        _element = element;
    }
    return self;
}

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

- (TTStyledBoxFrame *)hitTest:(CGPoint)point {
    return [_nextFrame hitTest:point];
}

- (NSString *)description {
    NSString *result = [NSString stringWithFormat:@"%@@%p<%.0f,%.0f:%.0f,%.0f>", [self class], self, _bounds.origin.x, _bounds.origin.y, _bounds.size.width, _bounds.size.height];
    if (self.nextFrame) {
        result = [result stringByAppendingFormat:@", %@", [_nextFrame description]];
    }
    return result;
}

@end
