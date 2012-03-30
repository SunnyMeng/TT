//
//  TTTableViewController.h
//  TTUI
//
//  Created by shaohua on 11/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TTModelViewController.h"

@class TTTableView;

@interface TTTableViewController : TTModelViewController <UITableViewDelegate, UITableViewDataSource> {
@private
    UITableViewStyle _tableViewStyle;
}

@property (nonatomic, retain) TTTableView *tableView;

// subclass to override
@property (nonatomic, retain) UIView *loadingView;
@property (nonatomic, retain) UIView *emptyView;
@property (nonatomic, retain) UIView *errorView;

- (Class)cellClassForObject:(id)object;

// public
- (id)initWithStyle:(UITableViewStyle)style;

@end
