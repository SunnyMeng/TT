//
//  TTTableViewCell.h
//  TTUI
//
//  Created by shaohua on 12/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TTTableViewCell <NSObject>

@optional
- (void)setObject:(id)item;
+ (CGFloat)rowHeightForObject:(id)item;

@end
