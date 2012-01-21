//
//  TTGlobalCore.h
//  TTCore
//
//  Created by shaohua on 1/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

NSMutableArray *TTCreateNonRetainingArray(void);

// CGRectMake(x, y, w - dx, h - dy)
CGRect TTRectContract(CGRect rect, CGFloat dx, CGFloat dy);

// CGRectMake(x + dx, y + dy, w - dx, h - dy)
CGRect TTRectShift(CGRect rect, CGFloat dx, CGFloat dy);
