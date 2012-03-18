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

        self.backgroundColor = [UIColor clearColor];

        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Arrow"]];
        [self addSubview:_arrowView];

        _infoLabel = [[UILabel alloc] init];
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.font = [UIFont systemFontOfSize:12];
        _infoLabel.textAlignment = UITextAlignmentCenter;
        [self showDate:nil];
        [self addSubview:_infoLabel];

        _refreshLabel = [[UILabel alloc] init];
        _refreshLabel.backgroundColor = [UIColor clearColor];
        _refreshLabel.font = [UIFont systemFontOfSize:12];
        _refreshLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:_refreshLabel];

        _refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_refreshSpinner];
    }
    return self;
}

- (void)dealloc {
    [_model.delegates removeObject:self];

    [_infoLabel release];
    [_arrowView release];
    [_model release];
    [_refreshLabel release];
    [_refreshSpinner release];
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.width = self.superview.width;
    [_infoLabel sizeToFit];
    [_refreshLabel sizeToFit];
    _infoLabel.centerX = _refreshLabel.centerX = self.width / 2;
    _refreshSpinner.centerY = _arrowView.centerY = _infoLabel.bottom = _refreshLabel.top = self.height / 2;
    _refreshSpinner.right = _arrowView.right = MIN(_refreshLabel.left, _infoLabel.left) - 10;
}

- (void)showDate:(NSDate *)date {
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"HH:mm"];
    NSString *time = [formatter stringFromDate:date] ?: NSLocalizedString(@"N/A", nil);
    _infoLabel.text = [NSString stringWithFormat:@"Last updated: %@", time];
}

- (void)showPull {
    _arrowView.layer.transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    _arrowView.hidden = NO;
    _refreshLabel.text = NSLocalizedString(@"Pull down to refresh", nil);
    [_refreshSpinner stopAnimating];
}

- (void)showRelease {
    _arrowView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    _arrowView.hidden = NO;
    _refreshLabel.text = NSLocalizedString(@"Release to refresh", nil);
    [_refreshSpinner stopAnimating];
}

- (void)showLoading {
    _arrowView.hidden = YES;
    _refreshLabel.text = NSLocalizedString(@"Loading...", nil);
    [_refreshSpinner startAnimating];
}

- (void)showLoading:(BOOL)show {
    _isLoading = show;

    if (show) {
        [UIView animateWithDuration:.3 animations:^{
            _scrollView.contentInset = UIEdgeInsetsMake(kRefreshHeaderHeight, 0, 0, 0);
        }];
        [self showLoading];
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
    [self showDate:[NSDate date]];
}

- (void)model:(id <TTModel>)model didFailLoadWithError:(NSError *)error {
    [_model.delegates removeObject:self];
    [self showLoading:NO];
}

@end
