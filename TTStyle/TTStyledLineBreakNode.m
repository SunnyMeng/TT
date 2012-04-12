//
//  TTStyledLineBreakNode.m
//  TTStyle
//
//  Created by shaohua on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTStyledLineBreakNode.h"

@implementation TTStyledLineBreakNode

- (NSString *)description {
    return [NSString stringWithFormat:@"<br />%@", [super description]];
}

@end
