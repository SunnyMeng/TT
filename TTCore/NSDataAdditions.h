//
//  NSDataAdditions.h
//  TTCore
//
//  Created by shaohua on 1/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (TTCoreAdditions)

- (NSString *)md5Hash;
+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
- (NSString *)base64EncodedString;

@end
