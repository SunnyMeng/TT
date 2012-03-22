//
//  UIImageViewAdditions.m
//  TTUI
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTURLCache.h"
#import "TTURLRequest.h"
#import "TTURLRequestQueue.h"
#import "UIImageViewAdditions.h"

@implementation UIImageView (Additions)

- (void)setImageWithURL:(NSString *)urlPath placeholder:(UIImage *)placeholder delegate:(id <UIImageViewDelegate>)delegate {
    UIImage *image = [[TTURLCache sharedCache] imageForURL:urlPath];
    if (image) {
        self.image = image;
    } else {
        self.image = placeholder;

        [self cancelImageLoading];
        TTURLRequest *request = [TTURLRequest requestWithURL:urlPath delegate:(id <TTURLRequestDelegate>)self];
        request.cachePolicy = TTURLRequestReturnCacheDataElseLoad;
        request.cacheExpirationAge = INFINITY;
        request.weakRef = delegate;
        [request send];
    }
}

- (void)cancelImageLoading {
    [[TTURLRequestQueue mainQueue] cancelRequestsWithDelegate:self];
}

#pragma mark -
#pragma mark TTURLRequestDelegate
- (void)requestDidStartLoad:(TTURLRequest *)request {
    if ([request.weakRef respondsToSelector:@selector(imageViewDidStartLoad:)]) {
        [request.weakRef imageViewDidStartLoad:self];
    }
}

- (void)requestDidFinishLoad:(TTURLRequest *)request {
    self.image = [request responseImage];
    if ([request.weakRef respondsToSelector:@selector(imageView:didLoadImage:)]) {
        [request.weakRef imageView:self didLoadImage:self.image];
    }
}

- (void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error {
    if ([request.weakRef respondsToSelector:@selector(imageView:didFailLoadWithError:)]) {
        [request.weakRef imageView:self didFailLoadWithError:error];
    }
}

@end
