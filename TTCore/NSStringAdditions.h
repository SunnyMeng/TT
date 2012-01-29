//
//  NSStringAdditions.h
//  TTCore
//
//  Created by shaohua on 1/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

- (NSString *)stringByUrlEncoded;
- (NSString *)stringByXMLEscaped;
- (NSString *)md5Hash;

@end
