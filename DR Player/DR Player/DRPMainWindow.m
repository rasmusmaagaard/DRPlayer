//
//  DRPMainWindow.m
//  DR Player
//
//  Created by Richard Nees on 14/02/10.
//  Copyright 2010 Section Urbaine Software. All rights reserved.
//

#import "DRPAppDelegate.h"
#import "DRPControlsViewController.h"
#import "DRPMainWindow.h"

//#import <objc/runtime.h>

@implementation DRPMainWindow

- (BOOL)isMovableByWindowBackground
{
    if ([[NSApp delegate] inFullScreenMode])
        return NO;
    return YES;
}


#pragma mark Initialization


- (void)awakeFromNib
{
	if ([[NSUserDefaults standardUserDefaults] boolForKey:DRPMainWindowLevel])
	{
		[self setLevel:NSModalPanelWindowLevel];
	}
	else
	{
		[self setLevel:NSNormalWindowLevel];
		
	}
	
	NSRect newMainWindowFrame = [self frame];
	NSRect newVisibleScreenFrame = [[self screen] visibleFrame];
	
	if (newMainWindowFrame.origin.x < newVisibleScreenFrame.origin.x)
	{
		newMainWindowFrame.origin.x = newVisibleScreenFrame.origin.x + 5;
	}
	else if (newMainWindowFrame.origin.x > (newVisibleScreenFrame.size.width - newMainWindowFrame.size.width))
	{
		newMainWindowFrame.origin.x = (newVisibleScreenFrame.size.width - newMainWindowFrame.size.width);
	}
	
	if (newMainWindowFrame.origin.y < newVisibleScreenFrame.origin.y)
	{
		newMainWindowFrame.origin.y = newVisibleScreenFrame.origin.y +  5;
	}
	
	[self setFrame:newMainWindowFrame display:YES animate:YES];
	
    [self setOpaque:NO];
	[self setHasShadow:YES];
	[self setBackgroundColor:[NSColor clearColor]];
	[self setAspectRatio:NSMakeSize(16.0, 9.0)];
    [self setAcceptsMouseMovedEvents:YES];
}

#pragma mark Misc


- (BOOL)canBecomeKeyWindow
{
    return YES;
}

#pragma mark Key Events TO BE IMPLEMENTED
- (void)keyDown:(NSEvent *)event
{
    if ([event keyCode] == 49)
	{
		//Spacebar to Play/Pause movie playback
        [[NSApp delegate] togglePlayback:nil];
	}
    else
    {
        [super keyDown:event];
    }
}

@end
