//
//  TTStyledText.h
//  TTStyle
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "TTURLRequestDelegate.h"

@protocol TTStyledTextDelegate;
@class TTStyledNode;
@class TTStyledFrame;
@class TTStyledBoxFrame;

@interface TTStyledText : NSObject <TTURLRequestDelegate> {
    NSMutableArray *_invalidImages;
}

// parsed by TTStyledTextParser, linked list, container node: TTStyledElement
@property (nonatomic, readonly) TTStyledNode *rootNode;

// laid out by TTStyledLayout, linked list, container node: TTStyledBoxFrame
@property (nonatomic, retain, readonly) TTStyledFrame *rootFrame;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic, retain) UIFont *font;
@property (nonatomic) UITextAlignment textAlignment;
@property (nonatomic) UILineBreakMode lineBreakMode;
@property (nonatomic, assign) id <TTStyledTextDelegate> delegate;

+ (TTStyledText *)textFromXHTML:(NSString *)source;
- (void)drawAtPoint:(CGPoint)point;
- (TTStyledBoxFrame *)hitTest:(CGPoint)point;

@end
