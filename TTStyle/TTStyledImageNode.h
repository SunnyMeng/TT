//
//  TTStyledImageNode.h
//  TTStyle
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#import "TTStyledElement.h"

@interface TTStyledImageNode : TTStyledElement

@property (nonatomic, readonly) NSString *URL;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

- (id)initWithURL:(NSString *)URL;

@end
