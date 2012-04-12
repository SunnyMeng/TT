//
//  TTStyledLayout.m
//  TTStyle
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTGlobalCore.h"
#import "TTGlobalStyle.h"
#import "TTStyledBoxFrame.h"
#import "TTStyledElement.h"
#import "TTStyledImageFrame.h"
#import "TTStyledImageNode.h"
#import "TTStyledInlineFrame.h"
#import "TTStyledLayout.h"
#import "TTStyledLineBreakNode.h"
#import "TTStyledLinkNode.h"
#import "TTStyledNode.h"
#import "TTStyledText.h"
#import "TTStyledTextFrame.h"
#import "TTStyledTextNode.h"
#import "TTURLCache.h"

@interface TTStyledLayout ()

- (void)layout:(TTStyledNode *)node container:(TTStyledElement *)element;

@end

@implementation TTStyledLayout

@synthesize rootFrame = _rootFrame;
@synthesize width = _width;
@synthesize height = _height;
@synthesize font = _font;
@synthesize textAlignment = _textAlignment;
@synthesize invalidImages = _invalidImages;
@synthesize lineBreakMode = _lineBreakMode;

- (id)initWithRootNode:(TTStyledNode *)rootNode {
    if (self = [super init]) {
        _rootNode = [rootNode retain];
    }
    return self;
}

- (void)dealloc {
    [_rootFrame release];
    [_invalidImages release];
    [_rootNode release];
    [_font release];
    [super dealloc];
}

- (void)offsetFrame:(TTStyledFrame *)frame byY:(CGFloat)y {
    frame.y += y;

    if ([frame isKindOfClass:[TTStyledInlineFrame class]]) {
        TTStyledInlineFrame *inlineFrame = (TTStyledInlineFrame *)frame;
        TTStyledFrame *child = inlineFrame.firstChildFrame;
        while (child) {
            [self offsetFrame:child byY:y];
            child = child.nextFrame;
        }
    }
}

- (void)offsetFrame:(TTStyledFrame *)frame byX:(CGFloat)x {
    frame.x += x;

    if ([frame isKindOfClass:[TTStyledInlineFrame class]]) {
        TTStyledInlineFrame *inlineFrame = (TTStyledInlineFrame *)frame;
        TTStyledFrame *child = inlineFrame.firstChildFrame;
        while (child) {
            [self offsetFrame:child byX:x];
            child = child.nextFrame;
        }
    }
}

- (void)expandLineWidth:(CGFloat)width {
    _lineWidth += width;
    TTStyledInlineFrame *inlineFrame = _inlineFrame;
    while (inlineFrame) {
        inlineFrame.width += width;
        inlineFrame = inlineFrame.inlineParentFrame;
    }
}

- (void)inflateLineHeight:(CGFloat)height {
    if (height > _lineHeight) {
        _lineHeight = height;
    }
    TTStyledInlineFrame *inlineFrame = _inlineFrame;
    while (inlineFrame) {
        if (height > inlineFrame.height) {
            inlineFrame.height = height;
        }
        inlineFrame = inlineFrame.inlineParentFrame;
    }
}

- (void)addFrame:(TTStyledFrame *)frame {
    if (!_rootFrame) {
        _rootFrame = [frame retain];
    } else if (_topFrame && !_topFrame.firstChildFrame) {
        _topFrame.firstChildFrame = frame;
    } else {
        _lastFrame.nextFrame = frame;
    }
    _lastFrame = frame;
}

- (void)pushFrame:(TTStyledBoxFrame *)frame {
    [self addFrame:frame];
    frame.parentFrame = _topFrame;
    _topFrame = frame;
}

- (void)popFrame {
    _lastFrame = _topFrame;
    _topFrame = _topFrame.parentFrame;
}

- (TTStyledFrame *)addContentFrame:(TTStyledFrame *)frame {
    [self addFrame:frame];
    if (!_lineFirstFrame) {
        _lineFirstFrame = frame;
    }
    _x += frame.width;
    return frame;
}

- (void)addContentFrame:(TTStyledFrame *)frame width:(CGFloat)width height:(CGFloat)height {
    frame.bounds = CGRectMake(_x, _height, width, height);
    [self addContentFrame:frame];
}

- (TTStyledInlineFrame *)addInlineFrame:(TTStyledElement *)element {
    TTStyledInlineFrame *frame = [[[TTStyledInlineFrame alloc] initWithElement:element] autorelease];
    frame.bounds = CGRectMake(_x, _height, 0, 0);
    [self pushFrame:frame];
    if (!_lineFirstFrame) {
        _lineFirstFrame = frame;
    }
    return frame;
}

- (TTStyledInlineFrame *)cloneInlineFrame:(TTStyledInlineFrame *)frame {
    TTStyledInlineFrame *parent = frame.inlineParentFrame;
    if (parent) {
        [self cloneInlineFrame:parent];
    }
    TTStyledInlineFrame *clone = [self addInlineFrame:frame.element];
    clone.inlinePreviousFrame = frame;
    frame.inlineNextFrame = clone;
    return clone;
}

- (void)breakLine {
    // Vertically align all frames on the current line
    if (_lineFirstFrame.nextFrame) {
        TTStyledFrame *frame;

        // Find the descender that descends the farthest below the baseline.
        // font.descender is a negative number if the descender descends below
        // the baseline (as most descenders do), but can also be a positive
        // number for a descender above the baseline.
        CGFloat lowestDescender = MAXFLOAT;
        frame = _lineFirstFrame;
        while (frame) {
            lowestDescender = MIN(lowestDescender, _font.descender);
            frame = frame.nextFrame;
        }

        frame = _lineFirstFrame;
        while (frame) {
            // Align to the text baseline
            if (frame.height < _lineHeight) {
                [self offsetFrame:frame byY:(_lineHeight - (frame.height - (lowestDescender - _font.descender)))];
            }
            frame = frame.nextFrame;
        }
    }

    // Horizontally align all frames on current line if required
    if (_textAlignment != UITextAlignmentLeft) {
        CGFloat remainingSpace = _width - _lineWidth;
        CGFloat offset = _textAlignment == UITextAlignmentCenter ? remainingSpace / 2 : remainingSpace;

        TTStyledFrame *frame = _lineFirstFrame;
        while (frame) {
            [self offsetFrame:frame byX:offset];
            frame = frame.nextFrame;
        }
    }

    _height += _lineHeight;

    _lineWidth = 0;
    _lineHeight = 0;
    _x = 0;
    _lineFirstFrame = nil;

    if (_inlineFrame) {
        while ([_topFrame isKindOfClass:[TTStyledInlineFrame class]]) {
            [self popFrame];
        }
        _inlineFrame = [self cloneInlineFrame:_inlineFrame];
    }
}

- (TTStyledFrame *)addFrameForText:(NSString *)text element:(TTStyledElement *)element width:(CGFloat)width height:(CGFloat)height {
    TTStyledTextFrame *frame = [[[TTStyledTextFrame alloc] initWithText:text element:element] autorelease];
    frame.font = _font;
    if ([element isKindOfClass:[TTStyledLinkNode class]]) {
        frame.textColor = TTSTYLEVAR(linkTextColor);
    }
    [self addContentFrame:frame width:width height:height];
    return frame;
}

// returns YES if no truncated
- (BOOL)layoutElement:(TTStyledElement *)elt {
    if ([elt isKindOfClass:[TTStyledLineBreakNode class]]) {
        if (_lineBreakMode == UILineBreakModeClip) {
            return NO;
        }
        if (!_lineHeight) {
            _lineHeight = _font.lineHeight;
        }
        [self breakLine];
    } else if (elt.firstChild) {
        _inlineFrame = [self addInlineFrame:elt];
        [self layout:elt.firstChild container:elt];
        _inlineFrame = _inlineFrame.inlineParentFrame;
        [self popFrame];
    }
    return YES;
}

// returns YES if no truncated
- (BOOL)layoutImage:(TTStyledImageNode *)imageNode container:(TTStyledElement *)element {
    UIImage *image = imageNode.image;
    if (!image && imageNode.URL) {
        if (!_invalidImages) {
            _invalidImages = TTCreateNonRetainingArray();
        }
        [_invalidImages addObject:imageNode];
    }

    CGFloat contentWidth = imageNode.width ?: image.size.width;
    CGFloat contentHeight = imageNode.height ?: image.size.height;

    if (_lineWidth + contentWidth > _width) {
        if (_lineWidth) {
            // The image will be placed on the next line, so create a new frame for
            // the current line and mark it with a line break
            [self breakLine];
            if (_lineBreakMode == UILineBreakModeClip) {
                return NO;
            }
        } else if (contentWidth > _width) {
            // crop to _width
            contentWidth = _width;
        }
    }

    TTStyledImageFrame *frame = [[[TTStyledImageFrame alloc] initWithNode:imageNode element:element] autorelease];
    [self addContentFrame:frame width:contentWidth height:contentHeight];
    [self expandLineWidth:contentWidth];
    [self inflateLineHeight:contentHeight];
    return YES;
}

// returns YES if no truncated
- (BOOL)layoutText:(TTStyledTextNode *)textNode container:(TTStyledElement *)element {
    NSString *text = textNode.text;

    if (textNode == _rootNode && !textNode.nextSibling) {
        // This is the only node, so measure it all at once and move on
        CGSize textSize = [text sizeWithFont:_font constrainedToSize:CGSizeMake(_width, CGFLOAT_MAX) lineBreakMode:_lineBreakMode];
        [self addFrameForText:text element:element width:textSize.width height:textSize.height];
        _height = textSize.height;
        return YES;
    }

    CGSize textSize = [text sizeWithFont:_font];
    if (_lineWidth + textSize.width > _width) {
        NSMutableString *line = [NSMutableString string];
        for (NSInteger i = 0; i < [text length];) {
            NSRange charRange = [text rangeOfComposedCharacterSequenceAtIndex:i];
            NSString *ch = [text substringWithRange:charRange];
            CGSize lineSize = [[line stringByAppendingString:ch] sizeWithFont:_font];
            if (_lineWidth + lineSize.width > _width) {
                if ([line length]) {
                    CGSize lineSize = [line sizeWithFont:_font];
                    [self addFrameForText:line element:element width:lineSize.width height:lineSize.height];
                    [self expandLineWidth:lineSize.width];
                    [self inflateLineHeight:lineSize.height];
                }
                [self breakLine];
                if (_lineBreakMode == UILineBreakModeClip) {
                    return NO;
                }
                line = [NSMutableString stringWithString:ch];
            } else {
                [line appendString:ch];
            }
            i += charRange.length;
        }

        if ([line length]) {
            CGSize lineSize = [line sizeWithFont:_font];
            [self addFrameForText:line element:element width:lineSize.width height:lineSize.height];
            [self expandLineWidth:lineSize.width];
            [self inflateLineHeight:textSize.height];
        }
    } else {
        [self addFrameForText:text element:element width:textSize.width height:textSize.height];
        [self expandLineWidth:textSize.width];
        [self inflateLineHeight:textSize.height];
    }
    return YES;
}

- (void)layout:(TTStyledNode *)node container:(TTStyledElement *)element {
    while (node) {
        // <img> is a TTStyledElement, check first
        if ([node isKindOfClass:[TTStyledImageNode class]]) {
            if (![self layoutImage:(TTStyledImageNode *)node container:element]) {
                break; // if truncated
            }
        } else if ([node isKindOfClass:[TTStyledElement class]]) {
            // for <br> & <a>
            if (![self layoutElement:(TTStyledElement *)node]) {
                break; // if truncated
            }
        } else if ([node isKindOfClass:[TTStyledTextNode class]]) {
            if (![self layoutText:(TTStyledTextNode *)node container:element]) {
                break; // if truncated
            }
        }
        node = node.nextSibling;
    }
}

#pragma mark -
#pragma mark Public
- (void)layout {
    [self layout:_rootNode container:nil];
    if (_lineWidth) {
        [self breakLine];
    }
}

@end
