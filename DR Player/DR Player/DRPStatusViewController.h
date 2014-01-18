//
//  RFViewController.h
//  Radio24syv
//
//  Created by Richard Nees on 27/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DRPListingsTableView;

@interface DRPStatusViewController : NSViewController

@property (nonatomic, weak) IBOutlet NSView                 *listingsContainerView;
@property (nonatomic, weak) IBOutlet NSView                 *listingsContainerTableView;
@property (nonatomic, weak) IBOutlet NSView                 *listingsContainerDetailView;

@property (nonatomic, weak) IBOutlet NSButton               *playbackButton;
@property (nonatomic, weak) IBOutlet NSSlider               *volumeSlider;
@property (nonatomic, weak) IBOutlet NSButton               *volumeMin;
@property (nonatomic, weak) IBOutlet NSButton               *volumeMax;
@property (nonatomic, weak) IBOutlet NSButton               *previousChannelButton;
@property (nonatomic, weak) IBOutlet NSButton               *nextChannelButton;

@property (nonatomic, weak) IBOutlet NSButton               *closeDescriptionButton;
@property (nonatomic, weak) IBOutlet NSButton               *openWeblinkButton;

@property (nonatomic, weak) IBOutlet NSArrayController      *channelsArrayController;
@property (nonatomic, weak) IBOutlet NSPopover              *channelSelectorPopover;
@property (nonatomic, weak) IBOutlet NSArrayController      *listingsArrayController;
@property (nonatomic, weak) IBOutlet NSArrayController      *currentListingsArrayController;
@property (nonatomic, weak) IBOutlet NSArrayController      *selectedListingsArrayController;

@property (nonatomic, weak) IBOutlet DRPListingsTableView   *listingsTableView;

- (void)updateCurrentListing;
- (IBAction)togglePlayback:sender;
- (IBAction)openChannelSelector:sender;
- (IBAction)selectAndPlayChannelFromCollection:sender;
- (IBAction)selectAndPlayPreviousChannel:sender;
- (IBAction)selectAndPlayNextChannel:sender;

- (IBAction)openProgramURL:sender;

- (IBAction)muteMovieVolume:sender;
- (IBAction)maxMovieVolume:sender;

- (void)performCloseProgramDescription:sender;
- (void)performShowProgramDescription:sender;
- (IBAction)closeProgramDescription:sender;
- (IBAction)showProgramDescription:sender;

@end
