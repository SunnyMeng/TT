//
//  TTModelViewController.h
//  TTUI
//
//  Created by shaohua on 11/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTModel.h"
#import "TTViewController.h"

@interface TTModelViewController : TTViewController <TTModelDelegate>

@property (nonatomic, retain) id <TTModel> model;

- (void)createModel;
- (BOOL)shouldLoad;
- (void)reload;

// below three status (showLoading:/showEmpty:/showError:) are exclusive to each other
- (void)showLoading:(BOOL)show;
- (void)showEmpty:(BOOL)show;
- (void)showError:(NSError *)error;

@end
