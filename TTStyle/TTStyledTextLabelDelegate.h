//
//  TTStyledTextLabelDelegate.h
//  TT
//
//  Created by shaohua on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTStyledTextLabel;

@protocol TTStyledTextLabelDelegate <NSObject>

@optional
- (void)label:(TTStyledTextLabel *)label shouldOpenURL:(NSString *)URL;

@end
