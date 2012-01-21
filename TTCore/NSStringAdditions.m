//
//  NSStringAdditions.m
//  TTCore
//
//  Created by shaohua on 1/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDataAdditions.h"
#import "NSStringAdditions.h"

@implementation NSString (Additions)

- (id)stringByUrlEncoded {
    return [(NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                (CFStringRef)self,
                                                                NULL,
                                                                (CFStringRef)@"!#$%&'()*+,/:;=?@[]",
                                                                kCFStringEncodingUTF8) autorelease];
}

- (NSString *)md5Hash {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5Hash];
}

@end
