//
//  TTStyledBoxFrame.m
//  TTUI
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTStyledBoxFrame.h"

@implementation TTStyledBoxFrame

@synthesize parentFrame = _parentFrame;
@synthesize firstChildFrame = _firstChildFrame;

- (void)dealloc {
    [_firstChildFrame release];
    [super dealloc];
}

- (void)drawInRect:(CGRect)rect {
    TTStyledFrame *frame = _firstChildFrame;
    while (frame) {
        [frame drawInRect:frame.bounds];
        frame = frame.nextFrame;
    }
}

- (NSString *)description {
    NSString *result = [NSString stringWithFormat:@"%@%@", [self class], [_firstChildFrame description]];
    if (self.nextFrame) {
        result = [result stringByAppendingFormat:@" -> %@", [self.nextFrame description]];
    }
    return result;
}

@end
