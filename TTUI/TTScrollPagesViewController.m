//
//  TTScrollPagesViewController.m
//  msnsf
//
//  Created by shaohua on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTScrollPagesViewController.h"

@interface TTScrollPagesViewController () {
    // at any time, there are most two viewControllers visible
    UIViewController *_selectedViewController;
    UIViewController *_appearingViewController;
}

@property (nonatomic, retain) UIScrollView *scrollView;

@end


@implementation TTScrollPagesViewController

@synthesize viewControllers = _viewControllers;
@synthesize scrollView = _scrollView;
@synthesize selectedIndex = _selectedIndex;

- (void)dealloc {
    [_scrollView release];
    [_viewControllers release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.scrollView = [[[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // ensure the content height is always same as view's height
    _scrollView.contentSize = CGSizeApplyAffineTransform(self.view.size, CGAffineTransformMakeScale([_viewControllers count] ?: 1, 1));
    [_selectedViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_selectedViewController viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_selectedViewController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_selectedViewController viewDidDisappear:animated];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {

    for (UIViewController *viewController in _viewControllers) {
        [viewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    for (UIViewController *viewController in _viewControllers) {
        [viewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    _scrollView.contentSize = CGSizeApplyAffineTransform(self.view.size, CGAffineTransformMakeScale([_viewControllers count] ?: 1, 1));

    for (NSUInteger i = 0; i < [_viewControllers count]; ++i) {
        UIViewController *viewController = [_viewControllers objectAtIndex:i];
        CGRect bounds = CGRectZero; // _scrollView.bounds.origin can be not (0, 0)!
        bounds.size = self.view.size;
        viewController.view.frame = CGRectApplyAffineTransform(bounds, CGAffineTransformMakeTranslation(_scrollView.width * i, 0));

        [viewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    }
    [_scrollView setContentOffset:CGPointMake(_scrollView.width * _selectedIndex, 0) animated:NO];
}

#pragma mark - Public
- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    if (_viewControllers != viewControllers) {
        if (self.isViewAppearing) {
            [_selectedViewController viewWillDisappear:animated];
            [_selectedViewController viewDidDisappear:animated];
        }

        for (UIViewController *viewController in _viewControllers) {
            [viewController.view removeFromSuperview];
        }
        _selectedIndex = NSNotFound;
        _selectedViewController = nil;

        [_viewControllers release];
        _viewControllers = [viewControllers retain];

        for (NSUInteger i = 0; i < [_viewControllers count]; ++i) {
            UIViewController *viewController = [_viewControllers objectAtIndex:i];

            // all views loading here, not so good
            viewController.view.frame = CGRectApplyAffineTransform(self.view.bounds, CGAffineTransformMakeTranslation(_scrollView.width * i, 0));
            [self.view addSubview:viewController.view];
        }
        _scrollView.contentSize = CGSizeApplyAffineTransform(self.view.size, CGAffineTransformMakeScale([_viewControllers count], 1));

        if ([_viewControllers count]) {
            self.selectedIndex = 0; // show the first page
        }
    }
}

- (void)setViewControllers:(NSArray *)viewControllers {
    [self setViewControllers:viewControllers animated:NO];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated {
    if (_selectedIndex != selectedIndex) {
        if (self.isViewAppearing) {
            [_selectedViewController viewWillDisappear:animated];
            [_selectedViewController viewDidDisappear:animated];
        }

        _selectedIndex = selectedIndex;
        _selectedViewController = [_viewControllers objectAtIndex:_selectedIndex];
        if (self.isViewAppearing) {
            [_selectedViewController viewWillAppear:YES];
            [_selectedViewController viewDidAppear:YES];
        }

        // set the content offset without triggering scrollViewDidScroll:
        [UIView animateWithDuration:animated ? .3 : 0 animations:^{
            CGRect bounds = _scrollView.bounds;
            bounds.origin.x = _scrollView.width * _selectedIndex;
            _scrollView.bounds = bounds;
        }];
    }
    self.title = _selectedViewController.title;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [self setSelectedIndex:selectedIndex animated:NO];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    UIViewController *viewController = nil;

    if (x < scrollView.width * _selectedIndex && x >= 0) {
        viewController = [_viewControllers objectAtIndex:_selectedIndex - 1];
    }
    if (x > scrollView.width * _selectedIndex && x < scrollView.width * ([_viewControllers count] - 1)) {
        viewController = [_viewControllers objectAtIndex:_selectedIndex + 1];
    }

    if (viewController && _appearingViewController != viewController) {
        _appearingViewController = viewController;
        [_appearingViewController viewWillAppear:YES];
        [_appearingViewController viewDidAppear:YES];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger page = scrollView.contentOffset.x / scrollView.width;
    if (page < [_viewControllers count]) {
        UIViewController *viewController = [_viewControllers objectAtIndex:page];
        if (_appearingViewController != viewController) {
            // not scrolled enough, index not changed, disappearing the new one
            [_appearingViewController viewWillDisappear:YES];
            [_appearingViewController viewDidDisappear:YES];
            _appearingViewController = _selectedViewController;
        }
        if (_selectedViewController != viewController) {
            // scrolled enough, index to change, disappearing the old one
            [_selectedViewController viewWillDisappear:YES];
            [_selectedViewController viewDidDisappear:YES];
            _selectedViewController = _appearingViewController;

            // let subclass know the index has been changed but do not trigger extra viewWillAppear/Disappear etc
            _selectedIndex = page;
            self.selectedIndex = _selectedIndex;
        }
    }
}

@end
