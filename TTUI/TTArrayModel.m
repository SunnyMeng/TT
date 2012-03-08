//
//  TTArrayModel.m
//  TTUI
//
//  Created by shaohua on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTArrayModel.h"

@implementation TTArrayModel

- (id)initWithArray:(NSArray *)array {
    if (self = [super init]) {
        _array = [array retain];
    }
    return self;
}

- (void)dealloc {
    [_array release];
    [super dealloc];
}

- (BOOL)isEmpty {
    return [_array count] == 0;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return [_array count];
}

- (id)objectForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_array objectAtIndex:indexPath.row];
}

@end
