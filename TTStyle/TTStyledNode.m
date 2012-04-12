//
//  TTStyledNode.m
//  TTStyle
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTStyledNode.h"

@implementation TTStyledNode

@synthesize nextSibling = _nextSibling;
@synthesize parentNode = _parentNode;

- (void)dealloc {
    [_nextSibling release];
    [super dealloc];
}

- (NSString *)description {
    NSString *result = [NSString stringWithFormat:@"%@@%p", [self class], self];
    if (self.nextSibling) {
        result = [result stringByAppendingFormat:@", %@", self.nextSibling];
    }
    return result;
}

@end
