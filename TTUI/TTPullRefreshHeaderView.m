//
//  TTPullRefreshHeaderView.m
//  TTUI
//
//  Created by shaohua on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TTGlobalUI.h"
#import "TTModel.h"
#import "TTPullRefreshHeaderView.h"
#import "UIViewAdditions.h"

static const CGFloat kRefreshHeaderHeight = 52;

@implementation TTPullRefreshHeaderView

- (id)initWithModel:(id <TTModel>)model {
    if (self = [super initWithFrame:CGRectMake(0, -kRefreshHeaderHeight, 0, kRefreshHeaderHeight)]) {
        _model = [model retain];

        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];

        _refreshLabel = [[UILabel alloc] init];
        _refreshLabel.backgroundColor = [UIColor clearColor];
        _refreshLabel.font = [UIFont boldSystemFontOfSize:12];
        _refreshLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:_refreshLabel];

        _refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_refreshSpinner];
    }
    return self;
}

- (void)dealloc {
    [_model.delegates removeObject:self];

    [_model release];
    [_refreshLabel release];
    [_refreshSpinner release];
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.width = self.superview.width;
    _refreshLabel.frame = self.bounds;
    _refreshSpinner.center = CGPointMake(self.width / 2, self.height / 2);
}

- (void)showPull {
    _refreshLabel.text = NSLocalizedString(@"Pull down to refresh", nil);
    [_refreshSpinner stopAnimating];
}

- (void)showRelease {
    _refreshLabel.text = NSLocalizedString(@"Release to refresh", nil);
    [_refreshSpinner stopAnimating];
}

- (void)showLoading:(BOOL)show {
    _isLoading = show;

    if (show) {
        [UIView animateWithDuration:.3 animations:^{
            _scrollView.contentInset = UIEdgeInsetsMake(kRefreshHeaderHeight, 0, 0, 0);
        }];
        _refreshLabel.text = nil;
        [_refreshSpinner startAnimating];
    } else {
        [UIView animateWithDuration:.3 animations:^{
            _scrollView.contentInset = UIEdgeInsetsZero;
        } completion:^(BOOL finished) {
            [self showPull];
        }];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_isLoading) {
        return;
    }
    _isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0) {
            scrollView.contentInset = UIEdgeInsetsZero;
        } else if (scrollView.contentOffset.y >= -kRefreshHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
    } else if (_isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < -kRefreshHeaderHeight) {
            // User is scrolling above the header
            [self showRelease];
        } else {
            // User is scrolling somewhere within the header
            [self showPull];
        }
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_isLoading) {
        return;
    }
    _isDragging = NO;
    if (scrollView.contentOffset.y <= -kRefreshHeaderHeight) {
        // Released above the header
        [_model.delegates addObject:self];
        [_model load:TTURLRequestReloadUsingCacheData more:NO];
        _scrollView = scrollView;
    }
}

#pragma mark -
#pragma mark TTModelDelegate
- (void)modelDidStartLoad:(id <TTModel>)model {
    [self showLoading:YES];
}

- (void)modelDidFinishLoad:(id <TTModel>)model {
    [_model.delegates removeObject:self];
    [self showLoading:NO];
}

- (void)model:(id <TTModel>)model didFailLoadWithError:(NSError *)error {
    [_model.delegates removeObject:self];
    [self showLoading:NO];
}

@end
