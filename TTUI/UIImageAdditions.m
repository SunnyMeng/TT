//
//  UIImageAdditions.m
//  TTUI
//
//  Created by shaohua on 1/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIImageAdditions.h"

@implementation UIImage (Additions)

- (CGRect)convertRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode {
    if (CGSizeEqualToSize(self.size, rect.size)) {
        return rect;
    }
    switch (contentMode) {
        case UIViewContentModeLeft:
            return CGRectMake(rect.origin.x,
                              rect.origin.y + floor(rect.size.height / 2 - self.size.height / 2),
                              self.size.width, self.size.height);

        case UIViewContentModeRight:
            return CGRectMake(rect.origin.x + (rect.size.width - self.size.width),
                              rect.origin.y + floor(rect.size.height / 2 - self.size.height / 2),
                              self.size.width, self.size.height);

        case UIViewContentModeTop:
            return CGRectMake(rect.origin.x + floor(rect.size.width / 2 - self.size.width / 2),
                              rect.origin.y,
                              self.size.width, self.size.height);

        case UIViewContentModeBottom:
            return CGRectMake(rect.origin.x + floor(rect.size.width / 2 - self.size.width / 2),
                              rect.origin.y + floor(rect.size.height - self.size.height),
                              self.size.width, self.size.height);

        case UIViewContentModeCenter:
            return CGRectMake(rect.origin.x + floor(rect.size.width / 2 - self.size.width / 2),
                              rect.origin.y + floor(rect.size.height / 2 - self.size.height / 2),
                              self.size.width, self.size.height);

        case UIViewContentModeBottomLeft:
            return CGRectMake(rect.origin.x,
                              rect.origin.y + floor(rect.size.height - self.size.height),
                              self.size.width, self.size.height);

        case UIViewContentModeBottomRight:
            return CGRectMake(rect.origin.x + (rect.size.width - self.size.width),
                              rect.origin.y + (rect.size.height - self.size.height),
                              self.size.width, self.size.height);

        case UIViewContentModeTopLeft:
            return CGRectMake(rect.origin.x,
                              rect.origin.y,
                              self.size.width, self.size.height);

        case UIViewContentModeTopRight:
            return CGRectMake(rect.origin.x + (rect.size.width - self.size.width),
                              rect.origin.y,
                              self.size.width, self.size.height);

        case UIViewContentModeScaleAspectFill: {
            CGSize imageSize = self.size;
            if (imageSize.height < imageSize.width) {
                imageSize.width = floor((imageSize.width / imageSize.height) * rect.size.height);
                imageSize.height = rect.size.height;

            } else {
                imageSize.height = floor((imageSize.height/imageSize.width) * rect.size.width);
                imageSize.width = rect.size.width;
            }
            return CGRectMake(rect.origin.x + floor(rect.size.width / 2 - imageSize.width / 2),
                              rect.origin.y + floor(rect.size.height / 2 - imageSize.height / 2),
                              imageSize.width, imageSize.height);
        }

        case UIViewContentModeScaleAspectFit: {
            CGSize imageSize = self.size;
            if (imageSize.height < imageSize.width) {
                imageSize.height = floor((imageSize.height / imageSize.width) * rect.size.width);
                imageSize.width = rect.size.width;

            } else {
                imageSize.width = floor((imageSize.width / imageSize.height) * rect.size.height);
                imageSize.height = rect.size.height;
            }
            return CGRectMake(rect.origin.x + floor(rect.size.width / 2 - imageSize.width / 2),
                              rect.origin.y + floor(rect.size.height / 2 - imageSize.height / 2),
                              imageSize.width, imageSize.height);
        }
        case UIViewContentModeRedraw:
        case UIViewContentModeScaleToFill:
            return rect;
    }
}

- (void)drawInRect:(CGRect)rect contentMode:(UIViewContentMode)contentMode {
    BOOL clip = NO;
    CGRect originalRect = rect;
    if (!CGSizeEqualToSize(self.size, rect.size)) {
        clip = contentMode != UIViewContentModeScaleAspectFill
            && contentMode != UIViewContentModeScaleAspectFit;
        rect = [self convertRect:rect withContentMode:contentMode];
    }

    CGContextRef context = UIGraphicsGetCurrentContext();
    if (clip) {
        CGContextSaveGState(context);
        CGContextAddRect(context, originalRect);
        CGContextClip(context);
    }

    [self drawInRect:rect];

    if (clip) {
        CGContextRestoreGState(context);
    }
}

@end
