//
//  DRPFullscreenWidgetView.m
//  DR Player
//
//  Created by Richard Nees on 27/10/11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DRPFullscreenWidgetView.h"

@implementation DRPFullscreenWidgetView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    
    NSRect trackingRect = [self frame];
    trackingRect.origin = NSZeroPoint;
    _viewTrackingRect = [self addTrackingRect:trackingRect owner:self userData:nil assumeInside:NO];
	return self;
}

- (void)awakeFromNib
{
	[self.fullscreenButton setImage:[NSImage imageNamed:@"FullscreenButtonRollover"]];
	[self.fullscreenButton setAlternateImage:[NSImage imageNamed:@"FullscreenButtonAlternate"]];
}

//- (void)drawRect:(NSRect)dirtyRect 
//{
//    // Drawing code here.
//}

- (void)mouseEntered:(NSEvent *)theEvent
{
	[self.fullscreenButton setImage:[NSImage imageNamed:@"FullscreenButtonRollover"]];
}

-(void)mouseExited:(NSEvent *)theEvent
{
	[self.fullscreenButton setImage:[NSImage imageNamed:@"FullscreenButtonRollover"]];
}

@end
