//
//  TTStyledLayout.h
//  TTStyle
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TTStyledNode;
@class TTStyledFrame;
@class TTStyledBoxFrame;
@class TTStyledInlineFrame;

@interface TTStyledLayout : NSObject {
    TTStyledNode *_rootNode;

    // bounds of one line
    CGFloat _x;
    CGFloat _height;
    CGFloat _lineWidth;
    CGFloat _lineHeight;

    TTStyledFrame *_lineFirstFrame;
    TTStyledFrame *_lastFrame;
    TTStyledBoxFrame *_topFrame;
    TTStyledInlineFrame *_inlineFrame;
}

// Output
@property (nonatomic, readonly) TTStyledFrame *rootFrame;
@property (nonatomic, retain) NSMutableArray *invalidImages;
@property (nonatomic) CGFloat height;

// Input
@property (nonatomic) CGFloat width;
@property (nonatomic, retain) UIFont *font;
@property (nonatomic) UITextAlignment textAlignment;
@property (nonatomic) UILineBreakMode lineBreakMode;

- (id)initWithRootNode:(TTStyledNode *)rootNode;

- (void)layout;

@end
