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

@property (nonatomic, readwrite) UIPopoverArrowDirection arrowDirection;
@property (nonatomic, readwrite) CGFloat arrowOffset;

+ (UIEdgeInsets)contentViewInsets;
+ (CGFloat)arrowHeight;
+ (CGFloat)arrowBase;

@end
