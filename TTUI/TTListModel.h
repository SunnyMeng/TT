//
//  TTListModel.h
//  TTUI
//
//  Created by shaohua on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TTModel.h"

@protocol TTListModel <TTModel>

@property (nonatomic, readonly) NSMutableArray *items;

@end
