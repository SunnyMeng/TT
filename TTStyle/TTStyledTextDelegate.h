//
//  TTStyledTextDelegate.h
//  TTStyle
//
//  Created by shaohua on 1/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTStyledText;

@protocol TTStyledTextDelegate <NSObject>
@optional
- (void)styledTextNeedsDisplay:(TTStyledText *)text;
@end
