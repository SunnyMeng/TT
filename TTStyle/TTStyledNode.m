//
//  TTStyledNode.m
//  TTUI
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTStyledNode.h"

@implementation TTStyledNode

@synthesize nextSibling = _nextSibling;
@synthesize parentNode = _parentNode;

- (NSString *)description {
    if (self.nextSibling) {
        return [NSString stringWithFormat:@", %@", self.nextSibling];
    }
    return @"";
}

@end
