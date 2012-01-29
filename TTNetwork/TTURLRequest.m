//
//  TTURLRequest.m
//  TTNetwork
//
//  Created by shaohua on 1/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSArrayAdditions.h"
#import "NSStringAdditions.h"
#import "TTGlobalCore.h"
#import "TTURLRequest.h"
#import "TTURLRequestQueue.h"
#import "JSONKit.h"

@interface TTURLRequest ()

@property (nonatomic, retain) NSDate *timestamp;
@property (nonatomic, retain) NSData *responseData;

@end

@implementation TTURLRequest

@synthesize urlPath = _urlPath;
@synthesize parameters = _parameters;
@synthesize httpMethod = _httpMethod;
@synthesize delegates = _delegates;
@synthesize isLoading = _isLoading;
@synthesize userAgent = _userAgent;
@synthesize contentType = _contentType;
@synthesize authorization = _authorization;
@synthesize timestamp = _timestamp;
@synthesize respondedFromCache = _respondedFromCache;
@synthesize cacheKey = _cacheKey;
@synthesize cachePolicy = _cachePolicy;
@synthesize cacheExpirationAge = _cacheExpirationAge;
@synthesize responseData = _responseData;
@synthesize strongRef = _strongRef;
@synthesize weakRef = _weakRef;

- (id)initWithURL:(NSString *)URL delegate:(id <TTURLRequestDelegate>)delegate {
    if (self = [super init]) {
        _cacheExpirationAge = 60 * 60 * 24 * 7; // 1 week
        _cachePolicy = TTURLRequestReturnCacheDataElseLoad;

        _urlPath = [URL copy];
        _cacheKey = [[URL md5Hash] retain];

        _parameters = [[NSMutableDictionary alloc] init];
        _delegates = TTCreateNonRetainingArray();

        if (delegate) {
            [_delegates addObject:delegate];
        }
    }
    return self;
}

- (void)dealloc {
    [_urlPath release];
    [_cacheKey release];
    [_httpMethod release];
    [_userAgent release];
    [_contentType release];
    [_authorization release];
    [_parameters release];
    [_delegates release];
    [_timestamp release];
    [_responseData release];
    [_strongRef release];
    [super dealloc];
}

#pragma mark -
#pragma mark Public
+ (TTURLRequest *)requestWithURL:(NSString *)URL delegate:(id <TTURLRequestDelegate>)delegate {
    return [[[self alloc] initWithURL:URL delegate:delegate] autorelease];
}

- (void)send {
    [[TTURLRequestQueue mainQueue] sendRequest:self];
}

- (void)cancel {
    [[TTURLRequestQueue mainQueue] cancelRequest:self];
}

- (NSString *)responseString {
    return [[[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding] autorelease];
}

- (UIImage *)responseImage {
    return [UIImage imageWithData:_responseData];
}

- (id)responseObject {
#if __IPHONE_5_0 && __IPHONE_5_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
    if (NSClassFromString(@"NSJSONSerialization")) {
        return [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers error:NULL];
    }
#endif
    return [_responseData mutableObjectFromJSONData];
}

#pragma mark -
#pragma mark TTRequestLoader and TTURLRequestQueue
- (void)dispatchStarted {
    self.timestamp = nil;
    self.responseData = nil;
    _isLoading = YES;
    _respondedFromCache = NO;
    [_delegates perform:@selector(requestDidStartLoad:) withObject:self];
}

- (void)dispatchError:(NSError *)error data:(NSData *)data {
    self.timestamp = nil;
    self.responseData = data;
    _isLoading = NO;
    _respondedFromCache = NO;
    [_delegates perform:@selector(request:didFailLoadWithError:) withObject:self withObject:error];
}

- (void)dispatchLoaded:(NSData *)data timestamp:(NSDate *)timestamp fromCache:(BOOL)fromCache {
    self.timestamp = timestamp;
    self.responseData = data;
    _isLoading = NO;
    _respondedFromCache = fromCache;
    [_delegates perform:@selector(requestDidFinishLoad:) withObject:self];
}

@end
