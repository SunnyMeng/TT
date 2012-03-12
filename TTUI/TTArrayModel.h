//
//  TTArrayModel.h
//  TTUI
//
//  Created by shaohua on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTModel.h"

@interface TTArrayModel : TTModel {
    BOOL _loaded;
}

@property (nonatomic, readonly) NSArray *items;

- (id)initWithItems:(NSArray *)items;

@end
