//
//  TTViewController.m
//  TTUI
//
//  Created by shaohua on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTGlobalUI.h"
#import "TTViewController.h"
#import "UIViewAdditions.h"

@implementation TTViewController

@synthesize autoresizesForKeyboard = _autoresizesForKeyboard;
@synthesize isViewAppearing = _isViewAppearing;

- (void)dealloc {
    self.autoresizesForKeyboard = NO;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _isViewAppearing = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _isViewAppearing = NO;
}

- (void)setAutoresizesForKeyboard:(BOOL)autoresizesForKeyboard {
    if (_autoresizesForKeyboard != autoresizesForKeyboard) {
        _autoresizesForKeyboard = autoresizesForKeyboard;

        if (_autoresizesForKeyboard) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
        } else {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
        }
    }
}

- (void)resizeForKeyboard:(NSNotification *)notification {
    if (_isViewAppearing) {
        CGRect viewFrame = [[UIApplication sharedApplication].keyWindow convertRect:self.view.bounds fromView:self.view];
        CGRect keyboardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        CGFloat height = 0;

        UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
        switch (orient) {
            case UIInterfaceOrientationPortrait:
                height = CGRectGetMinY(keyboardFrame) - CGRectGetMinY(viewFrame);
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                height = CGRectGetMaxY(viewFrame) - CGRectGetMaxY(keyboardFrame);
                break;
            case UIInterfaceOrientationLandscapeLeft:
                height = CGRectGetMinX(keyboardFrame) - CGRectGetMinX(viewFrame);
                break;
            case UIInterfaceOrientationLandscapeRight: {
                height = CGRectGetMaxX(viewFrame) - CGRectGetMaxX(keyboardFrame);
            }
        }

        [UIView animateWithDuration:duration animations:^{
            if (CGAffineTransformIsIdentity(self.view.transform)) {
                self.view.height = height;
            } else {
                // when viewController is presented modally, its view is added to the keyWindow
                // and a rotation transform is applied instead of changing the frame directly.
                switch (orient) {
                    case UIInterfaceOrientationPortrait:
                        self.view.height = height;
                        break;
                    case UIInterfaceOrientationPortraitUpsideDown: {
                        CGFloat bottom = self.view.bottom;
                        self.view.height = height;
                        self.view.bottom = bottom;
                        break;
                    }
                    case UIInterfaceOrientationLandscapeLeft:
                        self.view.width = height;
                        break;
                    case UIInterfaceOrientationLandscapeRight: {
                        CGFloat right = self.view.right;
                        self.view.width = height;
                        self.view.right = right;
                    }
                }
            }
        }];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    [self resizeForKeyboard:notification];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self resizeForKeyboard:notification];
}

- (void)keyboardDidShow:(NSNotification *)notification {

}

- (void)keyboardDidHide:(NSNotification *)notification {

}

@end
