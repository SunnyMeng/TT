//
//  TTDebug.h
//  TTCore
//
//  Created by shaohua on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
    #define TTDPRINT(xx, ...) NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
    #define TTDPRINT(xx, ...) ((void)0)
#endif

#ifdef DEBUG
    #import <TargetConditionals.h>
    #if TARGET_IPHONE_SIMULATOR
        int TTIsInDebugger(void);
        // We leave the __asm__ in this macro so that when a break occurs, we don't have to step out of a "breakInDebugger" function.
        #define TTDASSERT(xx) { if (!(xx)) { TTDPRINT(@"TTDASSERT failed: %s", #xx); if (TTIsInDebugger()) { __asm__("int $3\n" : : ); } } } ((void)0)
    #else
        #define TTDASSERT(xx) { if (!(xx)) { TTDPRINT(@"TTDASSERT failed: %s", #xx); } } ((void)0)
    #endif

#else
    #define TTDASSERT(xx) ((void)0)
#endif
