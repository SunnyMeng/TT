//
//  TTStyledInlineFrame.h
//  TTStyle
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTStyledBoxFrame.h"

@interface TTStyledInlineFrame : TTStyledBoxFrame

@property (nonatomic, readonly) TTStyledInlineFrame *inlineParentFrame;
@property (nonatomic, assign) TTStyledInlineFrame *inlinePreviousFrame;
@property (nonatomic, assign) TTStyledInlineFrame *inlineNextFrame;

@end
