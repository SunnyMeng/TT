//
//  TTURLRequest.h
//  TTNetwork
//
//  Created by shaohua on 1/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "TTURLRequestCachePolicy.h"

@protocol TTURLRequestDelegate;

@interface TTURLRequest : NSObject {
    NSMutableArray *_files;
}

// configurable
@property (nonatomic, readonly) NSString *urlPath;
@property (nonatomic, readonly) NSString *cacheKey;
@property (nonatomic, readonly) NSMutableArray *delegates;
@property (nonatomic) TTURLRequestCachePolicy cachePolicy;
@property (nonatomic) NSTimeInterval cacheExpirationAge;

// headers
@property (nonatomic, retain) NSString *httpMethod;
@property (nonatomic, retain) NSString *userAgent;
@property (nonatomic, retain) NSString *contentType;
@property (nonatomic, retain) NSString *authorization;

@property (nonatomic, readonly) NSMutableDictionary *parameters; // for POST and PUT only
@property (nonatomic, retain) NSData *httpBody;

// store user info to identify a request
@property (nonatomic, retain) id strongRef;
@property (nonatomic, assign) id weakRef;

// outputs
@property (nonatomic, readonly, retain) NSDate *timestamp;
@property (nonatomic, readonly) BOOL isLoading;
@property (nonatomic, readonly) BOOL respondedFromCache;
@property (nonatomic, readonly, retain) NSData *responseData;

+ (TTURLRequest *)requestWithURL:(NSString *)URL delegate:(id <TTURLRequestDelegate>)delegate;
- (void)addFile:(NSData *)data mimeType:(NSString *)mimeType forKey:(NSString *)name fileName:(NSString *)fileName;

// shortcuts
- (void)send;
- (void)cancel;

- (NSString *)responseString;
- (UIImage *)responseImage;
- (id)responseObject;

@end
