//
//  DRPStatusViewController.m
//  Radio24syv
//
//  Created by Richard Nees on 27/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DRPListingsTableView.h"
#import "DRPStatusViewController.h"
#import "DRPAppDelegate.h"

@interface DRPStatusViewController(Private)
- (void)handlePlaybackStart:(NSNotification *)note;
- (void)handlePlaybackStop:(NSNotification *)note;
- (void)updateMenuProgressStringMainThread:(NSNotification*)note;
- (void)updateMenuProgressStringAnyThread:(NSNotification*)note;
@end

@implementation DRPStatusViewController

- (void)updateCurrentListing
{
    [self.selectedListingsArrayController setContent:[[NSApp delegate] currentListing]];
}

- (void)handlePlaybackStart:(NSNotification *)note
{
    [self.playbackButton setState:NSOnState];
}

- (void)handlePlaybackStop:(NSNotification *)note
{
    [self.selectedListingsArrayController setContent:nil];
    [self.playbackButton setState:NSOffState];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:DRPlayerPlaybackInternalStart];
    [[NSNotificationCenter defaultCenter] removeObserver:DRPlayerPlaybackInternalStop];
}

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(handlePlaybackStart:) 
                                                 name:DRPlayerPlaybackInternalStart 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(handlePlaybackStop:) 
                                                 name:DRPlayerPlaybackInternalStop 
                                               object:nil];
    
    [self.channelsArrayController bind:@"content" toObject:[[NSApp delegate] channelsArrayController] withKeyPath:@"content" options:nil];
    [self.channelsArrayController bind:@"selectionIndexes" toObject:[[NSApp delegate] channelsArrayController] withKeyPath:@"selectionIndexes" options:nil];
    
    [self.listingsArrayController bind:@"content" toObject:[[NSApp delegate] listingsArrayController] withKeyPath:@"content" options:nil];
    [self.listingsArrayController bind:@"selectionIndexes" toObject:[[NSApp delegate] listingsArrayController] withKeyPath:@"selectionIndexes" options:nil];

    [self.selectedListingsArrayController setContent:[NSMutableDictionary dictionary]];
     
//    [self updateCurrentListing];

    [self.playbackButton setState:self.channelsArrayController.selectedObjects.count ? NSOnState:NSOffState];

    [[self.playbackButton cell] setBackgroundStyle:(NSBackgroundStyleRaised | NSBackgroundStyleDark)];
    
    [[self.previousChannelButton cell] setBackgroundStyle:(NSBackgroundStyleRaised | NSBackgroundStyleDark)];
	[[self.nextChannelButton cell] setBackgroundStyle:(NSBackgroundStyleRaised | NSBackgroundStyleDark)];
	
	[[self.volumeMin image] setTemplate:YES];
	[[self.volumeMin cell] setBackgroundStyle:(NSBackgroundStyleRaised | NSBackgroundStyleDark)];
	
	[[self.volumeMax image] setTemplate:YES];
	[[self.volumeMax cell] setBackgroundStyle:(NSBackgroundStyleRaised | NSBackgroundStyleDark)];

    [[self.closeDescriptionButton cell] setBackgroundStyle:(NSBackgroundStyleRaised | NSBackgroundStyleDark)];
    [[self.openWeblinkButton cell] setBackgroundStyle:(NSBackgroundStyleRaised | NSBackgroundStyleDark)];

    self.listingsContainerTableView.frame = self.listingsContainerView.frame;
    [self.listingsContainerView addSubview:self.listingsContainerTableView];
    
}

- (IBAction)togglePlayback:sender
{
    [[NSApp delegate] togglePlayback:sender];
}

#pragma mark Channel Selection

- (IBAction)openChannelSelector:sender
{
    [self.channelSelectorPopover showRelativeToRect:[sender bounds]
                                        ofView:sender
                                 preferredEdge:NSMaxYEdge];
}

- (IBAction)selectAndPlayChannelFromCollection:sender
{    
    [self.channelSelectorPopover close];
    [[NSApp delegate] playChannel:sender];
}

- (IBAction)selectAndPlayPreviousChannel:sender
{
    [[NSApp delegate] selectAndPlayPreviousChannel:sender];
}

- (IBAction)selectAndPlayNextChannel:sender
{
    [[NSApp delegate] selectAndPlayNextChannel:sender];
}



- (IBAction)refresh:sender
{
    BOOL altKeyDown = (([[NSApp currentEvent] modifierFlags] & NSShiftKeyMask) == NSShiftKeyMask);
    
    if (altKeyDown)
    {
        [[NSApp delegate] refreshListings:sender];
    }
    [[NSApp delegate] refreshChannels:sender];
}

- (IBAction)openProgramURL:sender
{
	NSString *programURLString = self.currentListingsArrayController.selectedObjects[0][@"ppu_www_url"];
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[NSString localizedStringWithFormat:@"http://%@", programURLString]]];
}

- (IBAction)muteMovieVolume:sender
{
    [[NSApp delegate] muteMovieVolume:sender];
}

- (IBAction)maxMovieVolume:sender;
{
    [[NSApp delegate] maxMovieVolume:sender];
}

- (void)performCloseProgramDescription:sender
{
    self.listingsContainerTableView.frame = self.listingsContainerView.frame;
    [self.listingsContainerView replaceSubview:(self.listingsContainerView.subviews)[0]
                                          with:self.listingsContainerTableView];
}

- (void)performShowProgramDescription:sender
{
    self.listingsContainerDetailView.frame = self.listingsContainerView.frame;
    [self.listingsContainerView replaceSubview:(self.listingsContainerView.subviews)[0]
                                          with:self.listingsContainerDetailView];

}

- (IBAction)closeProgramDescription:sender
{
    [[[NSApp delegate] statusViewController] performCloseProgramDescription:sender];
    [[[NSApp delegate] panelViewController] performCloseProgramDescription:sender];
}

- (IBAction)showProgramDescription:sender
{
    [[[NSApp delegate] statusViewController] performShowProgramDescription:sender];
    [[[NSApp delegate] panelViewController] performShowProgramDescription:sender];
}

@end
