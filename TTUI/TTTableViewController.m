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

- (Class)cellClass {
    return [UITableViewCell class];
}

- (NSString *)listKey {
    return nil;
}

- (void)modelDidFinishLoad:(id<TTModel>)model {
    [self.tableView reloadData];
}

#pragma -
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
    if (self.tableView.indexPathForSelectedRow) {
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.model respondsToSelector:@selector(count)]) {
        return [(id)self.model count];
    }
    return 0;
}

// handle the cell reuse for subclasses and configure the cell by [cell setObject:item]
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![self.model respondsToSelector:@selector(objectAtIndex:)]) {
        return nil;
    }
    id item = [(id)self.model objectAtIndex:indexPath.row];

    Class cls = [self cellClass];
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
    if ([self.model respondsToSelector:@selector(objectAtIndex:)]) {
        id item = [(id)self.model objectAtIndex:indexPath.row];

        Class cls = [self cellClass];
        if ([cls respondsToSelector:@selector(rowHeightForObject:)]) {
            return [cls rowHeightForObject:item];
        }
    }
    return tableView.rowHeight; // failover
}

@end
