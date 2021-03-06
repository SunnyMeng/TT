//
//  TTStyledTextParser.m
//  TTStyle
//
//  Created by shaohua on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTStyledElement.h"
#import "TTStyledImageNode.h"
#import "TTStyledLineBreakNode.h"
#import "TTStyledLinkNode.h"
#import "TTStyledTextNode.h"
#import "TTStyledTextParser.h"

@interface TTStyledTextParser ()

@property (nonatomic, retain) NSMutableString *chars;

@end

@implementation TTStyledTextParser

@synthesize rootNode = _rootNode;
@synthesize chars = _chars;

- (void)dealloc {
    [_rootNode release];
    [_chars release];
    [super dealloc];
}

- (void)addNode:(TTStyledNode *)node {
    if (!_rootNode) {
        _rootNode = [node retain];
    } else if (_topElement && !_topElement.firstChild) {
        _topElement.firstChild = node;
    } else {
        _lastNode.nextSibling = node;
    }
    _lastNode = node;
}

- (void)pushNode:(TTStyledElement *)element {
    [self addNode:element];
    _topElement = element;
}

- (void)popNode {
    _lastNode = _topElement;
    _topElement = _topElement.parentNode;
}

- (void)flushCharacters {
    if ([_chars length]) {
        [self addNode:[[[TTStyledTextNode alloc] initWithText:_chars] autorelease]];
        self.chars = nil;
    }
}

#pragma mark -
#pragma mark Public
- (void)parseXHTML:(NSString *)html {
    NSString *document = [NSString stringWithFormat:@"<x>%@</x>", html];
    NSData *data = [document dataUsingEncoding:[html fastestEncoding]];
    NSXMLParser *parser = [[[NSXMLParser alloc] initWithData:data] autorelease];
    parser.delegate = self;
    [parser parse];
}

#pragma mark -
#pragma mark NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    [self flushCharacters];

    NSString *tag = [elementName lowercaseString];
    if ([tag isEqualToString:@"a"]) {
        TTStyledLinkNode *node = [[[TTStyledLinkNode alloc] initWithURL:[attributeDict objectForKey:@"href"]] autorelease];
        [self pushNode:node];
    } else if ([tag isEqualToString:@"img"]) {
        TTStyledImageNode *node = [[[TTStyledImageNode alloc] initWithURL:[attributeDict objectForKey:@"src"]] autorelease];
        NSString *width = [attributeDict objectForKey:@"width"];
        if (width) {
            node.width = [width floatValue];
        }
        NSString *height = [attributeDict objectForKey:@"height"];
        if (height) {
            node.height = [height floatValue];
        }
        [self pushNode:node];
    } else if ([tag isEqualToString:@"br"]) {
        TTStyledLineBreakNode *node = [[[TTStyledLineBreakNode alloc] init] autorelease];
        [self pushNode:node];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!_chars) {
        _chars = [string mutableCopy];
    } else {
        [_chars appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    [self flushCharacters];
    [self popNode];
}

@end
