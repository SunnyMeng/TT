//
//  TTPopoverController.m
//  TTUI
//
//  Created by shaohua on 5/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TTPopoverBackgroundView.h"
#import "TTPopoverController.h"
#import "UIViewAdditions.h"

@interface TTPopoverController ()

@property (nonatomic, retain) TTPopoverBackgroundView *bgView;
@property (nonatomic, retain) UIWindow *popoverWindow;

@end


@implementation TTPopoverController

@synthesize contentViewController = _contentViewController;
@synthesize popoverContentSize = _popoverContentSize;
@synthesize popoverVisible = _popoverVisible;
@synthesize popoverBackgroundViewClass = _popoverBackgroundViewClass;
@synthesize bgView = _bgView;
@synthesize popoverWindow = _popoverWindow;
@synthesize popoverLayoutMargins = _popoverLayoutMargins;

- (id)initWithContentViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        _contentViewController = [viewController retain];
        _popoverContentSize = [viewController contentSizeForViewInPopover];
        _popoverLayoutMargins = UIEdgeInsetsMake(4, 4, 4, 4);
        _popoverBackgroundViewClass = [TTPopoverBackgroundView class];
    }
    return self;
}

- (void)dealloc {
    [_bgView release];
    [_popoverWindow release];
    [_contentViewController release];
    [_tapGesture release];
    [super dealloc];
}

- (void)setPopoverContentSize:(CGSize)size animated:(BOOL)animated {
    _popoverContentSize = size;

    [UIView animateWithDuration:(animated ? .3 : 0) animations:^{
        UIEdgeInsets insects = [self.popoverBackgroundViewClass contentViewInsets];
        _bgView.size = CGSizeMake(size.width + insects.left + insects.right, size.height + insects.top + insects.bottom);

        CGFloat height = [self.popoverBackgroundViewClass arrowHeight];
        switch (_bgView.arrowDirection) {
            case UIPopoverArrowDirectionDown:
            case UIPopoverArrowDirectionUp:
                _bgView.height += height;
                break;
            case UIPopoverArrowDirectionRight:
            case UIPopoverArrowDirectionLeft:
                _bgView.width += height;
                break;
            default:
                break;
        }
        // set frame after _bgView done
        _contentViewController.view.frame = CGRectMake(insects.left, insects.top, size.width, size.height);
    }];
}

- (void)setPopoverContentSize:(CGSize)size {
    [self setPopoverContentSize:size animated:NO];
}

- (void)windowTapped:(UITapGestureRecognizer *)tapGesture {
    // dismiss the popover if it's visible and conforms to the delegate protocol
    CGPoint tap = [tapGesture locationInView:_bgView];
    if (![_bgView pointInside:tap withEvent:nil]) {
        if ([self isPopoverVisible]) {
            [self dismissPopoverAnimated:YES];
            tapGesture.cancelsTouchesInView = YES;
        }
    } else {
        tapGesture.cancelsTouchesInView = NO;
    }
}

- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)item arrowDirection:(UIPopoverArrowDirection)arrowDirection animated:(BOOL)animated {

}

- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view arrowDirection:(UIPopoverArrowDirection)arrowDirection animated:(BOOL)animated {
    self.bgView = [[[self.popoverBackgroundViewClass alloc] init] autorelease];
    _bgView.arrowDirection = arrowDirection;
    [_bgView addSubview:_contentViewController.view];
    [self setPopoverContentSize:_contentViewController.contentSizeForViewInPopover animated:NO];

    self.popoverWindow = [[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    _popoverWindow.windowLevel = UIWindowLevelAlert + 1;
    _popoverWindow.hidden = NO;
    [_popoverWindow addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(windowTapped:)] autorelease]];
    [_popoverWindow addSubview:_bgView];

    CGRect frame = [_popoverWindow convertRect:rect fromView:view];
    switch (arrowDirection) {
        case UIPopoverArrowDirectionUp:
            _bgView.top = CGRectGetMaxY(frame);
            _bgView.centerX = CGRectGetMidX(frame);

            CGFloat maxX = _popoverWindow.width - _popoverLayoutMargins.right;
            CGFloat minX = _popoverLayoutMargins.right;
            CGFloat dx = 0;
            if (_bgView.right > maxX) {
                dx = _bgView.right - maxX;
                _bgView.right = maxX;
            }
            if (_bgView.left < minX) {
                dx = _bgView.left - minX;
                _bgView.left = minX;
            }
            _bgView.arrowOffset = dx;
            _contentViewController.view.top += [self.popoverBackgroundViewClass arrowHeight];
            break;
        default:
            [NSException raise:NSInvalidArgumentException format:@"not supported direction %d", arrowDirection];
    }

    // fade in
    [_contentViewController viewWillAppear:animated];
    _popoverVisible = YES;
    _popoverWindow.alpha = 0;
    [UIView animateWithDuration:(animated ? .3 : 0) animations:^{
        _popoverWindow.alpha = 1;
    } completion:^(BOOL finished) {
        [_contentViewController viewDidAppear:animated];
    }];
}

- (void)dismissPopoverAnimated:(BOOL)animated {
    [_contentViewController viewWillDisappear:animated];
    [UIView animateWithDuration:(animated ? .3 : 0) animations:^{
        _popoverWindow.alpha = 0;
    } completion:^(BOOL finished) {
        self.popoverWindow = nil;
        _popoverVisible = NO;
        [_contentViewController viewDidDisappear:animated]; // after animation done
    }];
}

@end
