//
//  TTActivityLabel.h
//  msnsf
//
//  Created by shaohua on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface TTActivityLabel : UIView {
    UILabel *_label;
    UIActivityIndicatorView *_indicatorView;
}

- (id)initWithStyle:(UIActivityIndicatorViewStyle)style text:(NSString *)text;

@end
