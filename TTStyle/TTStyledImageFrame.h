//
//  TTStyledImageFrame.h
//  TTUI
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTStyledFrame.h"

@class TTStyledImageNode;

@interface TTStyledImageFrame : TTStyledFrame {
    TTStyledImageNode *_node;
}

- (id)initWithNode:(TTStyledImageNode *)node;

@end
