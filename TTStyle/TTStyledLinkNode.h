//
//  TTStyledLinkNode.h
//  TTStyle
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTStyledElement.h"

@interface TTStyledLinkNode : TTStyledElement

@property (nonatomic, readonly) NSString *URL;

- (id)initWithURL:(NSString *)URL;

@end
