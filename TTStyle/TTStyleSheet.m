//
//  TTStyleSheet.m
//  TTStyle
//
//  Created by shaohua on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTGlobalUI.h"
#import "TTStyleSheet.h"

@implementation TTStyleSheet

+ (TTStyleSheet *)globalSheet {
    static TTStyleSheet *gStyleSheet;
    if (!gStyleSheet) {
        gStyleSheet = [[TTStyleSheet alloc] init];
    }
    return gStyleSheet;
}

- (UIColor *)linkTextColor {
    return RGBCOLOR(50, 159, 224);
}

@end
