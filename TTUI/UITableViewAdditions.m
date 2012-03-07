//
//  UITableViewAdditions.m
//  TT
//
//  Created by shaohua on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UITableViewAdditions.h"

@implementation UITableView (TTUIAdditions)

- (void)scrollToBottom:(BOOL)animated {
    NSInteger sectionCount = [self numberOfSections];
    if (sectionCount) {
        NSInteger section = [self numberOfSections] - 1;
        NSInteger rowCount = [self numberOfRowsInSection:section];
        if (rowCount) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowCount - 1 inSection:section];
            [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
        }
    }
}

@end
