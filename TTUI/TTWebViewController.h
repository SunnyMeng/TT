//
//  TTWebViewController.h
//  TTUI
//
//  Created by shaohua on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTWebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate> {
@private
    NSURL *_URL;

@protected
    UIToolbar *_toolbar;
    UIBarButtonItem *_actionItem;
}

- (id)initWithURL:(NSURL *)URL;

@end
