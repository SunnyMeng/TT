//
//  TTModelViewController.h
//  TTUI
//
//  Created by shaohua on 11/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTModelDelegate.h"
#import "TTViewController.h"

@protocol TTModel;

@interface TTModelViewController : TTViewController <TTModelDelegate> {
    id <TTModel> _model;
}

@property (nonatomic, retain) id <TTModel> model;

- (void)createModel;
- (BOOL)shouldLoad;

- (void)showLoading:(BOOL)show;
- (void)showEmpty:(BOOL)show;

@end
