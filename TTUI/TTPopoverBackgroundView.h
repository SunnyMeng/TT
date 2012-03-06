//
//  TTPopoverBackgroundView.h
//  TTUI
//
//  Created by shaohua on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface TTPopoverBackgroundView : UIView {
    UIView *_bgView;
    UIImageView *_arrowView;
}

@property (nonatomic) UIPopoverArrowDirection arrowDirection;
@property (nonatomic) CGFloat arrowOffset;

+ (UIEdgeInsets)contentViewInsets;
+ (CGFloat)arrowHeight;
+ (CGFloat)arrowBase;

+ (UIColor *)fillColor;

@end
