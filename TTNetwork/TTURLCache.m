//
//  TTURLCache.m
//  TTNetwork
//
//  Created by shaohua on 1/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTURLCache.h"

@implementation TTURLCache

- (void)createPathIfNecessary:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}

- (id)init {
    if (self = [super init]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesPath = [paths objectAtIndex:0];
        _dataPath = [[cachesPath stringByAppendingPathComponent:@"BodyData"] retain];
        _etagPath = [[_dataPath stringByAppendingPathComponent:@"ETag"] retain];
        _mtimePath = [[_dataPath stringByAppendingPathComponent:@"Last-Modified"] retain];

        [self createPathIfNecessary:_dataPath];
        [self createPathIfNecessary:_etagPath];
        [self createPathIfNecessary:_mtimePath];
    }
    return self;
}

- (void)dealloc {
    [_dataPath release];
    [_etagPath release];
    [_mtimePath release];
    [super dealloc];
}

+ (TTURLCache *)sharedCache {
    static TTURLCache *gSharedCache;
    if (!gSharedCache) {
        gSharedCache = [[TTURLCache alloc] init];
    }
    return gSharedCache;
}

- (NSString *)dataPathForKey:(NSString *)key {
    return [_dataPath stringByAppendingPathComponent:key];
}

- (NSString *)etagPathForKey:(NSString *)key {
    return [_etagPath stringByAppendingPathComponent:key];
}

- (NSString *)mtimePathForKey:(NSString *)key {
    return [_mtimePath stringByAppendingPathComponent:key];
}

- (BOOL)hasDataForKey:(NSString *)key expires:(NSTimeInterval)expirationAge {
    NSString *filePath = [self dataPathForKey:key];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath]) {
        NSDictionary *attrs = [fm attributesOfItemAtPath:filePath error:NULL];
        NSDate *modified = [attrs objectForKey:NSFileModificationDate];
        if ([modified timeIntervalSinceNow] < -expirationAge) {
            return NO;
        }
        return YES;
    }
    return NO;
}

- (NSDate *)touchDataForKey:(NSString *)key {
    NSDate *now = [NSDate date];
    NSString *filePath = [self dataPathForKey:key];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath]) {
        NSDictionary *attrs = [fm attributesOfItemAtPath:filePath error:NULL];
        NSMutableDictionary *newAttrs = [NSMutableDictionary dictionaryWithDictionary:attrs];
        [newAttrs setObject:now forKey:NSFileModificationDate];
        [fm setAttributes:newAttrs ofItemAtPath:filePath error:NULL];
    }
    return now;
}

- (NSData *)dataForKey:(NSString *)key expires:(NSTimeInterval)expirationAge timestamp:(NSDate **)timestamp {
    NSString *filePath = [self dataPathForKey:key];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath]) {
        NSDictionary *attrs = [fm attributesOfItemAtPath:filePath error:NULL];
        NSDate *modified = [attrs objectForKey:NSFileModificationDate];
        if ([modified timeIntervalSinceNow] < -expirationAge) {
            return nil;
        }
        if (timestamp) {
            *timestamp = modified;
        }
        return [NSData dataWithContentsOfFile:filePath];
    }
    return nil;
}

- (NSString *)etagForKey:(NSString *)key {
    NSData *data = [NSData dataWithContentsOfFile:[self etagPathForKey:key]];
    return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}

- (NSString *)mtimeForKey:(NSString *)key {
    NSData *data = [NSData dataWithContentsOfFile:[self mtimePathForKey:key]];
    return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}

- (void)storeData:(NSData *)data forKey:(NSString *)key {
    [[NSFileManager defaultManager] createFileAtPath:[self dataPathForKey:key] contents:data attributes:nil];
}

- (void)storeEtag:(NSString *)etag forKey:(NSString *)key {
    [[NSFileManager defaultManager] createFileAtPath:[self etagPathForKey:key] contents:[etag dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
}

- (void)storeMtime:(NSString *)mtime forKey:(NSString *)key {
    [[NSFileManager defaultManager] createFileAtPath:[self mtimePathForKey:key] contents:[mtime dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
}

@end
