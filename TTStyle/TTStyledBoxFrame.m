//
//  TTStyledBoxFrame.m
//  TTStyle
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTGlobalStyle.h"
#import "TTStyledBoxFrame.h"

@implementation TTStyledBoxFrame

@synthesize firstChildFrame = _firstChildFrame;
@synthesize highlighted = _highlighted;

- (void)dealloc {
    [_firstChildFrame release];
    [super dealloc];
}

- (void)drawInRect:(CGRect)rect {
    if (_highlighted && !CGRectIsEmpty(self.bounds)) {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGFloat oval = MIN(self.width, self.height) /  5;
        TTAddRoundedRectToPath(ctx, self.bounds, oval, oval);

        CGContextSaveGState(ctx);
        [[UIColor colorWithWhite:0.7294 alpha:1] setFill];
        CGContextFillPath(ctx);
        CGContextRestoreGState(ctx);
    }

    TTStyledFrame *frame = _firstChildFrame;
    while (frame) {
        [frame drawInRect:frame.bounds];
        frame = frame.nextFrame;
    }
}

- (TTStyledBoxFrame *)hitTest:(CGPoint)point {
    if (CGRectContainsPoint(self.bounds, point)) {
        TTStyledBoxFrame *frame = [_firstChildFrame hitTest:point];
        return frame ?: self;
    } else if (self.nextFrame) {
        return [self.nextFrame hitTest:point];
    } else {
        return nil;
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"{%@}%@", _firstChildFrame, [super description]];
}

@end
