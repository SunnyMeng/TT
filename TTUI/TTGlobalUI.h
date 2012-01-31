//
//  TTGlobalUI.h
//  TTUI
//
//  Created by shaohua on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

void TTAlert(NSString *message);

NSString *TTDeviceModelName(void);

CGFloat TTScreenWidth(void);

#define RGBCOLOR(r, g, b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1]
#define RGBACOLOR(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a)]

CGSize TTScaleAspectFit(CGSize size, CGSize bounds);
