//
//  UIImageAdditions.m
//  TTUI
//
//  Created by shaohua on 1/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTGlobalUI.h"
#import "UIImageAdditions.h"

@implementation UIImage (Additions)

- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode bounds:(CGSize)bounds {
    CGFloat horizontalRatio = bounds.width / self.size.width;
    CGFloat verticalRatio = bounds.height / self.size.height;
    CGFloat ratio;
    switch (contentMode) {
        case UIViewContentModeScaleAspectFill:
            ratio = MAX(horizontalRatio, verticalRatio);
            break;
        case UIViewContentModeScaleAspectFit:
            ratio = MIN(horizontalRatio, verticalRatio);
            break;
        default:
            [NSException raise:NSInvalidArgumentException format:@"Unsupported content mode: %d", contentMode];
    }
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, self.size.width * ratio, self.size.height * ratio));
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0);
    [self drawInRect:newRect];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

- (UIImage *)resizedImageAspectFit:(CGSize)bounds {
    if (self.size.width <= bounds.width && self.size.height <= bounds.height) {
        return self;
    }
    return [self resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:bounds];
}

- (UIImage *)resizedImageAspectFill:(CGSize)bounds {
    if (self.size.width <= bounds.width && self.size.height <= bounds.height) {
        return self;
    }

    UIImage *image = self;
    if (self.size.width > bounds.width && self.size.height > bounds.height) {
        image = [self resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:bounds];
        if (CGSizeEqualToSize(image.size, bounds)) {
            return image;
        }
    }

    CGRect cropRect = CGRectMake(0, 0, image.size.width, image.size.height);
    if (image.size.width > bounds.width) {
        cropRect.origin.x = roundf((image.size.width - bounds.width) / 2);
        cropRect.size.width = bounds.width;
    }
    if (image.size.height > bounds.height) {
        cropRect.origin.y = roundf((image.size.height - bounds.height) / 2);
        cropRect.size.height = bounds.height;
    }
    return [image croppedImage:cropRect];
}

- (UIImage *)croppedImage:(CGRect)bounds {
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGRect intersect = CGRectIntegral(CGRectIntersection(rect, bounds));

    if (CGRectIsNull(intersect)) {
        return nil;
    }

    CGRect transformed = CGRectApplyAffineTransform(rect, CGAffineTransformMakeTranslation(-intersect.origin.x, -intersect.origin.y));
    UIGraphicsBeginImageContextWithOptions(intersect.size, NO, 0);
    [self drawInRect:transformed];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

- (UIImage *)grayScaledImage {
    CGFloat w, h;
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            w = self.size.height;
            h = self.size.width;
            break;
        default:
            w = self.size.width;
            h = self.size.height;
    }
    CGRect imageRect = CGRectMake(0, 0, w, h);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 0, colorSpace, kCGImageAlphaNone);
    CGContextDrawImage(context, imageRect, self.CGImage);
    CGImageRef grayImage = CGBitmapContextCreateImage(context);

    CGContextRelease(context);
    context = CGBitmapContextCreate(NULL, w, h, 8, 0, NULL, kCGImageAlphaOnly);
    CGContextDrawImage(context, imageRect, self.CGImage);
    CGImageRef mask = CGBitmapContextCreateImage(context);

    CGImageRef imageRef = CGImageCreateWithMask(grayImage, mask);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];

    CGImageRelease(mask);
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CGImageRelease(grayImage);
    return result;
}

+ (id)gradientImage:(CGSize)size locations:(CGFloat [])locations colors:(CGFloat [])colors count:(size_t)count {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, count);
    CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(0, size.height), 0);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    UIGraphicsEndImageContext();
    return image;
}

@end
