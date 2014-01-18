//
//  DRPHudBackgroundView.m
//  DR Player
//
//  Created by Richard Nees on 05/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DRPHudBackgroundView.h"

@implementation DRPHudBackgroundView

- (void)dealloc
{
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    _foregroundGradient = [[NSGradient alloc] initWithColors:
                                   @[[NSColor colorWithDeviceWhite:0.333f alpha:0.7f],
                                    [NSColor colorWithDeviceWhite:0.222f alpha:0.7f]]];
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	NSRect bgRect = [self bounds];
    [[NSColor clearColor] set];
    NSRectFill(bgRect);
    
    [self.foregroundGradient drawInRect:bgRect relativeCenterPosition:NSZeroPoint];
    [NSImage drawNoiseImage];
}

@end
