//
//  TTArrayModel.m
//  TTUI
//
//  Created by shaohua on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTArrayModel.h"

@implementation TTArrayModel

@synthesize items = _items;

- (id)initWithItems:(NSArray *)items {
    if (self = [super init]) {
        _items = [items retain];
    }
    return self;
}

- (void)dealloc {
    [_items release];
    [super dealloc];
}

- (BOOL)isEmpty {
    return [_items count] == 0;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return [_items count];
}

- (id)objectForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_items objectAtIndex:indexPath.row];
}

@end
