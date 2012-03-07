//
//  TTPageControl.m
//  msnsf
//
//  Created by shaohua on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTPageControl.h"
#import "UIViewAdditions.h"

@implementation TTPageControl

@synthesize onColor = _onColor;
@synthesize offColor = _offColor;

- (void)dealloc {
    [_onColor release];
    [_offColor release];
    [super dealloc];
}

- (void)setCurrentPage:(NSInteger)currentPage {
    [super setCurrentPage:currentPage];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (NSInteger i = 0; i < [self.subviews count]; ++i) {
        UIImageView *subview = [self.subviews objectAtIndex:i];
        if ([subview isKindOfClass:[UIImageView class]]) {
            subview.image = nil;
            subview.layer.cornerRadius = subview.width / 2;
            subview.layer.masksToBounds = YES;
            subview.backgroundColor = i == self.currentPage ? (_onColor ?: [UIColor whiteColor]) : (_offColor ?: [UIColor grayColor]);
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self setNeedsLayout];
}

@end
