//
//  NSStringAdditions.m
//  TTCore
//
//  Created by shaohua on 1/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDataAdditions.h"
#import "NSStringAdditions.h"

@implementation NSString (TTCoreAdditions)

// stringByAddingPercentEscapesUsingEncoding: do not encode + (plus sign), which will be interrupted as a space in an URL
- (id)stringByUrlEncoded {
    return [(NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)@"!#$%&'()*+,/:;=?@[]", kCFStringEncodingUTF8) autorelease];
}

- (NSString *)stringByXMLEscaped {
    return [[[[[self stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]
               stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"]
              stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"]
             stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"]
            stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
}

- (NSString *)md5Hash {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5Hash];
}

+ (id)uuidString {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    NSString *uuidString = (NSString *)CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return [uuidString autorelease];
}

@end
