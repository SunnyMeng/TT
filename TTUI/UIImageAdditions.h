//
//  UIImageAdditions.h
//  TTUI
//
//  Created by shaohua on 1/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (Additions)

- (UIImage *)resizedImageAspectFit:(CGSize)bounds;
- (UIImage *)resizedImageAspectFill:(CGSize)bounds;
- (UIImage *)croppedImage:(CGRect)bounds;

@end
