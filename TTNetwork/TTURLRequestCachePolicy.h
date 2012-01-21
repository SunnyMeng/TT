//
//  TTURLRequestCachePolicy.h
//  TTNetwork
//
//  Created by shaohua on 1/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TTURLRequestReloadIgnoringCacheData, // always hit network, no read or write cache
    TTURLRequestReloadUsingCacheData,    // always hit network, conditional GET if possible
    TTURLRequestReturnCacheDataDontLoad, // never hit network
    TTURLRequestReturnCacheDataElseLoad, // hit network if no cache or cache expired, conditional GET if possible
    TTURLRequestReturnCacheDataThenLoad, // always hit network, may call back 1-2 times, conditional GET if possible
} TTURLRequestCachePolicy;
