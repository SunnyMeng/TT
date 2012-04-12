//
//  TTStyledTextNode.m
//  TTStyle
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTStyledTextNode.h"

@implementation TTStyledTextNode

@synthesize text = _text;

- (id)initWithText:(NSString *)text {
    if (self = [super init]) {
        _text = [text copy];
    }
    return self;
}

- (void)dealloc {
    [_text release];
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\"%@\"%@", _text, [super description]];
}

@end
