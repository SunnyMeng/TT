//
//  TTTableView.h
//  msnsf
//
//  Created by shaohua on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTTableView : UITableView

@property (nonatomic, retain) UIView *tableOverlayView;

- (void)addToOverlayView:(UIView *)view;
- (void)resetOverlayView;

@end
