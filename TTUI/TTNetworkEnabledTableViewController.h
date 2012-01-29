//
//  TTNetworkEnabledTableViewController.h
//  TT
//
//  Created by shaohua on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTTableViewController.h"

@interface TTNetworkEnabledTableViewController : TTTableViewController

@property (nonatomic, getter=isDragRefreshEnabled) BOOL dragRefreshEnabled;
@property (nonatomic, getter=isInfiniteScrollEnabled) BOOL infiniteScrollEnabled;

@end
