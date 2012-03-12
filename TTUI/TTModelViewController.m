//
//  TTModelViewController.m
//  TTUI
//
//  Created by shaohua on 11/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TTGlobalUI.h"
#import "TTModelViewController.h"
#import "TTURLRequest.h"
#import "TTURLRequestQueue.h"

@implementation TTModelViewController

@synthesize model = _model;

- (void)dealloc {
    [_model.delegates removeObject:self];

    [_model release];
    [super dealloc];
}

- (id <TTModel>)model {
    if (!_model) {
        [self createModel];
        [_model.delegates addObject:self];
    }
    return _model;
}

- (void)createModel {

}

- (void)reload {
    [_model load:TTURLRequestReturnCacheDataThenLoad more:NO];
}

- (void)reloadIfNeeded {
    if (![_model isLoaded] && ![_model isLoading]) {
        [self reload];
    }
}

- (void)showLoading:(BOOL)show {

}

- (void)showEmpty:(BOOL)show {

}

- (void)showError:(NSError *)error {

}

#pragma mark -
#pragma mark UIViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self model];
    [self reloadIfNeeded];
}

#pragma mark -
#pragma mark TTModelDelegate
- (void)modelDidStartLoad:(id <TTModel>)model {
    [self showLoading:[model isEmpty]];
}

- (void)modelDidFinishLoad:(id <TTModel>)model {
    [self showEmpty:[model isEmpty]];
}

- (void)model:(id <TTModel>)model didFailLoadWithError:(NSError *)error {
    [self showError:error];
}

@end
