//
//  DRPControlsViewController.m
//  DR Player
//
//  Created by Richard Nees on 27/09/10.
//  Copyright 2010 Section Urbaine Software. All rights reserved.
//


#import "DRPControlsViewController.h"
#import "DRPControlsView.h"
#import "DRPControllerView.h"
#import "DRPTitleBar.h"
#import "DRPWidgetView.h"

#import "DRPAppDelegate.h"
#import "DRPMainWindow.h"
#import "DRPMainContentView.h"

#import "DRPStatusViewController.h"

@implementation DRPControlsViewController


- (void)awakeFromNib
{
    
	[[self.playbackButton cell] setBackgroundStyle:(NSBackgroundStyleRaised | NSBackgroundStyleDark)];
    [[self.playbackControlButton cell] setBackgroundStyle:(NSBackgroundStyleRaised | NSBackgroundStyleDark)];
    
	[[self.webLinkButton cell] setBackgroundStyle:(NSBackgroundStyleRaised | NSBackgroundStyleDark)];
	[[self.previousChannelButton cell] setBackgroundStyle:(NSBackgroundStyleRaised | NSBackgroundStyleDark)];
	[[self.nextChannelButton cell] setBackgroundStyle:(NSBackgroundStyleRaised | NSBackgroundStyleDark)];
	[[self.channelSelectorToggleButton cell] setBackgroundStyle:(NSBackgroundStyleRaised | NSBackgroundStyleDark)];
	[[self.listingsToggleButton cell] setBackgroundStyle:(NSBackgroundStyleRaised | NSBackgroundStyleDark)];
	[[self.prefsToggleButton cell] setBackgroundStyle:(NSBackgroundStyleRaised | NSBackgroundStyleDark)];
	
	[[self.volumeMin image] setTemplate:YES];
	[[self.volumeMin cell] setBackgroundStyle:(NSBackgroundStyleRaised | NSBackgroundStyleDark)];
	
	[[self.volumeMax image] setTemplate:YES];
	[[self.volumeMax cell] setBackgroundStyle:(NSBackgroundStyleRaised | NSBackgroundStyleDark)];
	
	[[self.fullScreenToggleButton image] setTemplate:YES];
	[[self.fullScreenToggleButton alternateImage] setTemplate:YES];
	
	[[self.fullScreenToggleButton cell] setBackgroundStyle:(NSBackgroundStyleRaised | NSBackgroundStyleDark)];
	
	self.titleBarView.frame = CGRectMake(self.titleBarView.frame.origin.x,
                                         self.view.bounds.size.height + self.titleBarView.frame.size.height,
                                         self.titleBarView.frame.size.width,
                                         self.titleBarView.frame.size.height
                                         );
	self.titleBarView.alphaValue = 0.0f;
		
	self.controllerHUDView.frame = CGRectMake(self.controllerHUDView.frame.origin.x,
                                              0.0f,
                                              self.controllerHUDView.frame.size.width,
                                              self.controllerHUDView.frame.size.height
                                              );
	self.controllerHUDView.alphaValue = 0.0f;
    
    
    
    
    self.channelIdView.alphaValue = 0.0f;
    
	[self.controllerHUDView layer].zPosition = 0.0f;
	[self.titleBarView layer].zPosition = 1.0f;
}

- (IBAction)closeWindow:sender
{
	[[NSApp delegate] closeWindow:nil];
}

- (IBAction)minimizeWindow:sender
{
	[[NSApp delegate] minimizeWindow:sender];
}

- (IBAction)zoomWindow:sender
{
	[[NSApp delegate] zoomCustom:sender];
}

- (IBAction)tooglePlayback:sender
{
    [[NSApp delegate] togglePlayback:nil];
}

- (IBAction)toogleSelectionView:sender
{
    [[NSApp delegate] showChannelSelection:nil];
}

- (IBAction)showPopover:sender
{
    [[[[NSApp delegate] statusViewController] channelSelectorPopover] showRelativeToRect:[self.controllerHUDView bounds]
                                                                                  ofView:self.controllerHUDView
                                                                           preferredEdge:NSMinYEdge];
    
}

#pragma mark Channel Selection

- (IBAction)selectAndPlayPreviousChannel:sender
{
    [[NSApp delegate] selectAndPlayPreviousChannel:sender];
}

- (IBAction)selectAndPlayNextChannel:sender
{
    [[NSApp delegate] selectAndPlayNextChannel:sender];
}

- (IBAction)muteMovieVolume:sender
{
    [[NSApp delegate] muteMovieVolume:sender];
}

- (IBAction)maxMovieVolume:sender;
{
    [[NSApp delegate] maxMovieVolume:sender];
}

- (void)showChannelId:sender
{
    if(self.autoHideChannelIdTimer)
	{
		[self.autoHideChannelIdTimer invalidate];
		self.autoHideChannelIdTimer = nil;
	}
    
    self.channelIdView.animator.alphaValue = 0.75f;
    
    self.autoHideChannelIdTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f
                                                                   target:self
                                                                 selector:@selector(hideChannelId:)
                                                                 userInfo:nil
                                                                  repeats:NO];
}

- (void)hideChannelId:sender
{
    self.channelIdView.animator.alphaValue = 0.0f;
    
    if(self.autoHideChannelIdTimer)
	{
		[self.autoHideChannelIdTimer invalidate];
		self.autoHideChannelIdTimer = nil;
	}
}

- (void)showUIControls:sender
{
    if (self.autoHideUIControlsTimer)
	{
		[self.autoHideUIControlsTimer invalidate];
		self.autoHideUIControlsTimer = nil;
	}
	
    self.isBeingAutoShown = YES;
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0.25f];
    [[NSAnimationContext currentContext] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [NSAnimationContext runAnimationGroup:
     ^(NSAnimationContext *context)
     {
         if ([[NSApp delegate] inFullScreenMode])
         {
             self.widgetView.animator.alphaValue = 0.0f;
             self.fullScreenToggleButton.animator.alphaValue = 0.0f;
         }
         else
         {
             self.widgetView.animator.alphaValue = 1.0f;
             self.fullScreenToggleButton.animator.alphaValue = 1.0f;
         }
         
         self.titleBarView.animator.frame
         = CGRectMake(self.titleBarView.frame.origin.x,
                      [[[[NSApp delegate] mainWindow] contentView] bounds].size.height - self.titleBarView.frame.size.height,
                      self.titleBarView.frame.size.width,
                      self.titleBarView.frame.size.height
                      );
         
         self.titleBarView.animator.alphaValue = 1.0f;
         
         
         self.controllerHUDView.animator.frame
         = CGRectMake(self.controllerHUDView.frame.origin.x,
                      0.0f,
                      self.controllerHUDView.frame.size.width,
                      self.controllerHUDView.frame.size.height
                      );
         
         self.controllerHUDView.animator.alphaValue = 1.0f;
     }
                        completionHandler:
     ^{
         self.isBeingAutoShown = NO;
     }];
    
    [NSAnimationContext endGrouping];
    
    self.autoHideUIControlsTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                                    target:self
                                                                  selector:@selector(hideUIControls:)
                                                                  userInfo:nil
                                                                   repeats:NO];
    
}

- (void)hideUIControls:sender
{
    BOOL shouldHide = YES;
    
    NSPoint mousePosition = [[[NSApp delegate] mainWindow] convertScreenToBase:[NSEvent mouseLocation]];
    
    if (NSPointInRect(mousePosition, self.controllerHUDView.frame))
        shouldHide = NO;
    
    if (NSPointInRect(mousePosition, self.titleBarView.frame))
        shouldHide = NO;
    
    if ([[[[NSApp delegate] statusViewController] channelSelectorPopover] isShown])
        shouldHide = NO;
        
	if (shouldHide)
	{
		
        if (self.autoHideUIControlsTimer)
        {
            [self.autoHideUIControlsTimer invalidate];
            self.autoHideUIControlsTimer = nil;
        }
        
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setDuration:0.5f];
        [[NSAnimationContext currentContext] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];

        [NSAnimationContext runAnimationGroup:
         ^(NSAnimationContext *context)
         {
             self.titleBarView.animator.frame
             = CGRectMake(self.titleBarView.frame.origin.x,
                          [[[[NSApp delegate] mainWindow] contentView] frame].size.height + self.titleBarView.frame.size.height,
                          self.titleBarView.frame.size.width,
                          self.titleBarView.frame.size.height
                          );
             
             self.titleBarView.animator.alphaValue = 0.0f;
             
             self.controllerHUDView.animator.frame
             = CGRectMake(self.controllerHUDView.frame.origin.x,
                          -self.controllerHUDView.frame.size.height,
                          self.controllerHUDView.frame.size.width,
                          self.controllerHUDView.frame.size.height
                          );
             
             self.controllerHUDView.animator.alphaValue = 0.0f;
         }
                            completionHandler:
         ^{
             
         }];
        
        [NSAnimationContext endGrouping];
        
        
        
    }
}

- (IBAction)toogleFullScreen:sender
{
    [self.titleBarView.window toggleFullScreen:nil];
}

@end
