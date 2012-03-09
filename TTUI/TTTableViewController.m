//
//  TTTableViewController.m
//  TTUI
//
//  Created by shaohua on 11/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSArrayAdditions.h"
#import "TTActivityLabel.h"
#import "TTGlobalUI.h"
#import "TTTableView.h"
#import "TTTableViewCell.h" // bypass compilation warning and error
#import "TTTableViewController.h"
#import "UIViewAdditions.h"

@implementation TTTableViewController

@synthesize tableView = _tableView;
@synthesize loadingView = _loadingView;
@synthesize emptyView = _emptyView;
@synthesize errorView = _errorView;

- (void)dealloc {
    [_loadingView release];
    [_emptyView release];
    [_errorView release];
    [_tableView release];
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[[TTTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    NSIndexPath *indexPath = _tableView.indexPathForSelectedRow;
    if (indexPath) {
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark -
#pragma mark Subclasses to override
- (Class)cellClassForObject:(id)object {
    return [UITableViewCell class];
}

- (NSString *)titleForLoading {
    return NSLocalizedString(@"Loading...", nil);
}

- (NSString *)titleForEmpty {
    return NSLocalizedString(@"Empty", nil);
}

- (void)showLoading:(BOOL)show {
    [self.tableView resetOverlayView];
    if (show) {
        if (!_loadingView) {
            self.loadingView = [[[TTActivityLabel alloc] initWithStyle:UIActivityIndicatorViewStyleGray text:[self titleForLoading]] autorelease];
        }
        [self.tableView addToOverlayView:_loadingView];
    }
}

- (void)showEmpty:(BOOL)show {
    [self.tableView resetOverlayView];
    if (show) {
        if (!_emptyView) {
            UILabel *label = [[[UILabel alloc] init] autorelease];
            label.textAlignment = UITextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:17];
            label.textColor = RGBCOLOR(99, 109, 125);
            label.text = [self titleForEmpty];
            self.emptyView = label;
        }
        [self.tableView addToOverlayView:_emptyView];
    }
}

- (void)showError:(NSError *)error {
    [self.tableView resetOverlayView];
    if (error) {
        if (!_errorView) {
            UILabel *label = [[[UILabel alloc] init] autorelease];
            label.text = [error localizedDescription];
            label.font = [UIFont systemFontOfSize:17];
            label.textColor = RGBCOLOR(99, 109, 125);
            label.textAlignment = UITextAlignmentCenter;
            label.numberOfLines = 0;
            self.errorView = label;
        }
        [self.tableView addToOverlayView:_errorView];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.model numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.model numberOfRowsInSection:section];
}

// handle the cell reuse for subclasses and configure the cell by [cell setObject:item]
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = [self.model objectForRowAtIndexPath:indexPath];

    Class cls = [self cellClassForObject:item];
    NSString *identifier = NSStringFromClass(cls);
    id cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[cls alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    if ([cell respondsToSelector:@selector(setObject:)]) {
        [cell setObject:item];
    }
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = [self.model objectForRowAtIndexPath:indexPath];

    Class cls = [self cellClassForObject:item];
    if ([cls respondsToSelector:@selector(rowHeightForObject:)]) {
        return [cls rowHeightForObject:item];
    }
    return tableView.rowHeight; // failover
}

#pragma mark -
#pragma mark TTModelDelegate
- (void)modelDidFinishLoad:(id <TTModel>)model {
    [super modelDidFinishLoad:model];
    [_tableView reloadData];
}

- (void)model:(id<TTModel>)model didFailLoadWithError:(NSError *)error {
    [super model:model didFailLoadWithError:error];
    [_tableView reloadData];
}

@end
