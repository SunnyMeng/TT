//
//  TTURLRequestQueueInternal.h
//  TTNetwork
//
//  Created by shaohua on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTURLRequestQueue.h"

@interface TTURLRequestQueue (Internal)

- (void)loader:(TTRequestLoader *)loader didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
- (void)loader:(TTRequestLoader *)loader didLoadResponse:(NSHTTPURLResponse *)response data:(id)data;
- (void)loader:(TTRequestLoader *)loader didLoadUnmodifiedResponse:(NSHTTPURLResponse *)response;
- (void)loader:(TTRequestLoader *)loader didFailLoadWithError:(NSError *)error;
- (void)loaderDidCancel:(TTRequestLoader *)loader wasLoading:(BOOL)wasLoading;

@end
