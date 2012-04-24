//
//  TTRequestLoader.h
//  TTNetwork
//
//  Created by shaohua on 1/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TTURLRequestCachePolicy.h"

@class TTURLRequest;
@class TTURLRequestQueue;

@interface TTRequestLoader : NSObject {
    TTURLRequestQueue *_queue; // weakref
}

@property (nonatomic, readonly) NSMutableArray *requests;

@property (nonatomic, readonly) NSString *cacheKey;
@property (nonatomic, readonly) TTURLRequestCachePolicy cachePolicy;
@property (nonatomic, readonly) NSTimeInterval cacheExpirationAge;

// Public
- (id)initForRequest:(TTURLRequest *)request queue:(TTURLRequestQueue *)queue;
- (void)addRequest:(TTURLRequest *)request;
- (void)load;
- (void)dispatchError:(NSError *)error data:(NSData *)data;
- (void)dispatchLoaded:(NSData *)data timestamp:(NSDate *)timestamp fromCache:(BOOL)fromCache;
- (BOOL)cancel:(TTURLRequest *)request;
- (void)cancel;

@end
