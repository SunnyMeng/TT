//
//  UIViewControllerAdditions.m
//  TTUI
//
//  Created by shaohua on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIViewControllerAdditions.h"

@implementation UIViewController (TTUIAdditions)

- (UIViewController *)previousViewController {
    NSArray *viewControllers = self.navigationController.viewControllers;
    if ([viewControllers count] > 1) {
        NSUInteger controllerIndex = [viewControllers indexOfObject:self];
        if (controllerIndex != NSNotFound && controllerIndex > 0) {
            return [viewControllers objectAtIndex:controllerIndex - 1];
        }
    }
    return nil;
}

@end
