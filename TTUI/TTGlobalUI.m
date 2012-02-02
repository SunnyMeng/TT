//
//  TTGlobalUI.m
//  TTUI
//
//  Created by shaohua on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/sysctl.h>

#import "TTGlobalUI.h"

void TTAlert(NSString *message) {
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil)
                                                     message:message
                                                    delegate:nil
                                           cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                           otherButtonTitles:nil] autorelease];
    [alert show];
}

NSString *TTDeviceModelName(void) {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

BOOL TTInterfaceOrientationIsLandscape(void) {
    UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
    return UIInterfaceOrientationIsLandscape(orient);
}

CGFloat TTScreenWidth(void) {
    CGRect bounds = [UIScreen mainScreen].bounds;
    UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
    return UIInterfaceOrientationIsLandscape(orient) ? bounds.size.height : bounds.size.width;
}

CGSize TTScaleAspectFit(CGSize size, CGSize bounds) {
    if (size.width > bounds.width || size.height > bounds.height) {
        CGFloat hRatio = size.width / bounds.width;
        CGFloat vRatio = size.height / bounds.height;
        CGFloat ratio = MAX(hRatio, vRatio);
        return CGSizeMake(floorf(size.width / ratio), floorf(size.height / ratio));
    }
    return size;
}
