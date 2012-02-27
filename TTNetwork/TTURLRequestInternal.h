//
//  TTURLRequestInternal.h
//  TTNetwork
//
//  Created by shaohua on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTURLRequest.h"

@interface TTURLRequest (Internal)

- (void)dispatchStarted;
- (void)dispatchError:(NSError *)error data:(NSData *)data;
- (void)dispatchLoaded:(NSData *)data timestamp:(NSDate *)timestamp fromCache:(BOOL)fromCache;
- (void)dispatchAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;

@end
