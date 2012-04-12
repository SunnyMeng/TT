//
//  TTStyledFrame.h
//  TTStyle
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

/*
 a tree of TTStyledNode -> TTStyledLayout -> a tree of TTStyledFrame

 TTStyledFrame
 │
 ├─TTStyledTextFrame (leaf node)
 │
 ├─TTStyledImageFrame (leaf node)
 │
 └─TTStyledBoxFrame (container)
    │
    └─TTStyledInlineFrame

 */

@class TTStyledElement;
@class TTStyledBoxFrame;

@interface TTStyledFrame : NSObject

@property (nonatomic, assign) TTStyledBoxFrame *parentFrame;
@property (nonatomic, retain) TTStyledFrame *nextFrame;
@property (nonatomic, readonly) TTStyledElement *element;

@property (nonatomic) CGRect bounds;

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

- (id)initWithElement:(TTStyledElement *)element;
- (void)drawInRect:(CGRect)rect;
- (TTStyledBoxFrame *)hitTest:(CGPoint)point;

@end
