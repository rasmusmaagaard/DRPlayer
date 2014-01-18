//
//  DRPControlsViewController.h
//  DR Player
//
//  Created by Richard Nees on 27/09/10.
//  Copyright 2010 Section Urbaine Software. All rights reserved.
//



@class DRPTitleBar;
@class DRPWidgetView;
@class DRPControllerView;

@interface DRPControlsViewController : NSViewController

@property (nonatomic, strong) NSTimer *autoHideUIControlsTimer;
@property (nonatomic, strong) NSTimer *autoHideChannelIdTimer;
@property (nonatomic)         BOOL    isBeingAutoShown;

@property (nonatomic, weak) IBOutlet NSArrayController *selectedChannelArrayController;
@property (nonatomic, weak) IBOutlet NSArrayController *selectedListingsArrayController;

@property (nonatomic, weak) IBOutlet DRPTitleBar *titleBarView;
@property (nonatomic, weak) IBOutlet DRPWidgetView *widgetView;

@property (nonatomic, weak) IBOutlet DRPControllerView *controllerHUDView;

@property (nonatomic, weak) IBOutlet NSView *channelIdView;

@property (nonatomic, weak) IBOutlet NSButton *playbackButton;
@property (nonatomic, weak) IBOutlet NSButton *playbackControlButton;

@property (nonatomic, weak) IBOutlet NSTextField *titleTextField;
@property (nonatomic, weak) IBOutlet NSSlider *volumeSlider;
@property (nonatomic, weak) IBOutlet NSButton *volumeMin;
@property (nonatomic, weak) IBOutlet NSButton *volumeMax;
@property (nonatomic, weak) IBOutlet NSButton *webLinkButton;
@property (nonatomic, weak) IBOutlet NSButton *previousChannelButton;
@property (nonatomic, weak) IBOutlet NSButton *nextChannelButton;
@property (nonatomic, weak) IBOutlet NSButton *channelSelectorToggleButton;
@property (nonatomic, weak) IBOutlet NSButton *listingsToggleButton;
@property (nonatomic, weak) IBOutlet NSButton *prefsToggleButton;
@property (nonatomic, weak) IBOutlet NSButton *fullScreenToggleButton;

- (IBAction)closeWindow:sender;
- (IBAction)minimizeWindow:sender;
- (IBAction)zoomWindow:sender;

- (IBAction)showPopover:sender;

- (IBAction)tooglePlayback:sender;
- (IBAction)toogleSelectionView:sender;

- (IBAction)selectAndPlayPreviousChannel:sender;
- (IBAction)selectAndPlayNextChannel:sender;

- (IBAction)muteMovieVolume:sender;
- (IBAction)maxMovieVolume:sender;

- (void)showChannelId:sender;
- (void)hideChannelId:sender;
- (void)showUIControls:sender;
- (void)hideUIControls:sender;

@end
