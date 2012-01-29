//
//  TTPullRefreshHeaderView.m
//  TTUI
//
//  Created by shaohua on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TTModel.h"
#import "TTPullRefreshHeaderView.h"

#define REFRESH_HEADER_HEIGHT 52

@implementation TTPullRefreshHeaderView

- (id)initWithModel:(id <TTModel>)model {
    if (self = [super initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)]) {
        _model = [model retain];
        [_model.delegates addObject:self];

        self.backgroundColor = [UIColor clearColor];

        _refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
        _refreshLabel.backgroundColor = [UIColor clearColor];
        _refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
        _refreshLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:_refreshLabel];

        _refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _refreshSpinner.frame = CGRectMake((320 - 20) / 2, floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
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

- (void)showPull {
    _refreshLabel.text = NSLocalizedString(@"Pull down to refresh", nil);
    [_refreshSpinner stopAnimating];
}

- (void)showRelease {
    _refreshLabel.text = NSLocalizedString(@"Release to refresh", nil);
    [_refreshSpinner stopAnimating];
}

- (void)showLoading {
    _refreshLabel.text = nil;
    [_refreshSpinner startAnimating];
}

- (void)startLoading {
    _isLoading = YES;

    // Show the header
    [UIView animateWithDuration:.3 animations:^{
        _scrollView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    }];

    [self showLoading];

    // Refresh action!
    [_model load:TTURLRequestReloadUsingCacheData more:NO];
}

- (void)stopLoading {
    _isLoading = NO;

    [UIView animateWithDuration:.3 animations:^{
        // Hide the header
        _scrollView.contentInset = UIEdgeInsetsZero;
    } completion:^(BOOL finished) {
        // Reset the header
        [self showPull];
    }];
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
        } else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
    } else if (_isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
            // User is scrolling above the header
            [self showRelease];
        } else { // User is scrolling somewhere within the header
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
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        _scrollView = scrollView;
        [self startLoading];
    }
}

#pragma mark -
#pragma mark TTModelDelegate
- (void)modelDidFinishLoad:(id<TTModel>)model {
    [self stopLoading];
}

- (void)model:(id<TTModel>)model didFailLoadWithError:(NSError *)error {
    [self stopLoading];
}

@end
