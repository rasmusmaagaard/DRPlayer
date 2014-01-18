//
//  DRPAppDelegate.h
//  DR Player
//
//  Created by Richard Nees on 02/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DRPControlsViewController;

@class DRPMainContentView;
@class DRPMainWindow;
@class DRPMovieView;

@class DRPPrefsViewController;

@class DRPSelectionViewController;

@class DRPStatusItemView;
@class DRPStatusViewController;


@class SUUpdater;

@interface DRPAppDelegate : NSObject <NSApplicationDelegate,NSPopoverDelegate,NSWindowDelegate>

@property (nonatomic, weak) IBOutlet SUUpdater              *updater;
@property (nonatomic, strong) NSOperationQueue              *operationQueue;
@property (nonatomic, weak) IBOutlet NSArrayController      *channelsArrayController;
@property (nonatomic, strong) DRPChannel                    *selectedChannel;
@property (nonatomic, weak) IBOutlet NSArrayController      *listingsArrayController;
@property (nonatomic, strong) NSMutableArray                *currentListing;
@property (nonatomic, strong) NSTimer                       *refreshCurrentListingTimer;
@property (nonatomic, strong) NSTimer                       *refreshChannelsTimer;

@property (nonatomic, weak) IBOutlet NSTextField            *aboutVersionTextField;
@property (nonatomic, weak) IBOutlet NSTextField            *aboutCopyrightTextField;

@property (nonatomic, strong) IBOutlet DRPMainWindow        *mainWindow;
@property (nonatomic, weak) IBOutlet DRPMainContentView     *mainWindowContentView;

@property (nonatomic, weak) IBOutlet DRPMovieView           *movieView;
@property (nonatomic, weak) IBOutlet NSTextField            *streamErrorTextField;
@property (nonatomic, strong) CALayer                       *mContainer;
@property (nonatomic) BOOL                                  isPlayerLayerAnimating;

@property (nonatomic, weak) IBOutlet NSMenuItem             *highQualityMenuItem;
@property (nonatomic, weak) IBOutlet NSMenuItem             *mediumQualityMenuItem;
@property (nonatomic, weak) IBOutlet NSMenuItem             *lowQualityMenuItem;

@property (nonatomic, strong) DRPControlsViewController     *controlsViewController;
@property (nonatomic, strong) DRPSelectionViewController    *selectionViewController;
@property (nonatomic, weak) IBOutlet NSMenuItem             *selectionViewToggleMenuItem;

@property (nonatomic, strong) NSPopover                     *statusMenuPopover;
@property (nonatomic, strong) IBOutlet NSPanel              *statusPanel;
@property (nonatomic, strong) DRPStatusViewController       *statusViewController;
@property (nonatomic, strong) DRPStatusViewController       *panelViewController;
@property (nonatomic, strong) DRPPrefsViewController        *prefsViewController;

@property (nonatomic, strong) DRPStatusItemView             *statusItemView;
@property (nonatomic, strong) NSStatusBar                   *statusBar;
@property (nonatomic, strong) NSStatusItem                  *statusItem;

@property (nonatomic, weak) IBOutlet NSTextField            *lastSwuCheckTextField;
@property (nonatomic, weak) IBOutlet NSButton               *channelRefreshButton;
@property (nonatomic, weak) IBOutlet NSProgressIndicator    *progressIndicator;
@property (nonatomic, weak) IBOutlet NSTextField            *progressTextField;

- (AVPlayerLayer *)currentPlayerLayer;

- (BOOL)isPlayerActive;
- (void)togglePlayback:sender;
- (void)syncArrayControllersByChannel:(DRPChannel *)channel;
- (void)startPlayback:sender;
- (void)startPlaybackFromMenuItem:(NSMenuItem *)menuItem;
- (void)playChannel:(DRPChannel *)channel;
- (void)stopPlayback:sender;
- (void)externalStopPlayback:sender;
- (IBAction)selectAndPlayPreviousChannel:sender;
- (IBAction)selectAndPlayNextChannel:sender;

- (IBAction)refreshChannelsAndListings:sender;
- (void)refreshChannels:sender;
- (void)refreshChannelMenus;
- (void)refreshListings:sender;
- (void)setDockImage:sender;

- (void)showPlayerPopover:sender;
- (void)showPreferencesPopover:sender;

// Status Item related
- (IBAction)toggleStatusItem:sender;

// Window related
- (IBAction)togglePanel:sender;
- (IBAction)showWindow:sender;
- (IBAction)closeWindow:sender;
- (IBAction)minimizeWindow:sender;
- (IBAction)showChannelSelection:sender;

// View related
- (BOOL)inFullScreenMode;
- (IBAction)actualSize:sender;
- (IBAction)doubleSize:sender;
- (IBAction)zoomCustom:sender;
- (IBAction)toggleLevel:sender;

// Movie related
- (IBAction)setMovieQuality:sender;
- (IBAction)setMovieVolume:sender;
- (IBAction)increaseMovieVolume:sender;
- (IBAction)decreaseMovieVolume:sender;
- (IBAction)unMuteMovieVolume:sender;
- (IBAction)muteMovieVolume:sender;
- (IBAction)maxMovieVolume:sender;

@end
