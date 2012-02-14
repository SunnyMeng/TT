//
//  TTGlobalCore.m
//  TTCore
//
//  Created by shaohua on 1/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTGlobalCore.h"

static const void *TTRetainNoOp(CFAllocatorRef allocator, const void *value) {
    return value;
}

static void TTReleaseNoOp(CFAllocatorRef allocator, const void *value) {
}

NSMutableArray *TTCreateNonRetainingArray(void) {
    CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
    callbacks.retain = TTRetainNoOp;
    callbacks.release = TTReleaseNoOp;
    return (NSMutableArray *)CFArrayCreateMutable(nil, 0, &callbacks);
}
