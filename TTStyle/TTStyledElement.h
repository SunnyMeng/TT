//
//  TTStyledElement.h
//  TTUI
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TTStyledNode.h"

// this is a base container node
@interface TTStyledElement : TTStyledNode

@property (nonatomic, readonly) TTStyledNode *firstChild;
@property (nonatomic, readonly) TTStyledNode *lastChild;

- (void)addChild:(TTStyledNode *)child;

@end
