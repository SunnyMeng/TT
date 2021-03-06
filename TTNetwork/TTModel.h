//
//  TTModel.h
//  TTNetwork
//
//  Created by shaohua on 1/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TTModelDelegate.h"
#import "TTURLRequestCachePolicy.h"

@protocol TTModel <NSObject>

@property (nonatomic, readonly) NSMutableArray *delegates;

- (BOOL)isLoaded;
- (BOOL)isLoading;
- (BOOL)isEmpty;
- (BOOL)hasMore;
- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more;
- (void)cancel;

@optional
- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (id)objectForSection:(NSInteger)section;
- (id)objectForRowAtIndexPath:(NSIndexPath *)indexPath;

@end


// default implementation
@interface TTModel : NSObject <TTModel>

@end
