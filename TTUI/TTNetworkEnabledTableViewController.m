//
//  TTNetworkEnabledTableViewController.m
//  TT
//
//  Created by shaohua on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTInfiniteScrollFooterView.h"
#import "TTNetworkEnabledTableViewController.h"
#import "TTPullRefreshHeaderView.h"
#import "TTTableView.h"

@interface TTNetworkEnabledTableViewController ()

@property (nonatomic, retain) TTInfiniteScrollFooterView *scrollFooterView;
@property (nonatomic, retain) TTPullRefreshHeaderView *refreshHeaderView;

@end


@implementation TTNetworkEnabledTableViewController

@synthesize scrollFooterView = _scrollFooterView;
@synthesize refreshHeaderView = _refreshHeaderView;
@synthesize dragRefreshEnabled = _dragRefreshEnabled;
@synthesize infiniteScrollEnabled = _infiniteScrollEnabled;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _dragRefreshEnabled = YES;
        _infiniteScrollEnabled = YES;
    }
    return self;
}

- (void)dealloc {
    [_refreshHeaderView release];
    [_scrollFooterView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_dragRefreshEnabled) {
        self.refreshHeaderView = [[[TTPullRefreshHeaderView alloc] initWithModel:self.model] autorelease];
        [self.tableView addSubview:_refreshHeaderView];
    }
    if (_infiniteScrollEnabled) {
        self.scrollFooterView = [[[TTInfiniteScrollFooterView alloc] initWithModel:self.model] autorelease];
        self.tableView.tableFooterView = _scrollFooterView;
    }
}

- (void)viewDidUnload {
    self.refreshHeaderView = nil;
    self.scrollFooterView = nil;
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_refreshHeaderView scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_refreshHeaderView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_refreshHeaderView scrollViewDidScroll:scrollView];
    [_scrollFooterView scrollViewDidScroll:scrollView];
}

- (void)modelDidFinishLoad:(id <TTModel>)model {
    [super modelDidFinishLoad:model];
    [_refreshHeaderView showDate:[NSDate date]];
}

@end
