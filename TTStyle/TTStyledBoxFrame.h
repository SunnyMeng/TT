//
//  TTStyledBoxFrame.h
//  TTUI
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTStyledFrame.h"

@interface TTStyledBoxFrame : TTStyledFrame

@property (nonatomic, assign) TTStyledBoxFrame *parentFrame;
@property (nonatomic, retain) TTStyledFrame *firstChildFrame;

@end
