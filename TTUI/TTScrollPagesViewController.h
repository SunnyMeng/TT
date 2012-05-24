//
//  TTScrollPagesViewController.h
//  msnsf
//
//  Created by shaohua on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTViewController.h"
#import "UIViewAdditions.h"

@interface TTScrollPagesViewController : TTViewController <UIScrollViewDelegate>

@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic) NSUInteger selectedIndex;

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated;
- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated;

@end
