//
//  TTStyledElement.m
//  TTStyle
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTStyledElement.h"

@implementation TTStyledElement

@synthesize firstChild = _firstChild;
@synthesize lastChild = _lastChild;

- (void)dealloc {
    [_firstChild release];
    [super dealloc];
}

- (TTStyledNode *)findLastSibling:(TTStyledNode *)sibling {
    while (sibling) {
        if (!sibling.nextSibling) {
            return sibling;
        }
        sibling = sibling.nextSibling;
    }
    return nil;
}

- (void)addChild:(TTStyledNode *)child {
    if (!_firstChild) {
        _firstChild = [child retain];
        _lastChild = [self findLastSibling:child];
    } else {
        _lastChild.nextSibling = child;
        _lastChild = [self findLastSibling:child];
    }
    child.parentNode = self;
}

@end
