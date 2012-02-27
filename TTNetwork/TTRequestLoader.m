//
//  TTRequestLoader.m
//  TTNetwork
//
//  Created by shaohua on 1/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSArrayAdditions.h"
#import "TTGlobalNetwork.h"
#import "TTRequestLoader.h"
#import "TTURLRequestInternal.h"
#import "TTURLRequestQueueInternal.h"

@interface TTRequestLoader ()

@property (nonatomic, retain) NSHTTPURLResponse *response;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSURLConnection *connection;

@end


@implementation TTRequestLoader

@synthesize response = _response;
@synthesize responseData = _responseData;
@synthesize connection = _connection;
@synthesize requests = _requests;
@synthesize cachePolicy = _cachePolicy;
@synthesize cacheKey = _cacheKey;
@synthesize cacheExpirationAge = _cacheExpirationAge;

- (id)initForRequest:(TTURLRequest *)request queue:(TTURLRequestQueue *)queue {
    if (self = [super init]) {
        _requests = [[NSMutableArray alloc] init];
        _queue = queue;
        _cacheKey = [request.cacheKey retain];
        _cachePolicy = request.cachePolicy;
        _cacheExpirationAge = request.cacheExpirationAge;
        [self addRequest:request];
    }
    return self;
}

- (void)dealloc {
    [_cacheKey release];
    [_requests release];
    [_response release];
    [_responseData release];
    [_connection release];
    [super dealloc];
}

- (void)addRequest:(TTURLRequest *)request {
    [_requests addObject:request];
}

- (void)load {
    if (_connection) {
        return;
    }

    TTNetworkRequestStarted();

    TTURLRequest *request = [_requests lastObject];
    NSURLRequest *URLRequest = [_queue createNSURLRequest:request];
    self.connection = [[[NSURLConnection alloc] initWithRequest:URLRequest delegate:self startImmediately:NO] autorelease];
    // default runloop mode for NSURLConnection is NSEventTrackingRunLoopMode
    [_connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [_connection start];
}

- (void)dispatchError:(NSError *)error data:(NSData *)data {
    for (TTURLRequest *request in [[_requests copy] autorelease]) {
        [request dispatchError:error data:data];
    }
}

- (void)dispatchLoaded:(NSData *)data timestamp:(NSDate *)timestamp fromCache:(BOOL)fromCache {
    for (TTURLRequest *request in [[_requests copy] autorelease]) {
        [request dispatchLoaded:data timestamp:timestamp fromCache:fromCache];
    }
}

- (void)dispatchAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    for (TTURLRequest *request in [[_requests copy] autorelease]) {
        [request dispatchAuthenticationChallenge:challenge];
    }
}

- (BOOL)cancel:(TTURLRequest *)request {
    NSUInteger requestIndex = [_requests indexOfObject:request];
    if (requestIndex != NSNotFound) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil];
        [self dispatchError:error data:nil];
        [_requests removeObjectAtIndex:requestIndex];
    }

    if (![_requests count]) {
        [_queue loaderDidCancel:self wasLoading:!!_connection];
        if (_connection) {
            TTNetworkRequestStopped();
            [_connection cancel];
            self.connection = nil;
        }
        return NO; // _requests becomes empty
    }
    return YES;
}

- (void)cancel {
    for (id request in [[_requests copy] autorelease]) {
        [self cancel:request];
    }
}

#pragma mark -
#pragma mark NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
    self.response = response;

    int contentLength = 0;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSDictionary *headers = [response allHeaderFields];
        contentLength = [[headers objectForKey:@"Content-Length"] intValue];
    } else {
        contentLength = [response expectedContentLength];
    }

    self.responseData = [NSMutableData dataWithCapacity:contentLength];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    TTNetworkRequestStopped();

    if ([_response isKindOfClass:[NSHTTPURLResponse class]] && [_response statusCode] == 304) {
        [_queue loader:self didLoadUnmodifiedResponse:_response];
    } else {
        [_queue loader:self didLoadResponse:_response data:_responseData];
    }

    self.responseData = nil;
    self.connection = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [_queue loader:self didReceiveAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    TTNetworkRequestStopped();

    self.responseData = nil;
    self.connection = nil;

    [_queue loader:self didFailLoadWithError:error];
}

@end
