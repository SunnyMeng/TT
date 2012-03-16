//
//  TTStyledTextNode.h
//  TTStyle
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTStyledNode.h"

@interface TTStyledTextNode : TTStyledNode

@property (nonatomic, readonly) NSString *text;

+ (id)nodeWithText:(NSString *)text;

@end
