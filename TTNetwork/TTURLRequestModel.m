//
//  TTURLRequestModel.m
//  TTNetwork
//
//  Created by shaohua on 1/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSArrayAdditions.h"
#import "TTGlobalCore.h"
#import "TTURLRequest.h"
#import "TTURLRequestModel.h"
#import "TTURLRequestQueue.h"

@interface TTURLRequestModel ()

@property (nonatomic, retain) TTURLRequest *loadingRequest;

@end


@implementation TTURLRequestModel

@synthesize loadedTime = _loadedTime;
@synthesize loadingRequest = _loadingRequest;

- (void)dealloc {
    [_loadingRequest cancel];

    [_loadingRequest release];
    [_loadedTime release];
    [super dealloc];
}

- (BOOL)isLoaded {
    return !!_loadedTime;
}

- (BOOL)isLoading {
    return !!_loadingRequest;
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
}

- (void)cancel {
    [_loadingRequest cancel];
}

#pragma mark -
#pragma mark TTURLRequestDelegate
- (void)requestDidStartLoad:(TTURLRequest *)request {
    self.loadingRequest = request;
    [_delegates perform:@selector(modelDidStartLoad:) withObject:self];
}

- (void)requestDidFinishLoad:(TTURLRequest *)request {
    self.loadingRequest = nil;
    self.loadedTime = request.timestamp;
    [_delegates perform:@selector(modelDidFinishLoad:) withObject:self];
}

- (void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error {
    self.loadingRequest = nil;
    [_delegates perform:@selector(model:didFailLoadWithError:) withObject:self withObject:error];
}

@end
