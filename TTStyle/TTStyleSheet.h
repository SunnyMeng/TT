//
//  TTStyleSheet.h
//  TTStyle
//
//  Created by shaohua on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TTStyleSheet : NSObject

@property (nonatomic, readonly) UIColor *linkTextColor;
@property (nonatomic, readonly) UIActionSheetStyle actionSheetStyle;

+ (TTStyleSheet *)globalSheet;
+ (void)setGlobalSheet:(TTStyleSheet *)globalSheet;

@end
