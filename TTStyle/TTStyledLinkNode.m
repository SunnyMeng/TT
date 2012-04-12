//
//  TTStyledLinkNode.m
//  TTStyle
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTStyledLinkNode.h"

@implementation TTStyledLinkNode

@synthesize URL = _URL;

- (id)initWithURL:(NSString *)URL {
    if (self = [super init]) {
        _URL = [URL copy];
    }
    return self;
}

- (void)dealloc {
    [_URL release];
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<a href=%@>%@</a>%@", _URL, self.firstChild, [super description]];
}

@end
