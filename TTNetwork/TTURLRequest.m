//
//  TTURLRequest.m
//  TTNetwork
//
//  Created by shaohua on 1/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSONKit.h"
#import "NSArrayAdditions.h"
#import "NSStringAdditions.h"
#import "TTGlobalCore.h"
#import "TTURLRequest.h"
#import "TTURLRequestQueue.h"

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
@synthesize httpBody = _httpBody;
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

        _delegates = TTCreateNonRetainingArray();

        if (delegate) {
            [_delegates addObject:delegate];
        }
    }
    return self;
}

- (void)dealloc {
    [_httpBody release];
    [_files release];
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

- (NSString *)boundaryString {
    static NSString *boundry;
    if (!boundry) {
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        boundry = (NSString *)CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
    }
    return boundry;
}

- (NSData *)generatePostBody {
    NSMutableData* body = [NSMutableData data];
    NSData *beginLine = [[NSString stringWithFormat:@"--%@\r\n", [self boundaryString]] dataUsingEncoding:NSUTF8StringEncoding];
    NSData *endLine = [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding];

    for (NSString *key in _parameters) {
        NSString *value = [_parameters valueForKey:key];
        [body appendData:beginLine];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:endLine];
    }

    for (NSInteger i = 0; i < _files.count; i += 4) {
        NSData *data = [_files objectAtIndex:i];
        NSString *mimeType = [_files objectAtIndex:i + 1];
        NSString *name = [_files objectAtIndex:i + 2];
        NSString *fileName = [_files objectAtIndex:i + 3];

        [body appendData:beginLine];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", name, fileName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Length: %d\r\n", [data length]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimeType] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:data];
        [body appendData:endLine];
    }

    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", [self boundaryString]] dataUsingEncoding:NSUTF8StringEncoding]];
    return body;
}

#pragma mark -
#pragma mark Public
+ (TTURLRequest *)requestWithURL:(NSString *)URL delegate:(id <TTURLRequestDelegate>)delegate {
    return [[[self alloc] initWithURL:URL delegate:delegate] autorelease];
}

- (NSData *)httpBody {
    if (_httpBody) {
        return _httpBody;
    }
    if (([_httpMethod isEqualToString:@"POST"] || [_httpMethod isEqualToString:@"PUT"])) {
        return [self generatePostBody];
    }
    return nil;
}

- (NSString *)contentType {
    if (_contentType) {
        return _contentType;
    }
    if ([_httpMethod isEqualToString:@"POST"] || [_httpMethod isEqualToString:@"PUT"]) {
        return [NSString stringWithFormat:@"multipart/form-data; boundary=%@", [self boundaryString]];
    }
    return nil;
}

- (NSMutableDictionary*)parameters {
    if (!_parameters) {
        _parameters = [[NSMutableDictionary alloc] init];
    }
    return _parameters;
}

- (void)addFile:(NSData *)data mimeType:(NSString *)mimeType forKey:(NSString *)name fileName:(NSString *)fileName {
    if (!_files) {
        _files = [[NSMutableArray alloc] init];
    }

    [_files addObject:data];
    [_files addObject:mimeType];
    [_files addObject:name];
    [_files addObject:fileName];
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
