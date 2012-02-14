//
//  TTPopoverController.h
//  TTUI
//
//  Created by shaohua on 5/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTPopoverBackgroundView;

@interface TTPopoverController : NSObject {
    UIViewController *_contentViewController;
    CGSize _popoverContentSize;
    BOOL _popoverVisible;
    UITapGestureRecognizer *_tapGesture;
}

@property (nonatomic) CGSize popoverContentSize;
@property (nonatomic, retain) UIViewController *contentViewController;
@property (nonatomic, readonly, getter=isPopoverVisible) BOOL popoverVisible;
@property (nonatomic, retain) Class popoverBackgroundViewClass;
@property (nonatomic) UIEdgeInsets popoverLayoutMargins;

- (id)initWithContentViewController:(UIViewController *)viewController;
- (void)setPopoverContentSize:(CGSize)size animated:(BOOL)animated;

- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)item arrowDirection:(UIPopoverArrowDirection)arrowDirection animated:(BOOL)animated;
- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view arrowDirection:(UIPopoverArrowDirection)arrowDirection animated:(BOOL)animated;
- (void)dismissPopoverAnimated:(BOOL)animated;

@end
