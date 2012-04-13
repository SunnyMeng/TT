//
//  TTWebViewController.m
//  TTUI
//
//  Created by shaohua on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTActivityLabel.h"
#import "TTGlobalStyle.h"
#import "TTGlobalUI.h"
#import "TTWebViewController.h"
#import "UIViewAdditions.h"

@interface TTWebViewController ()

@property (nonatomic, retain) TTActivityLabel *loadingView;
@property (nonatomic, retain) UIBarButtonItem *backItem;
@property (nonatomic, retain) UIBarButtonItem *forwardItem;
@property (nonatomic, retain) UIBarButtonItem *refreshItem;
@property (nonatomic, retain) UIBarButtonItem *stopItem;
@property (nonatomic, retain) UIBarButtonItem *actionItem;
@property (nonatomic, retain) UIBarButtonItem *activityItem;

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIToolbar *toolbar;

@end


@implementation TTWebViewController

@synthesize loadingView = _loadingView;
@synthesize backItem = _backItem;
@synthesize forwardItem = _forwardItem;
@synthesize refreshItem = _refreshItem;
@synthesize stopItem = _stopItem;
@synthesize actionItem = _actionItem;
@synthesize webView = _webView;
@synthesize toolbar = _toolbar;
@synthesize activityItem = _activityItem;

- (id)initWithURL:(NSURL *)URL {
    if (self = [super init]) {
        _URL = [URL retain];
    }
    return self;
}

- (void)dealloc {
    [_loadingView release];
    [_backItem release];
    [_forwardItem release];
    [_refreshItem release];
    [_stopItem release];
    [_actionItem release];
    [_activityItem release];
    [_webView release];
    [_URL release];
    [_toolbar release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView = [[[UIWebView alloc] initWithFrame:self.view.bounds] autorelease];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _webView.delegate = self;
    [self.view addSubview:_webView];

    self.loadingView = [[[TTActivityLabel alloc] initWithStyle:UIActivityIndicatorViewStyleGray text:NSLocalizedString(@"Loading...", nil)] autorelease];
    _loadingView.center = CGPointMake(self.view.width / 2, self.view.height / 2);
    _loadingView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:_loadingView];

    NSURLRequest *request = [NSURLRequest requestWithURL:_URL];
    [_webView loadRequest:request];

    UIActivityIndicatorView *spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
    [spinner startAnimating];
    self.activityItem = [[[UIBarButtonItem alloc] initWithCustomView:spinner] autorelease];

    self.backItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(backTapped)] autorelease];
    self.forwardItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Forward"] style:UIBarButtonItemStylePlain target:self action:@selector(forwardTapped)] autorelease];
    self.refreshItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshTapped)] autorelease];
    self.stopItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopTapped)] autorelease];
    self.actionItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionTapped)] autorelease];
    UIBarItem *space = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:NULL] autorelease];

    _backItem.enabled = _forwardItem.enabled = NO;
    self.toolbar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, TTInterfaceOrientationIsLandscape() ? 33 : 44)] autorelease];
    _toolbar.bottom = self.view.height;
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _toolbar.items = [NSArray arrayWithObjects:_backItem, space, _forwardItem, space, _refreshItem, space, _actionItem, nil];
    [self.view addSubview:_toolbar];
    _webView.height -= _toolbar.height;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    _toolbar.height = TTInterfaceOrientationIsLandscape() ? 33 : 44;
    _webView.height = self.view.height - _toolbar.height;
    _toolbar.bottom = self.view.height;
}

- (void)backTapped {
    [_webView goBack];
}

- (void)forwardTapped {
    [_webView goForward];
}

- (void)refreshTapped {
    [_webView reload];
}

- (void)stopTapped {
    [_webView stopLoading];
}

- (void)actionTapped {
    UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Open in Safari", nil), nil] autorelease];
    actionSheet.actionSheetStyle = TTSTYLEVAR(actionSheetStyle);
    [actionSheet showInView:self.view.window];
}

- (void)replaceObjectInToolbarAtIndex:(NSUInteger)index withObject:(id)object {
    NSMutableArray *items = [NSMutableArray arrayWithArray:_toolbar.items];
    [items replaceObjectAtIndex:index withObject:object];
    _toolbar.items = items;
}

#pragma mark -
#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    _backItem.enabled = [webView canGoBack];
    _forwardItem.enabled = [webView canGoForward];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    _backItem.enabled = [webView canGoBack];
    _forwardItem.enabled = [webView canGoForward];
    [self replaceObjectInToolbarAtIndex:4 withObject:_stopItem];
    if (!self.navigationItem.rightBarButtonItem) {
        self.navigationItem.rightBarButtonItem = _activityItem;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (_loadingView) {
        [_loadingView removeFromSuperview];
        self.loadingView = nil;
    }
    _backItem.enabled = [webView canGoBack];
    _forwardItem.enabled = [webView canGoForward];
    [self replaceObjectInToolbarAtIndex:4 withObject:_refreshItem];
    if (self.navigationItem.rightBarButtonItem == _activityItem) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self webViewDidFinishLoad:webView];
}

#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:_URL];
    }
}

@end
