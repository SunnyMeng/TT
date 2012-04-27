//
//  NSArrayAdditions.m
//  TTCore
//
//  Created by shaohua on 1/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSArrayAdditions.h"

@implementation NSArray (Additions)

- (void)perform:(SEL)selector {
    NSArray *copy = [self copy];
    for (id delegate in copy) {
        if ([delegate respondsToSelector:selector]) {
            [delegate performSelector:selector];
        }
    }
    [copy release];
}

- (void)perform:(SEL)selector withObject:(id)p1 {
    NSArray *copy = [self copy];
    for (id delegate in copy) {
        if ([delegate respondsToSelector:selector]) {
            [delegate performSelector:selector withObject:p1];
        }
    }
    [copy release];
}

- (void)perform:(SEL)selector withObject:(id)p1 withObject:(id)p2 {
    NSArray *copy = [self copy];
    for (id delegate in copy) {
        if ([delegate respondsToSelector:selector]) {
            [delegate performSelector:selector withObject:p1 withObject:p2];
        }
    }
    [copy release];
}

@end
