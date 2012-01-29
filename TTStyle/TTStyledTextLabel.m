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
@synthesize font = _font;
@synthesize textAlignment = _textAlignment;
@synthesize textColor = _textColor;

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
    if (_textColor) {
        [_textColor setFill];
    } else {
        [[UIColor blackColor] setFill]; // default
    }

    [_text drawAtPoint:CGPointZero];
}

- (CGSize)sizeThatFits:(CGSize)size {
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
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
- (void)setText:(TTStyledText *)text {
    if (_text != text) {
        _text.delegate = nil;
        [_text release];

        _text = [text retain];
        _text.delegate = self;
        _text.font = _font;
        _text.textAlignment = _textAlignment;
        _text.width = self.width;
        [self setNeedsDisplay];
    }
}

- (void)setTextAlignment:(UITextAlignment)textAlignment {
    if (_textAlignment != textAlignment) {
        _textAlignment = textAlignment;
        _text.textAlignment = _textAlignment;
        [self setNeedsDisplay];
    }
}

- (void)setFont:(UIFont *)font {
    if (_font != font) {
        [_font release];
        _font = [font retain];
        _text.font = _font;
        [self setNeedsDisplay];
    }
}

- (void)setTextColor:(UIColor *)textColor {
    if (_textColor != textColor) {
        [_textColor release];
        _textColor = [textColor retain];
        [self setNeedsDisplay];
    }
}

- (void)setWidth:(CGFloat)width {
    if (_text.width != width) {
        _text.width = width;
        [self setNeedsDisplay];
    }
    [super setWidth:width];
}

- (void)setSize:(CGSize)size {
    if (_text.width != size.width) {
        _text.width = size.width;
        [self setNeedsDisplay];
    }
    [super setSize:size];
}

- (void)setFrame:(CGRect)frame {
    if (_text.width != frame.size.width) {
        _text.width = frame.size.width;
        [self setNeedsDisplay];
    }
    [super setFrame:frame];
}

- (void)setBounds:(CGRect)bounds {
    if (_text.width != bounds.size.width) {
        _text.width = bounds.size.width;
        [self setNeedsDisplay];
    }
    [super setBounds:bounds];
}

#pragma mark -
#pragma mark TTStyledTextDelegate
- (void)styledTextNeedsDisplay:(TTStyledText  *)text {
    [self setNeedsDisplay];
}

@end