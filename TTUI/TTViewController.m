//
//  TTViewController.m
//  TTUI
//
//  Created by shaohua on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTDebug.h"
#import "TTGlobalUI.h"
#import "TTViewController.h"
#import "UIViewAdditions.h"

@implementation TTViewController

@synthesize autoresizesForKeyboard = _autoresizesForKeyboard;
@synthesize isViewAppearing = _isViewAppearing;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _isViewAppearing = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _isViewAppearing = NO;
}

- (void)setAutoresizesForKeyboard:(BOOL)autoresizesForKeyboard {
    if (autoresizesForKeyboard != _autoresizesForKeyboard) {
        _autoresizesForKeyboard = autoresizesForKeyboard;

        if (_autoresizesForKeyboard) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resizeForKeyboard:) name:UIKeyboardWillShowNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resizeForKeyboard:) name:UIKeyboardWillHideNotification object:nil];
        } else {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        }
    }
}

- (void)resizeForKeyboard:(NSNotification *)notification {
    if (_isViewAppearing) {
        CGRect frameBegin = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        CGRect frameEnd = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        CGFloat dy = 0;
        UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
        switch (orient) {
            case UIInterfaceOrientationPortrait:
                dy = CGRectGetMinY(frameEnd) - CGRectGetMinY(frameBegin);
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                dy = CGRectGetMaxY(frameBegin) - CGRectGetMaxY(frameEnd);
                break;
            case UIInterfaceOrientationLandscapeLeft:
                dy = CGRectGetMinX(frameEnd) - CGRectGetMinX(frameBegin);
                break;
            case UIInterfaceOrientationLandscapeRight:
                dy = CGRectGetMaxX(frameBegin) - CGRectGetMaxX(frameEnd);
        }

        [UIView animateWithDuration:duration animations:^{
            if (CGAffineTransformIsIdentity(self.view.transform)) {
                self.view.height += dy;
            } else {
                switch (orient) {
                    case UIInterfaceOrientationPortrait:
                        self.view.height += dy;
                        break;
                    case UIInterfaceOrientationPortraitUpsideDown: {
                        CGFloat bottom = self.view.bottom;
                        self.view.height += dy;
                        self.view.bottom = bottom;
                        break;
                    }
                    case UIInterfaceOrientationLandscapeLeft:
                        self.view.width += dy;
                        break;
                    case UIInterfaceOrientationLandscapeRight: {
                        CGFloat right = self.view.right;
                        self.view.width += dy;
                        self.view.right = right;
                    }
                }
            }
        }];
    }
}

@end
