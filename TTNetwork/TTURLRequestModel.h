//
//  TTURLRequestModel.h
//  TT
//
//  Created by shaohua on 1/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TTModel.h"
#import "TTURLRequestDelegate.h"

@interface TTURLRequestModel : NSObject <TTModel, TTURLRequestDelegate> {
    NSMutableArray *_delegates;
}

@property (nonatomic, retain) NSDate *loadedTime;
@property (nonatomic, retain) id responseObject;

@end
