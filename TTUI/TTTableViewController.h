//
//  TTTableViewController.h
//  TTUI
//
//  Created by shaohua on 11/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TTModelViewController.h"

@interface TTTableViewController : TTModelViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableView;

- (Class)cellClassForObject:(id)object;

@end
