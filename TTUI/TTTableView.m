//
//  TTTableView.m
//  msnsf
//
//  Created by shaohua on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTTableView.h"
#import "UIViewAdditions.h"

@implementation TTTableView

@synthesize tableOverlayView = _tableOverlayView;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        _tableOverlayView = [[UIView alloc] initWithFrame:self.bounds];
        _tableOverlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _tableOverlayView.hidden = YES;
        _tableOverlayView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_tableOverlayView];
    }
    return self;
}

- (void)dealloc {
    [_tableOverlayView release];
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat top = 0;
    if (self.tableHeaderView) {
        top = self.tableHeaderView.height;
    }

    CGFloat height = MAX(44 /* minimum height */, self.height - top);
    _tableOverlayView.frame = CGRectMake(0, top, self.width, height);
    [self bringSubviewToFront:_tableOverlayView];
}

- (void)addToOverlayView:(UIView *)view {
    _tableOverlayView.hidden = NO;

    view.frame = _tableOverlayView.bounds;
    [view sizeToFit]; // after setting size (for UILabel)

    if (view.width < _tableOverlayView.width) {
        view.width = _tableOverlayView.width;
    }
    if (view.height < _tableOverlayView.height) {
        view.height = _tableOverlayView.height;
    }
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_tableOverlayView addSubview:view];
}

- (void)resetOverlayView {
    for (UIView *subview in _tableOverlayView.subviews) {
        [subview removeFromSuperview];
    }
    _tableOverlayView.hidden = YES;
}

@end
