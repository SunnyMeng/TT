//
//  TTGlobalNetwork.m
//  TTNetwork
//
//  Created by shaohua on 1/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <pthread.h>

#import "TTGlobalNetwork.h"

static int gNetworkTaskCount = 0;
static pthread_mutex_t gMutex = PTHREAD_MUTEX_INITIALIZER;

void TTNetworkRequestStarted(void) {
    pthread_mutex_lock(&gMutex);
    if (gNetworkTaskCount == 0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    ++gNetworkTaskCount;
    pthread_mutex_unlock(&gMutex);
}

void TTNetworkRequestStopped(void) {
    pthread_mutex_lock(&gMutex);
    --gNetworkTaskCount;
    gNetworkTaskCount = MAX(0, gNetworkTaskCount);
    if (gNetworkTaskCount == 0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    pthread_mutex_unlock(&gMutex);
}
