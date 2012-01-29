//
//  TTModelDelegate.h
//  TTNetwork
//
//  Created by shaohua on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TTModel;

@protocol TTModelDelegate <NSObject>

@optional

- (void)modelDidStartLoad:(id <TTModel>)model;
- (void)modelDidFinishLoad:(id <TTModel>)model;
- (void)model:(id <TTModel>)model didFailLoadWithError:(NSError *)error;

@end
