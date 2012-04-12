//
//  TTStyledNode.h
//  TTStyle
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 XHTML -> TTStyledTextParser -> a tree of TTStyledNode

 TTStyledNode
 │
 ├─TTTextNode (leaf node)
 │
 └─TTStyledElement (container)
    │
    ├─TTStyledLineBreakNode <br>...</br>
    │
    ├─TTStyledLinkNode <a>...</a>
    │
    └─TTStyledImagenode <img>...</img>

 child nodes inside <br /> and <img /> are ignored during layout/display phase

 */

@class TTStyledElement;

@interface TTStyledNode : NSObject

@property (nonatomic, retain) TTStyledNode *nextSibling;
@property (nonatomic, assign) TTStyledElement *parentNode;

@end
