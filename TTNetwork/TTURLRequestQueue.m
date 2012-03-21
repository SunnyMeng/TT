//
//  TTURLRequestQueue.m
//  TTNetwork
//
//  Created by shaohua on 1/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSArrayAdditions.h"
#import "TTRequestLoader.h"
#import "TTURLCache.h"
#import "TTURLRequestInternal.h"
#import "TTURLRequestQueue.h"

static const NSInteger kMaxConcurrentLoads = 1;

@implementation TTURLRequestQueue

@synthesize loaderQueueTimer = _loaderQueueTimer;
@synthesize suspended = _suspended;

- (id)init {
    if (self = [super init]) {
        _loaders = [[NSMutableDictionary alloc] init];
        _loaderQueue = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [_loaders release];
    [_loaderQueue release];
    [_loaderQueueTimer release];
    [super dealloc];
}

- (void)executeLoader:(TTRequestLoader *)loader {
    ++_totalLoading;
    [loader load];
}

- (void)removeLoader:(TTRequestLoader *)loader {
    --_totalLoading;
    [_loaders removeObjectForKey:loader.cacheKey];
}

- (void)loadNextInQueue {
    for (int i = 0; i < kMaxConcurrentLoads && _totalLoading < kMaxConcurrentLoads && [_loaderQueue count]; ++i) {
        TTRequestLoader *loader = [[_loaderQueue objectAtIndex:0] retain];
        [_loaderQueue removeObjectAtIndex:0];
        [self executeLoader:loader];
        [loader release];
    }

    if ([_loaderQueue count] && !_suspended) {
        self.loaderQueueTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(loadNextInQueue) userInfo:nil repeats:NO];
    }
}

#pragma mark -
#pragma mark Public
- (void)setSuspended:(BOOL)isSuspended {
    _suspended = isSuspended;

    if (!_suspended) {
        [self loadNextInQueue];

    } else if (_loaderQueueTimer) {
        [_loaderQueueTimer invalidate];
        self.loaderQueueTimer = nil;
    }
}

+ (TTURLRequestQueue *)mainQueue {
    static TTURLRequestQueue *gMainQueue;
    if (!gMainQueue) {
        gMainQueue = [[TTURLRequestQueue alloc] init];
    }
    return gMainQueue;
}

- (void)sendRequest:(TTURLRequest *)request {
    if ([request.urlPath length]) {
        NSURL *URL = [NSURL URLWithString:request.urlPath];
        if ([URL isFileURL]) {
            NSData *data = [NSData dataWithContentsOfURL:URL];
            if (data) {
                [request dispatchLoaded:data timestamp:nil fromCache:YES];
            } else {
                NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:nil];
                [request dispatchError:error data:nil];
            }
            // file:// URI scheme is always handled synchronously (appears already cached)
            return;
        }
    } else {
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadURL userInfo:nil];
        [request dispatchError:error data:nil];
        return;
    }

    if (request.cachePolicy != TTURLRequestReloadIgnoringCacheData && request.cachePolicy != TTURLRequestReloadUsingCacheData) {
        NSDate *timestamp = nil;
        NSData *data = [[TTURLCache sharedCache] dataForKey:request.cacheKey expires:request.cacheExpirationAge timestamp:&timestamp];
        if (data) {
            [request dispatchLoaded:data timestamp:timestamp fromCache:YES];
        }
        if (data ? request.cachePolicy != TTURLRequestReturnCacheDataThenLoad : request.cachePolicy == TTURLRequestReturnCacheDataDontLoad) {
            return;
        }
    }

    [request dispatchStarted];

    // GET requests with same urlPath share one loader
    if (!request.httpMethod || [request.httpMethod isEqualToString:@"GET"]) {
        TTRequestLoader *loader = [_loaders objectForKey:request.cacheKey];
        if (loader) {
            [loader addRequest:request];
            return;
        }
    }

    TTRequestLoader *loader = [[[TTRequestLoader alloc] initForRequest:request queue:self] autorelease];
    [_loaders setObject:loader forKey:request.cacheKey];
    if (_suspended || _totalLoading >= kMaxConcurrentLoads) {
        [_loaderQueue addObject:loader];
    } else {
        ++_totalLoading;
        [loader load];
    }
}

- (void)cancelRequest:(TTURLRequest *)request {
    if (request) {
        TTRequestLoader *loader = [_loaders objectForKey:request.cacheKey];
        if (loader) {
            [loader retain];
            if (![loader cancel:request]) {
                [_loaderQueue removeObject:loader];
            }
            [loader release];
        }
    }
}

- (void)cancelRequestsWithDelegate:(id)delegate {
    NSMutableArray *requestsToCancel = nil;

    for (TTRequestLoader *loader in [_loaders allValues]) {
        for (TTURLRequest *request in loader.requests) {
            for (id <TTURLRequestDelegate> requestDelegate in request.delegates) {
                if (delegate == requestDelegate) {
                    if (!requestsToCancel) {
                        requestsToCancel = [NSMutableArray array];
                    }
                    [requestsToCancel addObject:request];
                    break;
                }
            }
        }
    }

    for (TTURLRequest *request in requestsToCancel) {
        [self cancelRequest:request];
    }
}

- (NSURLRequest *)createNSURLRequest:(TTURLRequest *)request {
    NSURL *URL = [NSURL URLWithString:request.urlPath];
    NSTimeInterval defaultTimeout = 60; // seconds

    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:URL
                                                              cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                          timeoutInterval:defaultTimeout];

    NSString *httpMethod = request.httpMethod;
    if ([httpMethod length]) {
        [URLRequest setHTTPMethod:httpMethod];
    }

    NSString *userAgent = request.userAgent;
    if ([userAgent length]) {
        [URLRequest setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    }

    NSString *contentType = request.contentType;
    if ([contentType length]) {
        [URLRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
    }

    NSString *authorization = request.authorization;
    if ([authorization length]) {
        [URLRequest setValue:authorization forHTTPHeaderField:@"Authorization"];
    }

    NSData *httpBody = request.httpBody;
    if (httpBody) {
        [URLRequest setHTTPBody:httpBody];
    }

    // conditional GET if possible
    if (request.cachePolicy != TTURLRequestReloadIgnoringCacheData) {
        // If-None-Match (ETag)
        NSString *etag = [[TTURLCache sharedCache] etagForKey:request.cacheKey];
        if ([etag length] && [[TTURLCache sharedCache] hasDataForKey:request.cacheKey expires:INFINITY]) {
            [URLRequest setValue:etag forHTTPHeaderField:@"If-None-Match"];
        }
        // If-Modified-Since (Last-Modified)
        NSString *mtime = [[TTURLCache sharedCache] mtimeForKey:request.cacheKey];
        if ([mtime length] && [[TTURLCache sharedCache] hasDataForKey:request.cacheKey expires:INFINITY]) {
            [URLRequest setValue:mtime forHTTPHeaderField:@"If-Modified-Since"];
        }
    }

    return URLRequest;
}

#pragma mark -
#pragma mark TTRequestLoader Callbacks
- (void)loader:(TTRequestLoader *)loader didLoadResponse:(NSHTTPURLResponse *)response data:(id)data {
    [loader retain];
    [self removeLoader:loader];

    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSInteger statusCode = [response statusCode];
        if (statusCode >= 200 && statusCode < 300) {
            // cache response with meta data
            if (loader.cachePolicy != TTURLRequestReloadIgnoringCacheData) {
                NSDictionary *headers = [response allHeaderFields];
                NSString *etag = [headers objectForKey:@"ETag"] ?: [headers objectForKey:@"Etag"];
                if ([etag length]) {
                    [[TTURLCache sharedCache] storeEtag:etag forKey:loader.cacheKey];
                }
                NSString *mtime = [headers objectForKey:@"Last-Modified"];
                if ([mtime length]) {
                    [[TTURLCache sharedCache] storeMtime:mtime forKey:loader.cacheKey];
                }
                if ([etag length] || [mtime length]) {
                    [[TTURLCache sharedCache] storeData:data forKey:loader.cacheKey];
                }
            }
            [loader dispatchLoaded:data timestamp:[NSDate date] fromCache:NO];
        } else {
            [loader dispatchError:[NSError errorWithDomain:NSURLErrorDomain code:statusCode userInfo:nil] data:data];
        }
    } else {
        // response of file://
        [loader dispatchLoaded:data timestamp:[NSDate date] fromCache:NO];
    }

    [loader release];
    [self loadNextInQueue];
}


- (void)loader:(TTRequestLoader *)loader didLoadUnmodifiedResponse:(NSHTTPURLResponse *)response {
    [loader retain];
    [self removeLoader:loader];

    NSData *data = [[TTURLCache sharedCache] dataForKey:loader.cacheKey expires:INFINITY timestamp:NULL];
    if (data) {
        NSDate *timestamp = [[TTURLCache sharedCache] touchDataForKey:loader.cacheKey];
        [loader dispatchLoaded:data timestamp:timestamp fromCache:NO];
    } else {
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:nil];
        [loader dispatchError:error data:nil];
    }

    [loader release];
    [self loadNextInQueue];
}

- (void)loader:(TTRequestLoader *)loader didReceiveAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge {
    [loader dispatchAuthenticationChallenge:challenge];
}


- (void)loader:(TTRequestLoader *)loader didFailLoadWithError:(NSError *)error {
    [self removeLoader:loader];
    [loader dispatchError:error data:nil];
    [self loadNextInQueue];
}


- (void)loaderDidCancel:(TTRequestLoader *)loader wasLoading:(BOOL)wasLoading {
    if (wasLoading) {
        [self removeLoader:loader];
        [self loadNextInQueue];
    } else {
        [_loaders removeObjectForKey:loader.cacheKey];
    }
}

@end
