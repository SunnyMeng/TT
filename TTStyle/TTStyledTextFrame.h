//
//  TTStyledTextFrame.h
//  TTStyle
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTStyledFrame.h"

@class TTStyledElement;
@class TTStyledTextNode;

@interface TTStyledTextFrame : TTStyledFrame

@property (nonatomic, readonly) NSString *text;
@property (nonatomic, retain) UIFont *font;
@property (nonatomic, retain) UIColor *textColor;

- (id)initWithText:(NSString *)text;

@end
