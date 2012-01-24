//
//  TTStyledTextLabel.h
//  TTUI
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTStyledTextDelegate.h"

@class TTStyledText;

@interface TTStyledTextLabel : UIView <TTStyledTextDelegate>

@property (nonatomic, retain) TTStyledText *text;

@end
