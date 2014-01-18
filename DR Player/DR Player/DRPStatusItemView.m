//
//  RFStatusItemView.m
//  Radio24syv
//
//  Created by Richard Nees on 30/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DRPStatusItemView.h"

@implementation DRPStatusItemView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        _mouseDown = NO;
    }
    
    return self;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    self.mouseDown = YES;
    [self setNeedsDisplay:YES];
    
    if([theEvent clickCount] > 1) 
    {
        [NSApp sendAction:self.rightAction to:self.target from:self];
    } 
    else if([theEvent modifierFlags] & NSControlKeyMask) 
    {
        [NSApp sendAction:self.rightAction to:self.target from:self];
    } 
    else
    {
        [NSApp sendAction:self.action to:self.target from:self];
    }
}

- (void)rightMouseDown:(NSEvent *)theEvent
{
    self.mouseDown = YES;
    [self setNeedsDisplay:YES];
    [NSApp sendAction:self.rightAction to:self.target from:self];
}

- (void)mouseUp:(NSEvent *)theEvent 
{
    self.mouseDown = NO;
    [self setNeedsDisplay:YES];
}

- (void)rightMouseUp:(NSEvent *)theEvent 
{
    self.mouseDown = NO;
    [self setNeedsDisplay:YES];
}
- (void)dealloc 
{
    self.image = nil;
    self.alternateImage = nil;
}
- (void)drawRect:(NSRect)rect 
{
    if (self.isMouseDown)
    {
        [[NSColor selectedMenuItemColor] set];
         NSRectFill(rect);
        [self.alternateImage drawInRect:self.bounds fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:0.5];
    }
    else
    {
        [self.image drawInRect:self.bounds fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    }
}

@end
