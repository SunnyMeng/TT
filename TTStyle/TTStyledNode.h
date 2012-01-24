//
//  TTStyledNode.h
//  TTUI
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTStyledElement;

@interface TTStyledNode : NSObject

@property (nonatomic, retain) TTStyledNode *nextSibling;
@property (nonatomic, assign) TTStyledElement *parentNode;

@end
