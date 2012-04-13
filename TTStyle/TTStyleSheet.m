//
//  TTStyleSheet.m
//  TTStyle
//
//  Created by shaohua on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTGlobalUI.h"
#import "TTStyleSheet.h"

static TTStyleSheet *gStyleSheet;

@implementation TTStyleSheet

+ (TTStyleSheet *)globalSheet {
    if (!gStyleSheet) {
        gStyleSheet = [[TTStyleSheet alloc] init];
    }
    return gStyleSheet;
}

+ (void)setGlobalSheet:(TTStyleSheet *)globalSheet {
    [gStyleSheet release];
    gStyleSheet = [globalSheet retain];
}

- (UIColor *)linkTextColor {
    return RGBCOLOR(50, 159, 224);
}

- (UIActionSheetStyle)actionSheetStyle {
    return UIActionSheetStyleBlackTranslucent;
}

@end
