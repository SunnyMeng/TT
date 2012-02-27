//
//  TTStyledText.m
//  TTStyle
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTStyledImageNode.h"
#import "TTStyledLayout.h"
#import "TTStyledNode.h"
#import "TTStyledText.h"
#import "TTStyledTextDelegate.h"
#import "TTStyledTextFrame.h"
#import "TTStyledTextParser.h"
#import "TTURLRequest.h"

@interface TTStyledText ()

@property (nonatomic, retain) NSMutableArray *imageRequests;
@property (nonatomic, retain) NSMutableArray *invalidImages;
@property (nonatomic, retain) TTStyledFrame *rootFrame;

- (void)stopLoadingImages;

@end


@implementation TTStyledText

@synthesize rootNode = _rootNode;
@synthesize rootFrame = _rootFrame;
@synthesize width = _width;
@synthesize height = _height;
@synthesize font = _font;
@synthesize textAlignment = _textAlignment;
@synthesize delegate = _delegate;
@synthesize lineBreakMode = _lineBreakMode;
@synthesize imageRequests = _imageRequests;
@synthesize invalidImages = _invalidImages;

- (id)initWithNode:(TTStyledNode *)rootNode {
    if (self = [super init]) {
        _rootNode = [rootNode retain];
        _lineBreakMode = UILineBreakModeCharacterWrap;
    }
    return self;
}

- (void)dealloc {
    [self stopLoadingImages];

    [_invalidImages release];
    [_imageRequests release];
    [_font release];
    [_rootNode release];
    [_rootFrame release];
    [super dealloc];
}

+ (TTStyledText *)textFromXHTML:(NSString *)source {
    if (![source length]) {
        return nil;
    }
    TTStyledTextParser *parser = [[[TTStyledTextParser alloc] init] autorelease];
    [parser parseXHTML:source];
    if (parser.rootNode) {
        return [[[TTStyledText alloc] initWithNode:parser.rootNode] autorelease];
    }
    return nil;
}

- (void)stopLoadingImages {
    if (_imageRequests) {
        NSMutableArray *requests = [_imageRequests retain];
        self.imageRequests = nil;

        if (!_invalidImages) {
            self.invalidImages = [NSMutableArray array];
        }

        for (TTURLRequest *request in requests) {
            [_invalidImages addObject:request.weakRef];
            [request cancel];
        }
        [requests release];
    }
}

- (void)loadImages {
    [self stopLoadingImages];

    if (_delegate && _invalidImages) {
        for (TTStyledImageNode *imageNode in _invalidImages) {
            if (imageNode.URL) {
                TTURLRequest *request = [TTURLRequest requestWithURL:imageNode.URL delegate:self];
                request.weakRef = imageNode;
                [request send];
            }
        }
        self.invalidImages = nil;
    }
}

- (void)layoutFrames {
    TTStyledLayout *layout = [[[TTStyledLayout alloc] initWithRootNode:_rootNode] autorelease];
    NSAssert(_width && _font, @"both values mandatory");
    layout.width = _width;
    layout.font = _font;
    layout.textAlignment = _textAlignment;
    layout.lineBreakMode = _lineBreakMode;
    [layout layout];

    _height = ceil(layout.height);
    self.rootFrame = layout.rootFrame;

    self.invalidImages = layout.invalidImages;
    [self loadImages];
}

- (void)layoutIfNeeded {
    if (!_rootFrame) {
        [self layoutFrames];
    }
}

- (TTStyledFrame *)rootFrame {
    [self layoutIfNeeded];
    return _rootFrame;
}

- (CGFloat)height {
    [self layoutIfNeeded];
    return _height;
}

- (CGFloat)realWidth {
    CGRect rect = CGRectZero;
    for (TTStyledFrame *frame = self.rootFrame; frame; frame = frame.nextFrame) {
        rect = CGRectUnion(rect, frame.bounds);
    }
    return rect.size.width;
}

- (void)setWidth:(CGFloat)width {
    if (_width != width) {
        _width = width;
        self.rootFrame = nil;
    }
}

- (TTStyledBoxFrame *)hitTest:(CGPoint)point {
    return [self.rootFrame hitTest:point];
}

- (void)drawAtPoint:(CGPoint)point {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, point.x, point.y);

    TTStyledFrame *frame = self.rootFrame;
    while (frame) {
        [frame drawInRect:frame.bounds];
        frame = frame.nextFrame;
    }
    CGContextRestoreGState(ctx);
}

#pragma mark -
#pragma mark TTURLRequestDelegate
- (void)requestDidStartLoad:(TTURLRequest *)request {
    if (!_imageRequests) {
        _imageRequests = [[NSMutableArray alloc] init];
    }
    [_imageRequests addObject:request];
}

- (void)requestDidFinishLoad:(TTURLRequest *)request {
    TTStyledImageNode *imageNode = request.weakRef;
    imageNode.image = [request responseImage];
    [_imageRequests removeObject:request];
    [_delegate styledTextNeedsDisplay:self];
}

- (void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error {
    [_imageRequests removeObject:request];
}

@end
