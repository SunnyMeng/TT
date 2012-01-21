//
//  TTModelViewController.m
//  TTUI
//
//  Created by shaohua on 11/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TTGlobalUI.h"
#import "TTModel.h"
#import "TTModelViewController.h"
#import "TTURLRequest.h"
#import "TTURLRequestQueue.h"

@implementation TTModelViewController

@synthesize model = _model;

- (void)dealloc {
    [_model release];
    [super dealloc];
}

- (void)createModel {
    NSAssert(_model, @"subclass to create");
}

- (BOOL)shouldLoad {
    return ![self.model isLoaded];
}

- (void)reload {
    [_model load:TTURLRequestReturnCacheDataElseLoad more:NO];
}

- (void)reloadIfNeeded {
    if ([self shouldLoad] && ![_model isLoading]) {
        [self reload];
    }
}

- (void)showLoading:(BOOL)show {
}

- (void)showEmpty:(BOOL)show {
}

#pragma mark -
#pragma makr UIViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_model) {
        [self createModel];
        [_model.delegates addObject:self];
    }
    [self reloadIfNeeded];
}

#pragma mark -
#pragma mark TTModelDelegate
- (void)modelDidStartLoad:(id <TTModel>)model {
    [self showLoading:YES];
}

- (void)modelDidFinishLoad:(id <TTModel>)model {
    [self showLoading:NO];
    [self showEmpty:[model isEmpty]];
}

- (void)model:(id <TTModel>)model didFailLoadWithError:(NSError *)error {
    [self showLoading:NO];
    [self showEmpty:[model isEmpty]];
}

@end
