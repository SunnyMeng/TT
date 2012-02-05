//
//  TTStyledTextLabel.h
//  TTStyle
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTStyledTextDelegate.h"
#import "TTStyledTextLabelDelegate.h"

@class TTStyledText;
@class TTStyledBoxFrame;

@interface TTStyledTextLabel : UIView <TTStyledTextDelegate> {
    TTStyledBoxFrame *_highlightedFrame;
}

@property (nonatomic, retain) TTStyledText *text;
@property (nonatomic, retain) UIFont *font;
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic) UITextAlignment textAlignment;
@property (nonatomic) UILineBreakMode lineBreakMode;
@property (nonatomic, assign) id <TTStyledTextLabelDelegate> delegate;

@end
