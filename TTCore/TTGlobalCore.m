//
//  TTGlobalCore.m
//  TTCore
//
//  Created by shaohua on 1/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTGlobalCore.h"

NSMutableArray *TTCreateNonRetainingArray(void) {
    CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
    callbacks.retain = NULL;
    callbacks.release = NULL;
    return (NSMutableArray *)CFArrayCreateMutable(NULL, 0, &callbacks);
}
