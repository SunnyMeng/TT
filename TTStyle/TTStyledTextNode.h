//
//  TTStyledTextNode.h
//  TTUI
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTStyledNode.h"

@interface TTStyledTextNode : TTStyledNode

@property (nonatomic, retain) NSString *text;

+ (TTStyledTextNode *)nodeWithText:(NSString *)text;

@end
