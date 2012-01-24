//
//  TTStyledImageNode.m
//  TTUI
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTStyledImageNode.h"

@implementation TTStyledImageNode

@synthesize URL = _URL;
@synthesize image = _image;
@synthesize width = _width;
@synthesize height = _height;

- (id)initWithURL:(NSString *)URL {
    if (self = [super init]) {
        _URL = [URL copy];
    }
    return self;
}

+ (TTStyledImageNode *)nodeWithURL:(NSString *)URL {
    return [[[TTStyledImageNode alloc] initWithURL:URL] autorelease];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<img src=%@>%@", _URL, [super description]];
}

@end
