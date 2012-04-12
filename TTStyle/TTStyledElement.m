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

- (void)dealloc {
    [_firstChild release];
    [super dealloc];
}

@end
