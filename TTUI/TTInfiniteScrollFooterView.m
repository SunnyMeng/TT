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

#define SCROLL_FOOTER_HEIGHT 40

@implementation TTInfiniteScrollFooterView

- (id)initWithModel:(id <TTModel>)model {
    if ((self = [super initWithFrame:CGRectMake(0, 0, 320, SCROLL_FOOTER_HEIGHT)])) {
        _model = [model retain];
        [_model.delegates addObject:self];

        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicator.center = self.center;
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
    [self showLoading:NO];
}

- (void)model:(id<TTModel>)model didFailLoadWithError:(NSError *)error {
    [self showLoading:NO];
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentSize.height - self.height <= scrollView.height ?
        scrollView.contentOffset.y > 0 :
        scrollView.contentSize.height - self.height < scrollView.contentOffset.y + scrollView.height) {
        if (![_model isLoading]) {
            [_model load:TTURLRequestReloadUsingCacheData more:YES];
        }
    }
}

@end
