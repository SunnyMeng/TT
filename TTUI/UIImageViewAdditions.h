//
//  UIImageViewAdditions.h
//  TTUI
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIImageViewDelegate <NSObject>

@optional
- (void)imageViewDidStartLoad:(UIImageView *)imageView;
- (void)imageView:(UIImageView *)imageView didLoadImage:(UIImage *)image;
- (void)imageView:(UIImageView *)imageView didFailLoadWithError:(NSError *)error;

@end

@interface UIImageView (TTUIAdditions)

- (void)setImageWithURL:(NSString *)urlPath placeholder:(UIImage *)placeholder delegate:(id <UIImageViewDelegate>)delegate;
- (void)cancelImageLoading;

@end
