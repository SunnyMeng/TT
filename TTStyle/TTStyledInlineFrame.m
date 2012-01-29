//
//  TTStyledInlineFrame.m
//  TTStyle
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTStyledInlineFrame.h"

@implementation TTStyledInlineFrame

@synthesize inlinePreviousFrame = _inlinePreviousFrame;
@synthesize inlineNextFrame = _inlineNextFrame;

- (TTStyledInlineFrame *)inlineParentFrame {
    if ([self.parentFrame isKindOfClass:[TTStyledInlineFrame class]]) {
        return (TTStyledInlineFrame *)self.parentFrame;
    }
    return nil;
}

@end
