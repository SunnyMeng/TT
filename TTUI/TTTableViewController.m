//
//  TTTableViewController.m
//  TTUI
//
//  Created by shaohua on 11/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSArrayAdditions.h"
#import "TTTableViewCell.h" // bypass compilation warning and error
#import "TTTableViewController.h"

@implementation TTTableViewController

@synthesize tableView = _tableView;

#pragma mark -
#pragma mark Subclasses to override
- (Class)cellClassForObject:(id)object {
    return [UITableViewCell class];
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
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

@end
