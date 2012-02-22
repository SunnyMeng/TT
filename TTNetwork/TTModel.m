//
//  TTModel.m
//  TTNetwork
//
//  Created by shaohua on 1/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTGlobalCore.h"
#import "TTModel.h"

@implementation TTModel

@synthesize delegates = _delegates;

- (id)init {
    if (self = [super init]) {
        _delegates = TTCreateNonRetainingArray();
    }
    return self;
}

- (void)dealloc {
    [_delegates release];
    [super dealloc];
}

- (BOOL)isLoaded {
    return YES;
}

- (BOOL)isLoading {
    return NO;
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {

}

- (void)cancel {

}

@end
