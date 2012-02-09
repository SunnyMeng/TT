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
    UIGraphicsBeginImageContext(newRect.size);
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

    cropRect = CGRectApplyAffineTransform(cropRect, CGAffineTransformMakeScale(self.scale, self.scale));
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, cropRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    return croppedImage;
}

@end
