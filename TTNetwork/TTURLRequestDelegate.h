//
//  TTURLRequestDelegate.h
//  TTNetwork
//
//  Created by shaohua on 1/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTURLRequest;

@protocol TTURLRequestDelegate <NSObject>

@optional
- (void)requestDidStartLoad:(TTURLRequest *)request;
- (void)requestDidFinishLoad:(TTURLRequest *)request;
- (void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error;
- (void)request:(TTURLRequest *)request didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;

@end
