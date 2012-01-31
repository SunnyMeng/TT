//
//  TTStyledImageFrame.m
//  TTStyle
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTStyledImageFrame.h"
#import "TTStyledImageNode.h"
#import "UIImageAdditions.h"

@implementation TTStyledImageFrame

- (id)initWithNode:(TTStyledImageNode *)node element:(TTStyledElement *)element {
    if (self = [super initWithElement:element]) {
        _node = node;
    }
    return self;
}

- (void)drawInRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGContextAddRect(ctx, rect);
    CGContextClip(ctx);
    [_node.image drawInRect:rect contentMode:UIViewContentModeScaleToFill];
    CGContextRestoreGState(ctx);
}

@end
