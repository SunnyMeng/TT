//
//  TTStyledLinkNode.m
//  TTUI
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

+ (TTStyledLinkNode *)nodeWithURL:(NSString *)URL {
    return [[[TTStyledLinkNode alloc] initWithURL:URL] autorelease];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<a href=%@, text=%@>%@", _URL, self.firstChild, [super description]];
}

@end
