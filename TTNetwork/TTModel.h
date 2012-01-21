//
//  TTModel.h
//  TT
//
//  Created by shaohua on 1/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TTURLRequestCachePolicy.h"

@protocol TTModel <NSObject>

@property (nonatomic, readonly) NSMutableArray *delegates;

- (BOOL)isLoaded;
- (BOOL)isLoading;
- (BOOL)isEmpty;
- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more;
- (void)cancel;

@end
