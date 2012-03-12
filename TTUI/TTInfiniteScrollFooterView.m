//
//  TTInfiniteScrollFooterView.h
//  TTUI
//
//  Created by shaohua on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TTInfiniteScrollFooterView.h"
#import "TTModel.h"
#import "UIViewAdditions.h"

static const CGFloat kScrollFooterHeight = 40;

@implementation TTInfiniteScrollFooterView

- (id)initWithModel:(id <TTModel>)model {
    if ((self = [super initWithFrame:CGRectMake(0, 0, 0, kScrollFooterHeight)])) {
        _model = [model retain];

        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_indicator];
    }
    return self;
}

- (void)dealloc {
    [_model.delegates removeObject:self];

    [_model release];
    [_indicator release];
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.width = self.superview.width;
    _indicator.center = CGPointMake(self.width / 2, self.height / 2);
}

- (void)showLoading:(BOOL)show {
    if (show) {
        [_indicator startAnimating];
    } else {
        [_indicator stopAnimating];
    }
}

#pragma mark -
#pragma mark TTModelDelegate
- (void)modelDidStartLoad:(id<TTModel>)model {
    [self showLoading:YES];
}

- (void)modelDidFinishLoad:(id<TTModel>)model {
    [_model.delegates removeObject:self];
    [self showLoading:NO];
}

- (void)model:(id<TTModel>)model didFailLoadWithError:(NSError *)error {
    [_model.delegates removeObject:self];
    [self showLoading:NO];
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (![_model isLoading] && [_model hasMore]) {
        CGFloat scrollRatio = scrollView.contentOffset.y / (scrollView.contentSize.height - scrollView.height);
        if (scrollRatio > 1) {
            [_model.delegates addObject:self];
            [_model load:TTURLRequestReturnCacheDataElseLoad more:YES];
        }
    }
}

@end
