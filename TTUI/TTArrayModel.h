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
@private
    BOOL _loaded;
    NSMutableArray *_items;
}

- (id)initWithItems:(NSArray *)items;

@end
