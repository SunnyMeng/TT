//
//  TTStyledTextParser.h
//  TTUI
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTStyledNode;
@class TTStyledElement;

@interface TTStyledTextParser : NSObject <NSXMLParserDelegate> {
    TTStyledNode *_lastNode;

    TTStyledElement *_topElement; // top pointer of stack
    NSMutableArray *_stack;
}

// Output
@property (nonatomic, readonly) TTStyledNode *rootNode; // single linked list

// Input
- (void)parseXHTML:(NSString *)html;

@end
