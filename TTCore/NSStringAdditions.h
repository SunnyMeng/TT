//
//  NSStringAdditions.h
//  TTCore
//
//  Created by shaohua on 1/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TTCoreAdditions)

- (NSString *)stringByUrlEncoded;
- (NSString *)stringByXMLEscaped;
- (NSString *)md5Hash;
+ (id)uuidString;

@end
