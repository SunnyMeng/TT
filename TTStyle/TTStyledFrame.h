//
//  TTStyledFrame.h
//  TTStyle
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@class TTStyledElement;
@class TTStyledBoxFrame;

@interface TTStyledFrame : NSObject

@property (nonatomic, retain) TTStyledFrame *nextFrame;

@property (nonatomic) CGRect bounds;

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

- (void)drawInRect:(CGRect)rect;
- (TTStyledBoxFrame *)hitTest:(CGPoint)point;

@end
