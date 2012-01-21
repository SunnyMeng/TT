//
//  TTURLRequestQueue.h
//  TTNetwork
//
//  Created by shaohua on 1/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTURLRequest;
@class TTRequestLoader;

@interface TTURLRequestQueue : NSObject {
    NSInteger _totalLoading;
    NSMutableDictionary *_loaders;
    NSMutableArray *_loaderQueue;
}

@property (nonatomic, retain) NSTimer *loaderQueueTimer;

// Public
@property (nonatomic) BOOL suspended;

+ (TTURLRequestQueue *)mainQueue;
- (void)sendRequest:(TTURLRequest *)request;
- (void)cancelRequest:(TTURLRequest *)request;
- (void)cancelRequestsWithDelegate:(id)delegate;
- (NSURLRequest *)createNSURLRequest:(TTURLRequest *)request;

@end
