//
//  TTPullRefreshHeaderView.h
//  TTUI
//
//  Created by shaohua on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTModelDelegate.h"

@protocol TTModel;

@interface TTPullRefreshHeaderView : UIView <TTModelDelegate, UIScrollViewDelegate> {
    UILabel *_refreshLabel;
    UILabel *_infoLabel;
    UIImageView *_arrowView;
    UIActivityIndicatorView *_refreshSpinner;
    UIScrollView *_scrollView; // assign

    id <TTModel> _model;
    BOOL _isDragging;
    BOOL _isLoading;
}

- (id)initWithModel:(id <TTModel>)model;
- (void)showDate:(NSDate *)date;

@end
