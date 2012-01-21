//
//  TTInfiniteScrollFooterView.h
//  TTUI
//
//  Created by shaohua on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTModelDelegate.h"

@interface TTInfiniteScrollFooterView : UIView <TTModelDelegate, UIScrollViewDelegate> {
    UIActivityIndicatorView *_indicator;
    id <TTModel> _model;
}

- (id)initWithModel:(id <TTModel>)model;

@end
