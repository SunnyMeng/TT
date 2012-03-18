//
//  UIImageAdditions.h
//  TTUI
//
//  Created by shaohua on 1/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (TTUIAdditions)

- (UIImage *)resizedImageAspectFit:(CGSize)bounds;
- (UIImage *)resizedImageAspectFill:(CGSize)bounds;
- (UIImage *)croppedImage:(CGRect)bounds;
- (UIImage *)grayScaledImage;

+ (id)gradientImage:(CGSize)size locations:(CGFloat [])locations colors:(CGFloat [])colors count:(size_t)count;
+ (id)triangleImage:(CGSize)size color:(UIColor *)color;

@end
