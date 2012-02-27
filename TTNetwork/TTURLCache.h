//
//  TTURLCache.h
//  TTNetwork
//
//  Created by shaohua on 1/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TTURLCache : NSObject {
    NSString *_dataPath;
    NSString *_etagPath;
    NSString *_mtimePath;
}

- (BOOL)hasDataForKey:(NSString *)key expires:(NSTimeInterval)expirationAge;
- (NSDate *)touchDataForKey:(NSString *)key;

- (NSData *)dataForKey:(NSString *)key expires:(NSTimeInterval)expirationAge timestamp:(NSDate **)timestamp;
- (NSString *)etagForKey:(NSString *)key;
- (NSString *)mtimeForKey:(NSString *)key;

- (void)storeData:(NSData *)data forKey:(NSString *)key;
- (void)storeEtag:(NSString *)etag forKey:(NSString *)key;
- (void)storeMtime:(NSString *)mtime forKey:(NSString *)key;

// Public
+ (TTURLCache *)sharedCache;
- (UIImage *)imageForURL:(NSString *)URL;

@end
