//
//  TTGlobalStyle.h
//  TTStyle
//
//  Created by shaohua on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#import "TTStyleSheet.h"

void TTAddRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight);


#define TTSTYLEVAR(_VARNAME) [[TTStyleSheet globalSheet] _VARNAME]
