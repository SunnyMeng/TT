//
//  TTStyledTextLabel.m
//  TTStyle
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTStyledBoxFrame.h"
#import "TTStyledInlineFrame.h"
#import "TTStyledText.h"
#import "TTStyledTextLabel.h"
#import "UIViewAdditions.h"

@implementation TTStyledTextLabel

@synthesize text = _text;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    [_text release];
    [super dealloc];
}

- (void)drawRect:(CGRect)rect {
    [_text drawAtPoint:CGPointZero];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _text.width = self.width;
}

- (CGSize)sizeThatFits:(CGSize)size {
    [self layoutIfNeeded];
    return CGSizeMake(_text.width, _text.height);
}

- (void)setHighlighted:(BOOL)highlighted forFrame:(TTStyledBoxFrame *)frame {
    if ([frame isKindOfClass:[TTStyledInlineFrame class]]) {
        TTStyledInlineFrame *inlineFrame = (TTStyledInlineFrame *)frame;
        while (inlineFrame.inlinePreviousFrame) {
            inlineFrame = inlineFrame.inlinePreviousFrame;
        }
        while (inlineFrame) {
            inlineFrame.highlighted = highlighted;
            inlineFrame = inlineFrame.inlineNextFrame;
        }
    } else {
        frame.highlighted = highlighted;
    }
}

- (void)clearHightlighedDelayed {
    [self setHighlighted:NO forFrame:_highlightedFrame];
    _highlightedFrame = nil;
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];

    TTStyledBoxFrame *frame = [_text hitTest:point];
    if (frame) {
        _highlightedFrame = frame;
        [self setHighlighted:YES forFrame:frame];
        [self setNeedsDisplay];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_highlightedFrame) {
        [self performSelector:@selector(clearHightlighedDelayed) withObject:nil afterDelay:.1];
    }
    [super touchesEnded:touches withEvent:event];
}

#pragma mark -
#pragma mark Public
- (void)setText:(TTStyledText*)text {
    if (_text != text) {
        _text.delegate = nil;
        [_text release];

        _text = [text retain];
        _text.delegate = self;
        [self setNeedsLayout];
        [self setNeedsDisplay];
    }
}

#pragma mark -
#pragma mark TTStyledTextDelegate
- (void)styledTextNeedsDisplay:(TTStyledText  *)text {
    [self setNeedsDisplay];
}

@end
