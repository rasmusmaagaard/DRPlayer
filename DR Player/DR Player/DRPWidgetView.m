//
//  DRPWidgetView.m
//  DR Player
//
//  Created by Richard Nees on 16/02/10.
//  Copyright 2010 Section Urbaine Software. All rights reserved.
//

#import "DRPWidgetView.h"


@implementation DRPWidgetView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];

    [self setPostsFrameChangedNotifications:YES];
    
    NSRect trackingRect = [self frame];
    trackingRect.origin = NSZeroPoint;
    _viewTrackingRect = [self addTrackingRect:trackingRect owner:self userData:nil assumeInside:NO];
    
    return self;
}

- (void)refresh
{
    if (self.isActiveState == YES)
    {
    	[self.closeButton setImage:[NSImage imageNamed:@"CloseButtonNormal"]];
        [self.miniaturizeButton setImage:[NSImage imageNamed:@"MinimizeButtonNormal"]];
        [self.zoomButton setImage:[NSImage imageNamed:@"ZoomButtonNormal"]];
    }
    else
    {
    	[self.closeButton setImage:[NSImage imageNamed:@"CloseButtonInactive"]];
        [self.miniaturizeButton setImage:[NSImage imageNamed:@"MinimizeButtonInactive"]];
        [self.zoomButton setImage:[NSImage imageNamed:@"ZoomButtonInactive"]];
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
}

- (void)mouseEntered:(NSEvent *)theEvent
{
	[self.closeButton setImage:[NSImage imageNamed:@"CloseButtonRollover"]];
	[self.miniaturizeButton setImage:[NSImage imageNamed:@"MinimizeButtonRollover"]];
	[self.zoomButton setImage:[NSImage imageNamed:@"ZoomButtonRollover"]];
}

-(void)mouseExited:(NSEvent *)theEvent
{
    if (self.isActiveState == YES)
    {
    	[self.closeButton setImage:[NSImage imageNamed:@"CloseButtonNormal"]];
        [self.miniaturizeButton setImage:[NSImage imageNamed:@"MinimizeButtonNormal"]];
        [self.zoomButton setImage:[NSImage imageNamed:@"ZoomButtonNormal"]];
    }
    else
    {
    	[self.closeButton setImage:[NSImage imageNamed:@"CloseButtonInactive"]];
        [self.miniaturizeButton setImage:[NSImage imageNamed:@"MinimizeButtonInactive"]];
        [self.zoomButton setImage:[NSImage imageNamed:@"ZoomButtonInactive"]];
    }
}

@end
