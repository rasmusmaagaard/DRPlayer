//
//  DRPAppDelegate.m
//  DR Player
//
//  Created by Richard Nees on 02/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DRPAppDelegate.h"

#import "DRPControlsViewController.h"
#import "DRPControllerView.h"

#import "DRPChannelUpdateOperation.h"
#import "DRPListingsTableView.h"
#import "DRPListingsUpdateOperation.h"

#import "DRPMainWindow.h"
#import "DRPMainContentView.h"
#import "DRPMovieView.h"

#import "DRPPrefsViewController.h"

#import "DRPStatusItemView.h"
#import "DRPStatusViewController.h"

#import "DRPTitleBar.h"

#import "DRPValueTransformers.h"
#import "DRPWidgetView.h"

@interface DRPAppDelegate(Private)

- (void)showStatusItem:sender;
- (void)hideStatusItem:sender;

- (void)startRefreshChannelsTimer:sender;
- (void)stopRefreshChannelsTimer:sender;
- (void)startRefreshCurrentListingTimer:sender;
- (void)stopRefreshCurrentListingTimer:sender;

- (void)readChannelsStore;
- (void)writeChannelsStore;
- (void)channelRefreshMainThreadOperationDidFinish:(NSNotification*)note;
- (void)channelRefreshAnyThreadOperationDidFinish:(NSNotification*)note;

- (void)readListingsStore;
- (void)writeListingsStore;
- (void)listingRefreshMainThreadOperationDidFinish:(NSNotification*)note;
- (void)listingRefreshAnyThreadOperationDidFinish:(NSNotification*)note;
- (void)refreshCurrentListingTimer:sender;

- (void)startRefreshChannels:sender;
- (void)endRefreshChannels:sender;
- (void)startRefreshListings:sender;
- (void)endRefreshListings:sender;

- (void)updateMenuProgressStringMainThread:(NSNotification*)note;
- (void)updateMenuProgressStringAnyThread:(NSNotification*)note;

- (void)refreshLastSwuCheckString;

@end

@implementation DRPAppDelegate

- (AVPlayerLayer *)currentPlayerLayer
{
    if ([[_mContainer sublayers] count])
        return [_mContainer sublayers][0];
    
    return nil;
}

- (void)handlePlaybackStart:(NSNotification *)note
{
    [self.controlsViewController.selectedChannelArrayController setContent:@[[self selectedChannel]]];
    [self.controlsViewController.selectedListingsArrayController setContent:[self currentListing]];
    [self.controlsViewController.playbackButton setState:NSOnState];
    
}

- (void)handlePlaybackStop:(NSNotification *)note
{
    [self.controlsViewController.selectedChannelArrayController setContent:nil];
    [self.controlsViewController.selectedListingsArrayController setContent:nil];
    [self.controlsViewController.playbackButton setState:NSOffState];
}


- (BOOL)inFullScreenMode 
{
    NSApplicationPresentationOptions opts = [NSApp presentationOptions];
    if ( opts & NSApplicationPresentationFullScreen) 
    {
        return YES;
    }
    return NO;
}

#pragma mark -
#pragma mark Deallocation / Termination

- (void)dealloc
{
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    [self stopRefreshCurrentListingTimer:nil];
    [self stopRefreshChannelsTimer:nil];
	[self hideStatusItem:nil];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender 
{
    return NSTerminateNow;
}

#pragma mark -
#pragma mark Init / Setup

- (id)init
{
    self = [super init];
    
    [DRPValueTransformersController setupValueTransformers];
    
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self 
                                                        selector:@selector(externalStopPlayback:) 
                                                            name:Radio24SyvPlaybackStart 
                                                          object:nil
                                              suspensionBehavior:NSNotificationSuspensionBehaviorDeliverImmediately
     ];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateMenuProgressStringAnyThread:) 
                                                 name:UpdateMenuProgressString 
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(channelRefreshAnyThreadOperationDidFinish:) 
                                                 name:ChannelUpdateOperationDidFinish 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(channelIconRefreshAnyThreadOperationDidFinish:)
                                                 name:ChannelIconUpdateOperationDidFinish
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(listingRefreshAnyThreadOperationDidFinish:)
                                                 name:ListingUpdateOperationDidFinish 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(handlePlaybackStart:) 
                                                 name:DRPlayerPlaybackInternalStart 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(handlePlaybackStop:) 
                                                 name:DRPlayerPlaybackInternalStop 
                                               object:nil];
    
    
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:DRPDefaultsHiddenStatusItem])
    {
        [self showStatusItem:nil];
    }
}

- (void)awakeFromNib
{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
	
    NSString *appVersionString = infoPlist[@"CFBundleShortVersionString"];
    if ([appVersionString rangeOfString:@"Beta"].location != NSNotFound)
    {
        [self.updater setFeedURL:[NSURL URLWithString:DRPAppcastBetaURLString]];
    }
    else
    {
        [self.updater setFeedURL:[NSURL URLWithString:DRPAppcastReleaseURLString]];
    }
    
    [self refreshLastSwuCheckString];

    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 1;
    
    
    [self.mainWindow setDelegate:self];
    
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:DRPMainWindowMovieQuality])
	{
        if ([[NSUserDefaults standardUserDefaults] integerForKey:DRPMainWindowMovieQuality] == 1001)
        {
            [self.highQualityMenuItem setState:NSOnState];
            [self.mediumQualityMenuItem setState:NSOffState];
            [self.lowQualityMenuItem setState:NSOffState];
        }
        else if ([[NSUserDefaults standardUserDefaults] integerForKey:DRPMainWindowMovieQuality] == 1002)
        {
            [self.highQualityMenuItem setState:NSOffState];
            [self.mediumQualityMenuItem setState:NSOnState];
            [self.lowQualityMenuItem setState:NSOffState];
        }
        else if ([[NSUserDefaults standardUserDefaults] integerForKey:DRPMainWindowMovieQuality] == 1003)
        {
            [self.highQualityMenuItem setState:NSOffState];
            [self.mediumQualityMenuItem setState:NSOffState];
            [self.lowQualityMenuItem setState:NSOnState];
        }
	}
	else
	{
		[self.highQualityMenuItem setState:NSOnState];
		[self.mediumQualityMenuItem setState:NSOffState];
		[self.lowQualityMenuItem setState:NSOffState];
	}
    
    // setup the content view to use layers
    [self.movieView setWantsLayer:YES];
	[self.movieView setBounds:[self.mainWindowContentView bounds]];
	[self.movieView setFrame:[self.mainWindowContentView frame]];
    
    // create a root layer to contain all of our layers
    CALayer *root = [self.movieView layer];
    // use constraint layout to allow sublayers to center themselves
    root.layoutManager = [CAConstraintLayoutManager layoutManager];
	root.cornerRadius = 5.0;
	root.masksToBounds = YES;
	root.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
	
    // create a new layer which will contain all our sublayers
    self.mContainer = [CALayer layer];
    self.mContainer.bounds = root.bounds;
    self.mContainer.frame = root.frame;
    self.mContainer.position = CGPointMake(root.bounds.size.width * 0.5, root.bounds.size.height * 0.5);
    self.mContainer.cornerRadius = 5.0;
	self.mContainer.masksToBounds = YES;
	self.mContainer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
		
    // insert layer on the bottom of the stack so it is behind the controls
    [root insertSublayer:self.mContainer atIndex:0];
	
	self.controlsViewController = [[DRPControlsViewController alloc] initWithNibName:@"ControlsOverlayView" bundle:nil];
	[self.controlsViewController loadView];
	[[self.controlsViewController view] setFrame:[self.mainWindowContentView frame]];
    [[self.controlsViewController view] setHidden:NO];
    [self.movieView addSubview:[self.controlsViewController titleBarView]];
    [self.movieView addSubview:[self.controlsViewController controllerHUDView]];
    [self.movieView addSubview:[self.controlsViewController channelIdView]];
    
    self.panelViewController = [[DRPStatusViewController alloc] initWithNibName:@"StatusView" bundle:nil];
    self.statusPanel.contentView = self.panelViewController.view;
    
    self.statusViewController = [[DRPStatusViewController alloc] initWithNibName:@"StatusView" bundle:nil];
    [self.statusViewController loadView];
    
    self.prefsViewController = [[DRPPrefsViewController alloc] initWithNibName:@"PreferencesView" bundle:nil];
    [self.prefsViewController loadView];
    
    
    [self readChannelsStore];
    [self readListingsStore];
    
    [self startRefreshChannelsTimer:nil];
    [self startRefreshCurrentListingTimer:nil];
    [self refreshChannels:nil];
}

#pragma mark -
#pragma mark Application Active State

- (void)applicationWillBecomeActive:(NSNotification *)aNotification 
{
}

- (void)applicationWillResignActive:(NSNotification *)aNotification 
{
}

#pragma mark -
#pragma mark Timers

- (void)startRefreshChannelsTimer:sender
{
    DebugNSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    self.refreshChannelsTimer = [NSTimer scheduledTimerWithTimeInterval:3600.0
                                                                 target:self
                                                               selector:@selector(refreshChannels:)
                                                               userInfo:nil
                                                                repeats:YES];
	
    
}

- (void)stopRefreshChannelsTimer:sender
{
    DebugNSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [self.refreshChannelsTimer invalidate];
    self.refreshChannelsTimer = nil;
}

- (void)startRefreshCurrentListingTimer:sender
{
    DebugNSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    self.refreshCurrentListingTimer = [NSTimer scheduledTimerWithTimeInterval:60.0
                                                                       target:self
                                                                     selector:@selector(refreshCurrentListing:)
                                                                     userInfo:nil
                                                                      repeats:YES];
	
    
}

- (void)stopRefreshCurrentListingTimer:sender
{
    DebugNSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [self.refreshCurrentListingTimer invalidate];
    self.refreshCurrentListingTimer = nil;
}

#pragma mark -
#pragma mark Channels

- (void)refreshChannels:sender
{
    DebugNSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [self.operationQueue cancelAllOperations];
    [self stopRefreshChannelsTimer:nil];
    [self stopRefreshCurrentListingTimer:nil];
    DRPChannelUpdateOperation *channelUpdateOperation = [[DRPChannelUpdateOperation alloc] init];
    [self.operationQueue addOperation:channelUpdateOperation];
    [self startRefreshChannels:nil];
}

- (void)readChannelsStore
{
    DebugNSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    if ([self.channelsArrayController loadStoreControllerWithPath:[NSString channelsPlistPath] andKey:DRPChannelsKey])
    {
        [self refreshChannelMenus];
    }
    else
    {
        [self refreshChannels:nil];
    }
}

- (void)writeChannelsStore
{
    DebugNSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    if ([self.channelsArrayController.arrangedObjects count] > 0)
    {
        [self.channelsArrayController writeStoreControllerWithPath:[NSString channelsPlistPath] andKey:DRPChannelsKey];
    }
}

- (void)channelRefreshAnyThreadOperationDidFinish:(NSNotification*)note
{
    DebugNSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self.progressTextField setAttributedStringValue:[@"" progressAttributedString]];
        [self.progressTextField setHidden:YES];
        
        self.channelsArrayController.content = [note object];
        
        [self writeChannelsStore];
        
        [self refreshChannelMenus];
        
        [self endRefreshChannels:nil];
        
        [self refreshListings:nil];
        
    });
}

- (void)channelIconRefreshAnyThreadOperationDidFinish:(NSNotification*)note
{
    DebugNSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self refreshChannelMenus];

    });
}

- (void)refreshChannelMenus
{
    DebugNSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    if (nil != [[NSApp mainMenu] itemWithTag:10001])
		[[NSApp mainMenu] removeItem:[[NSApp mainMenu] itemWithTag:10001]];	
	if (nil != [[NSApp mainMenu] itemWithTag:10002])
		[[NSApp mainMenu] removeItem:[[NSApp mainMenu] itemWithTag:10002]];
	if (nil != [[NSApp mainMenu] itemWithTag:10003])
		[[NSApp mainMenu] removeItem:[[NSApp mainMenu] itemWithTag:10003]];
	
	
	NSMenu *radioChannelMenu = [[NSMenu alloc] init];
	NSInteger numberOfRadioChannels = 1;
	for (DRPChannel *channel in self.channelsArrayController.arrangedObjects)
	{        
        if (channel.type == DRPChannelRadioType)
        {
            NSMenuItem *item = [[NSMenuItem alloc] init];
            [item setEnabled:YES];
            [item setTitle:@""];
            [item setToolTip:channel.name];
            [item setTarget:self];
            [item setAction:@selector(startPlaybackFromMenuItem:)];
            item.image = [[NSImage alloc] initWithContentsOfURL:channel.iconLocalURL];
            [item setTag:channel.tag];
            if (numberOfRadioChannels < 10)
            {            
                [item setKeyEquivalent:[@(numberOfRadioChannels++) stringValue]];
            }
            else if (numberOfRadioChannels == 10)
            {
                [item setKeyEquivalent:@"0"];
            }
            [item setKeyEquivalentModifierMask:(NSControlKeyMask | NSCommandKeyMask)];
            [radioChannelMenu addItem:item];
        }
	}
	
	if ([[radioChannelMenu itemArray] count] > 0)
	{
		[radioChannelMenu setTitle:NSLocalizedStringFromTable(@"Radio", @"Menu", @"Radio Menu Title")];
		
		NSMenuItem *radioChannelMenuItem = [[NSMenuItem alloc] init];
		[radioChannelMenuItem setTag:10002];
		[radioChannelMenuItem setEnabled:YES];
		[radioChannelMenuItem setTitle:NSLocalizedStringFromTable(@"Radio", @"Menu", @"Radio Menu Title")];
		[radioChannelMenuItem setSubmenu:radioChannelMenu];
		[[NSApp mainMenu] insertItem:radioChannelMenuItem atIndex:1];
	}
	
	
	NSMenu *televisionChannelMenu = [[NSMenu alloc] init];
	NSInteger numberOfTelevisionChannels = 1;
	for (DRPChannel *channel in self.channelsArrayController.arrangedObjects)
	{
		if (channel.type == DRPChannelTelevisionType)
        {
            NSMenuItem *item = [[NSMenuItem alloc] init];
            [item setEnabled:YES];
            [item setTitle:@""];
            [item setToolTip:channel.name];
            [item setTarget:self];
            [item setAction:@selector(startPlaybackFromMenuItem:)];
            item.image = [[NSImage alloc] initWithContentsOfURL:channel.iconLocalURL];
            [item setTag:channel.tag];
            if (numberOfTelevisionChannels < 10)
            {            
                [item setKeyEquivalent:[@(numberOfTelevisionChannels++) stringValue]];
            }
            else if (numberOfTelevisionChannels == 10)
            {
                [item setKeyEquivalent:@"0"];
            }
            [item setKeyEquivalentModifierMask:(NSAlternateKeyMask | NSCommandKeyMask)];
            [televisionChannelMenu addItem:item];
        }
	}
	
	if ([[televisionChannelMenu itemArray] count] > 0)
	{
		[televisionChannelMenu setTitle:NSLocalizedStringFromTable(@"TV", @"Menu", @"Television Menu Title")];
		
		NSMenuItem *televisionChannelMenuItem = [[NSMenuItem alloc] init];
		[televisionChannelMenuItem setTag:10001];
		[televisionChannelMenuItem setEnabled:YES];
		[televisionChannelMenuItem setTitle:NSLocalizedStringFromTable(@"TV", @"Menu", @"Television Menu Title")];
		[televisionChannelMenuItem setSubmenu:televisionChannelMenu];
		[[NSApp mainMenu] insertItem:televisionChannelMenuItem atIndex:1];
	}
}


#pragma mark -
#pragma mark Listings

- (void)refreshListings:sender
{
    DebugNSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [self stopRefreshChannelsTimer:nil];
    [self stopRefreshChannelsTimer:nil];
    DRPListingsUpdateOperation *listingsUpdateOperation = [[DRPListingsUpdateOperation alloc] init];
    [self.operationQueue addOperation:listingsUpdateOperation];
    [self startRefreshListings:nil];
}

- (void)readListingsStore
{
    DebugNSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    if ([self.listingsArrayController loadStoreControllerWithPath:[NSString listingsPlistPath] andKey:DRPListings])
    {
    }
    else
    {
        [self refreshListings:nil];
    }
}

- (void)writeListingsStore
{
    DebugNSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    if ([self.listingsArrayController.arrangedObjects count] > 0)
    {
        [self.listingsArrayController writeStoreControllerWithPath:[NSString listingsPlistPath] andKey:DRPListings];
    }
}

- (void)listingRefreshAnyThreadOperationDidFinish:(NSNotification*)note
{
    DebugNSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    dispatch_async(dispatch_get_main_queue(), ^{
    
        [self.progressTextField setAttributedStringValue:[@"" progressAttributedString]];
        [self.progressTextField setHidden:YES];
        
        self.listingsArrayController.content = [note object];
        
        [self writeListingsStore];
        
        [self endRefreshListings:nil];
        
        [self startRefreshChannelsTimer:nil];
        [self refreshCurrentListing:nil];
        [self startRefreshCurrentListingTimer:nil];
    
    });
}

- (void)refreshCurrentListing:sender
{
    DebugNSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    NSDictionary *currentlySelectedListingItem = nil;
    if ([[self.controlsViewController.selectedListingsArrayController arrangedObjects] count])
    {
        currentlySelectedListingItem = (self.controlsViewController.selectedListingsArrayController.arrangedObjects)[0];
    }
    
    if (self.isPlayerActive && [[self.listingsArrayController selectedObjects] count])
    {
        self.currentListing = [[self.listingsArrayController selectedObjects] valueForKey:DRPProgramListingItemsArray][0];
    }
    else
    {
        self.currentListing = nil;
    }
    
    
    [self.controlsViewController.selectedListingsArrayController setContent:[self currentListing]];
    [self.statusViewController updateCurrentListing];
    [self.panelViewController updateCurrentListing];
    
    
    if ([[self.controlsViewController.selectedListingsArrayController arrangedObjects] count])
    {    NSDictionary *changedSelectedListingItem = (self.controlsViewController.selectedListingsArrayController.arrangedObjects)[0];
        if (![currentlySelectedListingItem isEqualToDictionary:changedSelectedListingItem])
        {
            [self.statusViewController.listingsTableView reloadData];
            [self.statusViewController.listingsTableView scrollToActive];
            
            [self.panelViewController.listingsTableView reloadData];
            [self.panelViewController.listingsTableView scrollToActive];
        }
    }
}

#pragma mark -
#pragma mark Refresh UI

- (IBAction)refreshChannelsAndListings:sender
{
    DebugNSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [self refreshChannels:sender];
}

- (void)startRefreshChannels:sender
{
    DebugNSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [self.channelRefreshButton setEnabled:NO];
    [self.progressTextField setHidden:NO];
    [self.progressIndicator startAnimation:nil];
}

- (void)endRefreshChannels:sender
{
    DebugNSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [self.progressIndicator stopAnimation:nil];
    [self.progressTextField setHidden:YES];
    [self.channelRefreshButton setEnabled:YES];
}

- (void)startRefreshListings:sender
{
    DebugNSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [self.channelRefreshButton setEnabled:NO];
    [self.progressTextField setHidden:NO];
    [self.progressIndicator startAnimation:nil];
    
}

- (void)endRefreshListings:sender
{
    DebugNSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [self.progressIndicator stopAnimation:nil];
    [self.progressTextField setHidden:YES];
    [self.channelRefreshButton setEnabled:YES];
}

#pragma mark -
#pragma mark Status Update Handling

- (void)updateMenuProgressStringMainThread:(NSNotification*)note
{
    [self.progressTextField setAttributedStringValue:[[note userInfo][@"statusString"] progressAttributedString]];
}

- (void)updateMenuProgressStringAnyThread:(NSNotification*)note
{
    [self performSelectorOnMainThread:@selector(updateMenuProgressStringMainThread:) withObject:note waitUntilDone:NO];
}

#pragma mark -
#pragma mark Player

- (void)togglePlayback:sender
{
    if ([self.currentPlayerLayer.player rate] > 0.0)
    {
        [self stopPlayback:nil];
    }
    else
    {        
        [self startPlayback:nil];
    }
}

- (BOOL (^)(id obj, NSUInteger idx, BOOL *stop))blockTestingForChannel:(DRPChannel *)channel
{
    return [^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqual:channel]) {
            *stop = YES;
            return YES;
        }
        return NO;
    } copy];
}

- (void)syncArrayControllersByChannel:(DRPChannel *)channel
{
    NSUInteger foundIndex = [self.channelsArrayController.arrangedObjects indexOfObjectPassingTest:[self blockTestingForChannel:channel]];
    
    [self.channelsArrayController setSelectionIndexes:[NSIndexSet indexSetWithIndex:foundIndex]];
    [self.listingsArrayController setSelectionIndexes:[NSIndexSet indexSetWithIndex:foundIndex]];
}

- (void)startPlayback:sender
{
    if (self.isPlayerLayerAnimating)
        return;
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:DRPDefaultsSelectedChannelTagKey])
    {
        for (DRPChannel *channel in self.channelsArrayController.arrangedObjects)
        {
            if (channel.tag == [[NSUserDefaults standardUserDefaults] integerForKey:DRPDefaultsSelectedChannelTagKey])
            {
                [self.channelsArrayController setSelectedObjects:@[channel]];
                [self playChannel:channel];
            }
        }
    }
    else
    {
        self.channelsArrayController.selectionIndexes = [NSIndexSet indexSetWithIndex:0];
        [self playChannel:(self.channelsArrayController.arrangedObjects)[0]];
    }
}

- (void)startPlaybackFromMenuItem:(NSMenuItem *)menuItem
{
    if (self.isPlayerLayerAnimating)
        return;
    
    for (DRPChannel *channel in [self.channelsArrayController arrangedObjects])
    {
        if (channel.tag == menuItem.tag)
        {
            [self playChannel:channel];
            break;
        }
    }
}

- (NSComparisonResult)compareCurrentAgainstSelectedChannel
{
    AVURLAsset *urlAsset = (AVURLAsset *)self.currentPlayerLayer.player.currentItem.asset;
    NSComparisonResult compResult = NSOrderedSame;
    
    for (DRPChannel *comparisonChannel in self.channelsArrayController.arrangedObjects)
    {
        NSURL *URL = nil;
        
        switch ([[NSUserDefaults standardUserDefaults] integerForKey:DRPMainWindowMovieQuality]) {
            case 1001:
                URL = comparisonChannel.streamQualityHighURL;
                break;
            case 1002:
                URL = comparisonChannel.streamQualityMediumURL;
                break;
            case 1003:
                URL = comparisonChannel.streamQualityLowURL;
                break;
            default:
                URL = comparisonChannel.streamQualityHighURL;
                break;
        }
        
        if ([urlAsset.URL isEqualTo:URL])
        {
            compResult = [@(self.selectedChannel.tag) compare:@(comparisonChannel.tag)];
            break;
        }
    }
        
    return compResult;
}

- (CGFloat)channelChangeAnimationDuration
{
    return 1.0f;
}

- (CAAnimationGroup *)inAnimationGroup
{
    CABasicAnimation *inPositionAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    if (self.compareCurrentAgainstSelectedChannel == NSOrderedAscending)
    {
        inPositionAnimation.fromValue = [NSNumber numberWithFloat:self.mContainer.position.x-self.mContainer.frame.size.width];
    }
    else
    {
        inPositionAnimation.fromValue = [NSNumber numberWithFloat:self.mContainer.position.x+self.mContainer.frame.size.width];
    }
    inPositionAnimation.toValue = [NSNumber numberWithFloat:self.mContainer.position.x];
    
    CABasicAnimation *inOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    inOpacityAnimation.fromValue = @0.0f;
    inOpacityAnimation.toValue = @1.0f;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = self.channelChangeAnimationDuration;
    animationGroup.removedOnCompletion = NO;
    animationGroup.repeatCount = 0;
    animationGroup.autoreverses = NO;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.animations = @[inPositionAnimation, inOpacityAnimation];
    
    return animationGroup;
}

- (CAAnimationGroup *)outAnimationGroup
{
    CABasicAnimation *outPositionAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    if (self.compareCurrentAgainstSelectedChannel == NSOrderedAscending)
    {
        outPositionAnimation.toValue = [NSNumber numberWithFloat:self.mContainer.position.x+self.mContainer.frame.size.width];
    }
    else
    {
        outPositionAnimation.toValue = [NSNumber numberWithFloat:self.mContainer.position.x-self.mContainer.frame.size.width];
    }
    
    CABasicAnimation *outOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    outOpacityAnimation.fromValue = @1.0f;
    outOpacityAnimation.toValue = @0.0f;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = self.channelChangeAnimationDuration;
    animationGroup.removedOnCompletion = NO;
    animationGroup.repeatCount = 0;
    animationGroup.autoreverses = NO;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animationGroup.animations = @[outPositionAnimation, outOpacityAnimation];
    animationGroup.delegate = self;
    
    return animationGroup;
}

- (void)animationDidStart:(CAAnimation *)anim
{
    self.isPlayerLayerAnimating = YES;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    if (flag)
    {
        // Removing current player layer
        [self.currentPlayerLayer.player removeObserver:self forKeyPath:@"volume"];
        [self.currentPlayerLayer.player.currentItem removeObserver:self forKeyPath:@"status"];
        [self.currentPlayerLayer removeFromSuperlayer];
        
        // Activating selected player layer
        [self.currentPlayerLayer.player play];      
        self.isPlayerLayerAnimating = NO;
    }
}

- (void)playChannel:(DRPChannel *)channel
{
    [self.streamErrorTextField setStringValue:@""];
    self.selectedChannel = channel;
    
    [[NSUserDefaults standardUserDefaults] setInteger:self.selectedChannel.tag forKey:DRPDefaultsSelectedChannelTagKey];
    [self syncArrayControllersByChannel:self.selectedChannel];
    [self setDockImage:nil];
    
    NSURL *URL = nil;
    
    switch ([[NSUserDefaults standardUserDefaults] integerForKey:DRPMainWindowMovieQuality]) {
        case 1001:
            URL = self.selectedChannel.streamQualityHighURL;
            break;
        case 1002:
            URL = self.selectedChannel.streamQualityMediumURL;
            break;
        case 1003:
            URL = self.selectedChannel.streamQualityLowURL;
            break;
        default:
            URL = self.selectedChannel.streamQualityHighURL;
            break;
    }
    

    if (self.currentPlayerLayer.player)
    {
        AVURLAsset *urlAsset = (AVURLAsset *)self.currentPlayerLayer.player.currentItem.asset;
        if ([urlAsset.URL isEqualTo:URL])
        {
            return;
        }
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:DRPDefaultsViewerDisplayManually])
    {
        if (self.selectedChannel.type == DRPChannelTelevisionType)
        {
            [self.mainWindow orderFront:nil];
        }
        //else if (self.selectedChannel.type == numberWithInteger:DRPChannelRadioType)
        //{
        //    [self.mainWindow orderOut:nil];
        //}
        
    }
    
    
    AVPlayerItem *newPlayerItem = [AVPlayerItem playerItemWithURL:URL];
    [newPlayerItem addObserver:self forKeyPath:@"status" options:0 context:nil];
    AVPlayer *newPlayer = [AVPlayer playerWithPlayerItem:newPlayerItem];
    [newPlayer addObserver:self forKeyPath:@"volume" options:0 context:nil];
    AVPlayerLayer *newPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:newPlayer];
    
    newPlayerLayer.frame = self.mContainer.frame;
    newPlayerLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
    newPlayerLayer.cornerRadius = 5.0f;
    newPlayerLayer.masksToBounds = YES;
    
    if (self.selectedChannel.type == DRPChannelTelevisionType)
    {
        CGColorRef newPlayerLayerBackgroundColor=CGColorCreateGenericRGB(0.0f,0.0f,0.0f,1.0f);
        newPlayerLayer.backgroundColor = newPlayerLayerBackgroundColor;
        CGColorRelease(newPlayerLayerBackgroundColor);
    }
    
    [self.mContainer insertSublayer:newPlayerLayer atIndex:(unsigned int)self.mContainer.sublayers.count+1];
    
    
    [self.statusViewController.volumeSlider bind:@"value" toObject:newPlayerLayer.player withKeyPath:@"volume" options:nil];
    [self.panelViewController.volumeSlider bind:@"value" toObject:newPlayerLayer.player withKeyPath:@"volume" options:nil];
    [self.controlsViewController.volumeSlider bind:@"value" toObject:newPlayerLayer.player withKeyPath:@"volume" options:nil];
    
    
    if (self.currentPlayerLayer != newPlayerLayer)
    {        
        newPlayerLayer.player.volume = self.currentPlayerLayer.player.volume;

        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [CATransaction setCompletionBlock:
         ^{
             [self updateUITintColorForChannel:channel];
        }];
        //this will update the model layer
//        view1.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1.0);
        self.currentPlayerLayer.opacity = 0.f;
        
        //your basic animations will animate the presentation layer
        /* your CABasicAnimations here */
        
        [newPlayerLayer addAnimation:self.inAnimationGroup forKey:@"animateLayerIn"];
        [self.currentPlayerLayer addAnimation:self.outAnimationGroup forKey:@"animateLayerOut"];
    
        [CATransaction commit];

    }
    else
    {
        newPlayerLayer.player.volume = [[NSUserDefaults standardUserDefaults] floatForKey:DRPMainWindowVolume];
        
        [self.currentPlayerLayer.player play];
        self.currentPlayerLayer.opacity = 1.0;
        
        [self updateUITintColorForChannel:channel];
    }
    
    [self refreshCurrentListing:nil];
    
    [self.controlsViewController showChannelId:nil];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DRPlayerPlaybackInternalStart 
                                                        object:nil 
                                                      userInfo:nil];
    
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:DRPlayerPlaybackStart
                                                                   object:nil
                                                                 userInfo:nil
                                                       deliverImmediately:YES];
    
}

- (void)stopPlayback:sender;
{
    [self.currentPlayerLayer.player pause];
    [self.currentPlayerLayer.player removeObserver:self forKeyPath:@"volume"];
    [self.currentPlayerLayer.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.currentPlayerLayer removeFromSuperlayer];
    
    [self.channelsArrayController setSelectionIndexes:[NSIndexSet indexSet]];
    self.selectedChannel = nil;
    
    [NSApp setApplicationIconImage:[NSImage imageNamed:@"NSApplicationIcon"]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DRPlayerPlaybackInternalStop 
                                                        object:nil 
                                                      userInfo:nil];
}

- (void)externalStopPlayback:sender
{
    [self stopPlayback:nil];
}

- (BOOL)isPlayerActive
{
    if ([self.currentPlayerLayer.player rate] > 0.0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)updateUITintColorForChannel:(DRPChannel *)channel
{
    CIColor* color = [[CIColor alloc] initWithColor:channel.tintColor];
    CIFilter *colorMonochrome = [CIFilter filterWithName:@"CIColorMonochrome"];
    [colorMonochrome setDefaults];
    [colorMonochrome setValue:color forKey:@"inputColor"];
    
    CIFilter *blur = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blur setDefaults];
    
    self.controlsViewController.controllerHUDView.layer.backgroundFilters = @[colorMonochrome,blur];
    self.controlsViewController.titleBarView.layer.backgroundFilters = @[colorMonochrome,blur];
}


#pragma mark Channel Selection

- (IBAction)selectAndPlayPreviousChannel:sender
{
    if (self.isPlayerLayerAnimating)
        return;
    
    NSInteger currentTag = [[NSUserDefaults standardUserDefaults] integerForKey:DRPDefaultsSelectedChannelTagKey];
    
    NSArray *channelsArray = [[[NSApp delegate] channelsArrayController] arrangedObjects];
    
    DRPChannel *selectedChannel = nil;
    
    NSUInteger index = 0;
    for (index = 0; index < [channelsArray count]; index++)
    {
        DRPChannel *channel = channelsArray[index];
        
        if (channel.tag == currentTag)
        {
            if ([channel isEqual:channelsArray[0]])
            {
                selectedChannel = [channelsArray lastObject];
            }
            else
            {
                selectedChannel = channelsArray[index-1];
            }
            
            break;
        }
    }
    
    if (selectedChannel)
        [self playChannel:selectedChannel];
    
    [self.controlsViewController showChannelId:nil];
}

- (IBAction)selectAndPlayNextChannel:sender
{
    if (self.isPlayerLayerAnimating)
        return;
    
    NSInteger currentTag = [[NSUserDefaults standardUserDefaults] integerForKey:DRPDefaultsSelectedChannelTagKey];
    
    NSArray *channelsArray = [[[NSApp delegate] channelsArrayController] arrangedObjects];
    
    DRPChannel *selectedChannel = nil;
    
    NSUInteger index = 0;
    
    for(index = 0; index < [channelsArray count]; index++)
    {
        DRPChannel *channel = channelsArray[index];

        if (channel.tag == currentTag)
        {
            if ([channelsArray[index] isEqual:[channelsArray lastObject]]) 
            {
                selectedChannel = channelsArray[0];
            }
            else
            {
                selectedChannel = channelsArray[index+1];
            }
            
            break;
        }
    }
    
    if (selectedChannel)
        [self playChannel:selectedChannel];
    
    [self.controlsViewController showChannelId:nil];
}


#pragma mark -
#pragma mark UI / Dock

- (void)setDockImage:sender
{
    NSImage *newAppImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForImageResource:@"Dock"]];
    
    [NSApp setApplicationIconImage:newAppImage];
    
    NSImage *newAppImageOverlay = [[NSImage alloc] initWithContentsOfURL:[(DRPChannel *)self.channelsArrayController.selectedObjects[0] iconLocalURL]];

    CGFloat scaleFactor = 3.0;
    CGFloat offsetHeight = 100.0;
    [newAppImageOverlay setScalesWhenResized:YES];
    [newAppImageOverlay setSize:NSMakeSize(newAppImageOverlay.size.width * scaleFactor,
                                           newAppImageOverlay.size.height * scaleFactor
                                           )];
    
    [newAppImage lockFocus];
    [newAppImageOverlay drawAtPoint:NSMakePoint([NSApp applicationIconImage].size.width/2-newAppImageOverlay.size.width/2,
                                                ([NSApp applicationIconImage].size.height/2-newAppImageOverlay.size.height/2) - offsetHeight)
                           fromRect:NSZeroRect
                          operation:NSCompositeSourceOver
                           fraction:1.0f];
    [newAppImage unlockFocus];
    
    [NSApp setApplicationIconImage:newAppImage];
    
}

#pragma mark Status Menu

- (void)showStatusItem:sender
{
    NSImage *statusItemImage = [NSImage imageNamed:@"StatusbarNormal"];
    NSImage *statusItemAlternateImage = [NSImage imageNamed:@"StatusbarAlternate"];
        
    self.statusItemView = [[DRPStatusItemView alloc] initWithFrame:NSMakeRect(0.0, 0.0, [statusItemImage size].width, [statusItemImage size].height)];
    self.statusItemView.image = statusItemImage;
    self.statusItemView.alternateImage = statusItemAlternateImage;
    self.statusItemView.target = self;
    self.statusItemView.action = @selector(showPlayerPopover:);
    self.statusItemView.rightAction = @selector(showPreferencesPopover:);
    
    //Get the system status statusBar
    
    self.statusBar = [NSStatusBar systemStatusBar];
	self.statusItem = [self.statusBar statusItemWithLength:NSVariableStatusItemLength];
	[self.statusItem setHighlightMode:YES];
    [self.statusItem setToolTip:@"DR Player"];
    [self.statusItem setView:self.statusItemView];
    
    [self.statusPanel setMovableByWindowBackground:YES];
    [self.statusMenuPopover setDelegate:self];
}

- (void)hideStatusItem:sender
{
    [self.statusBar removeStatusItem:self.statusItem];
}

- (IBAction)toggleStatusItem:sender
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:DRPDefaultsHiddenStatusItem])
    {
        [self showStatusItem:nil];
    }
    else
    {
        [self hideStatusItem:nil];
    }
}

- (NSWindow *)detachableWindowForPopover:(NSPopover *)popover
{
    return self.statusPanel;
}

- (void)showPlayerPopover:sender
{
    if ([self.statusPanel isVisible])
        [self.statusPanel performClose:nil];
    
    if (self.prefsViewController.statusMenuPrefsPopover.shown)
        [self.prefsViewController.statusMenuPrefsPopover performClose:nil];
    
    self.statusMenuPopover = [NSPopover new];
    self.statusMenuPopover.delegate = self;
    self.statusMenuPopover.contentViewController = [NSViewController new];
    self.statusMenuPopover.appearance = NSPopoverAppearanceHUD;
    self.statusMenuPopover.behavior = NSPopoverBehaviorTransient;
    self.statusMenuPopover.contentViewController.view = self.statusViewController.view;
    
    [self.statusMenuPopover showRelativeToRect:self.statusItem.view.bounds
                                        ofView:self.statusItem.view
                                 preferredEdge:NSMaxYEdge];
    
}

- (void)showPreferencesPopover:sender
{    
    if (self.statusMenuPopover.shown)
    {
        [self.statusMenuPopover performClose:nil];
    }
    else
    {
        [self.prefsViewController.statusMenuPrefsPopover showRelativeToRect:self.statusItem.view.bounds
                                                                     ofView:self.statusItem.view
                                                              preferredEdge:NSMaxYEdge];
    }
}

#pragma mark Window Delegate

- (void)windowDidBecomeKey:(NSNotification *)notification
{
    [[self.controlsViewController widgetView] setActiveState:YES];
    [[self.controlsViewController widgetView] refresh];
}

- (void)windowDidResignKey:(NSNotification *)notification
{
    [[self.controlsViewController widgetView] setActiveState:NO];
    [[self.controlsViewController widgetView] refresh];
}

- (void)windowWillEnterFullScreen:(NSNotification *)notification
{
    [[self.controlsViewController titleBarView] layer].opacity = 0.0;
}

- (void)windowDidEnterFullScreen:(NSNotification *)notification
{
    [self.mainWindow setFrame:[NSScreen mainScreen].frame display:YES animate:YES];
    
    [[self.controlsViewController titleBarView] layer].frame = CGRectMake([[self.controlsViewController titleBarView] layer].frame.origin.x,
                                                                          self.mainWindowContentView.bounds.size.height + [[self.controlsViewController titleBarView] layer].frame.size.height,
                                                                          [[self.controlsViewController titleBarView] layer].frame.size.width,
                                                                          [[self.controlsViewController titleBarView] layer].frame.size.height
                                                                          );
    
    [[self.controlsViewController titleBarView] layer].opacity = 0.0;
    
    [self.controlsViewController hideUIControls:nil];
    self.mContainer.cornerRadius = 0.0;
    self.mContainer.masksToBounds = NO;
    self.currentPlayerLayer.cornerRadius = 0.0;
    self.currentPlayerLayer.masksToBounds = NO;

    [[self.mainWindow contentView] setNeedsDisplay:YES];
    [[self.mainWindow contentView] recreateHideMouseTimer];

}

- (void)windowWillExitFullScreen:(NSNotification *)notification
{
    [NSCursor setHiddenUntilMouseMoves:NO];
}

- (void)windowDidExitFullScreen:(NSNotification *)notification
{    
    self.mContainer.cornerRadius = 5.0;
    self.mContainer.masksToBounds = YES;
    self.currentPlayerLayer.cornerRadius = 5.0;
    self.currentPlayerLayer.masksToBounds = YES;

    [[self.mainWindow contentView] setNeedsDisplay:YES];
}

- (void)windowDidResize:(NSNotification *)notification
{
}

#pragma mark Window related
- (IBAction)togglePanel:sender
{
    if (self.statusPanel.isVisible)
    {
        [self.statusPanel orderOut:nil];
    }
    else
    {
        [self.statusPanel makeKeyAndOrderFront:nil];
    }
}

- (IBAction)showWindow:sender
{
    [self.mainWindow makeKeyAndOrderFront:nil];
}

- (IBAction)closeWindow:sender
{
    if ([self.mainWindow isKeyWindow])
    {
        [self.mainWindow close];
    }
    else
    {
        [NSApp sendAction:@selector(performClose:) to:nil from:sender];
    }
}

- (IBAction)minimizeWindow:sender
{
    [self.mainWindow miniaturize:sender];
}

- (IBAction)showChannelSelection:sender
{
    if (self.statusPanel.isVisible)
    {
        [self.statusPanel orderOut:sender];
        [self.selectionViewToggleMenuItem setTitle:@"Skjul kanalvælger"];
    }
    else
    {
        [self.statusPanel orderFront:sender];
        [self.selectionViewToggleMenuItem setTitle:@"Vis kanalvælger"];
    }
}

#pragma mark Window Size

- (IBAction)actualSize:sender
{
    if (![self inFullScreenMode])
    {
        //if ([[[controller teletextViewController] view] layer].opacity > 0.0)
        //[controller toggleTeletext:nil];
        
        NSRect newMainWindowFrame = NSMakeRect([self.mainWindow frame].origin.x,
                                               ([self.mainWindow frame].size.height - [self.mainWindow contentMinSize].height) + [self.mainWindow frame].origin.y,
                                               [self.mainWindow contentMinSize].width, 
                                               [self.mainWindow contentMinSize].height);
        
        NSRect newVisibleScreenFrame = [[self.mainWindow screen] visibleFrame];
        
        if (newMainWindowFrame.origin.x < newVisibleScreenFrame.origin.x)
        {
            newMainWindowFrame.origin.x = newVisibleScreenFrame.origin.x + 5;
        }
        else if (newMainWindowFrame.origin.x > (newVisibleScreenFrame.size.width - newMainWindowFrame.size.width - 5))
        {
            newMainWindowFrame.origin.x = (newVisibleScreenFrame.size.width - newMainWindowFrame.size.width - 5);
        }
        
        if (newMainWindowFrame.origin.y < newVisibleScreenFrame.origin.y)
        {
            newMainWindowFrame.origin.y = newVisibleScreenFrame.origin.y +  5;
        }
        
        [self.mainWindow setFrame:newMainWindowFrame display:YES animate:YES];		
    }
}

- (IBAction)doubleSize:sender
{
    if (![self inFullScreenMode])
    {
        NSRect newMainWindowFrame =  NSMakeRect([self.mainWindow frame].origin.x,
                                                ([self.mainWindow frame].size.height - [self.mainWindow contentMinSize].height*2) + [self.mainWindow frame].origin.y,
                                                [self.mainWindow contentMinSize].width*2, 
                                                [self.mainWindow contentMinSize].height*2);
        
        NSRect newVisibleScreenFrame = [[self.mainWindow screen] visibleFrame];
        
        if (newMainWindowFrame.origin.x < newVisibleScreenFrame.origin.x)
        {
            newMainWindowFrame.origin.x = newVisibleScreenFrame.origin.x + 5;
        }
        else if (newMainWindowFrame.origin.x > (newVisibleScreenFrame.size.width - newMainWindowFrame.size.width - 5))
        {
            newMainWindowFrame.origin.x = (newVisibleScreenFrame.size.width - newMainWindowFrame.size.width - 5);
        }
        
        if (newMainWindowFrame.origin.y < newVisibleScreenFrame.origin.y)
        {
            newMainWindowFrame.origin.y = newVisibleScreenFrame.origin.y +  5;
        }
        
        [self.mainWindow setFrame:newMainWindowFrame display:YES animate:YES];
    }
}

- (IBAction)zoomCustom:sender
{	
    NSRect newFrame = [[self.mainWindow screen] visibleFrame];
    newFrame.size.height = roundf(newFrame.size.width*9/16);
    newFrame.origin.y = roundf(([[self.mainWindow screen] visibleFrame].size.height - newFrame.size.height)/2);
        
    if (NSEqualRects(self.mainWindow.frame, newFrame))
    {
        [self actualSize:nil];
    }
    else
    {
        [self.mainWindow setFrame:newFrame display:YES animate:YES];
    }    
}

#pragma mark Window Level

- (IBAction)toggleLevel:sender
{
    if (![self inFullScreenMode])
    {
        if ([(NSMenuItem *)sender state] == NSOffState) 
        {
            [self.mainWindow setLevel:NSModalPanelWindowLevel];
        }
        else if ([(NSMenuItem *)sender state] == NSOnState) 
        {
            [self.mainWindow setLevel:NSNormalWindowLevel];
        }
    }
}


#pragma mark Movie related
- (IBAction)setMovieQuality:sender
{
    DebugNSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    if (self.isPlayerLayerAnimating)
        return;
    
    [[NSUserDefaults standardUserDefaults] setInteger:[sender tag] forKey:DRPMainWindowMovieQuality];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:DRPMainWindowMovieQuality])
	{
        if ([[NSUserDefaults standardUserDefaults] integerForKey:DRPMainWindowMovieQuality] == 1001)
        {
            [self.highQualityMenuItem setState:NSOnState];
            [self.mediumQualityMenuItem setState:NSOffState];
            [self.lowQualityMenuItem setState:NSOffState];
        }
        else if ([[NSUserDefaults standardUserDefaults] integerForKey:DRPMainWindowMovieQuality] == 1002)
        {
            [self.highQualityMenuItem setState:NSOffState];
            [self.mediumQualityMenuItem setState:NSOnState];
            [self.lowQualityMenuItem setState:NSOffState];
        }
        else if ([[NSUserDefaults standardUserDefaults] integerForKey:DRPMainWindowMovieQuality] == 1003)
        {
            [self.highQualityMenuItem setState:NSOffState];
            [self.mediumQualityMenuItem setState:NSOffState];
            [self.lowQualityMenuItem setState:NSOnState];
        }
	}
	else
	{
		[self.highQualityMenuItem setState:NSOnState];
		[self.mediumQualityMenuItem setState:NSOffState];
		[self.lowQualityMenuItem setState:NSOffState];
	}
    
    NSInteger selectedTag = [[NSUserDefaults standardUserDefaults] integerForKey:DRPDefaultsSelectedChannelTagKey];
    
    for (DRPChannel *channel in [self.channelsArrayController arrangedObjects])
    {
        if (channel.tag == selectedTag)
        {
            [self playChannel:channel];
            break;
        }
    }
}

- (IBAction)setMovieVolume:sender
{
    [self.currentPlayerLayer.player setVolume:[sender floatValue]];
}

- (IBAction)increaseMovieVolume:sender
{
    if ([[self.controlsViewController volumeSlider] floatValue] > 0.9)
    {
        [self.currentPlayerLayer.player setVolume:1.0];
    }
    else 
    {
        [self.currentPlayerLayer.player setVolume:[self.currentPlayerLayer.player volume]+0.1];
    }	
    
    if ([self inFullScreenMode])
    {
        [[self controlsViewController] showUIControls:nil];
    }	
}

- (IBAction)decreaseMovieVolume:sender
{
    if ([[self.controlsViewController volumeSlider] floatValue] < 0.1)
    {
        [self.currentPlayerLayer.player setVolume:0.0];
    }
    else 
    {
        [self.currentPlayerLayer.player setVolume:[self.currentPlayerLayer.player volume]-0.1];
    }
    
    if ([self inFullScreenMode])
    {
        [[self controlsViewController] showUIControls:nil];
    }	
}

- (IBAction)unMuteMovieVolume:sender
{
    [self.currentPlayerLayer.player setVolume:[[NSUserDefaults standardUserDefaults] floatForKey:DRPMainWindowVolume]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)muteMovieVolume:sender
{
    if (self.currentPlayerLayer.player.volume != 0.0f)
    {
        [self.currentPlayerLayer.player setVolume:0.0f];
    }
    else
    {
        [self unMuteMovieVolume:nil];
    }
}

- (IBAction)maxMovieVolume:sender
{
    [self.currentPlayerLayer.player setVolume:1.0];
}

#pragma mark Help 

- (IBAction)showControlsGuide:sender
{
    [[NSWorkspace sharedWorkspace] openFile:[[NSBundle mainBundle] pathForResource:@"DRPlayerControlsGuide" ofType:@"html"]];
}

- (IBAction)showApplicationWebsite:sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:DRPCompanyWebHomeURLString]];
}

- (IBAction)showTwitterWebsite:sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:DRPCompanyTwitterURLString]];
}

#pragma mark -
#pragma mark Self Update delegate

- (void)updater:(SUUpdater *)updater didFinishLoadingAppcast:(SUAppcast *)appcast
{
    [self refreshLastSwuCheckString];
}

- (void)refreshLastSwuCheckString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSLocale *daLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"da_DK"];
    [dateFormatter setLocale:daLocale];
    [dateFormatter setDoesRelativeDateFormatting:YES];
    
    NSAttributedString *lastSwuCheckString = [[NSAttributedString alloc] initWithString:[NSString localizedStringWithFormat:@"Sidst opdateret %@", [dateFormatter stringFromDate:[self.updater lastUpdateCheckDate]]]
                                                                             attributes:[NSAttributedString standardTextStyleAttributesForFontSize:9.0f textAlignment:NSLeftTextAlignment]];
    [self.lastSwuCheckTextField setAttributedStringValue:lastSwuCheckString];
}

#pragma mark -
#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context 
{
    if (object == self.currentPlayerLayer.player && [keyPath isEqualToString:@"volume"]) 
    {
        [[NSUserDefaults standardUserDefaults] setFloat:self.currentPlayerLayer.player.volume forKey:DRPMainWindowVolume];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if (object == self.currentPlayerLayer.player.currentItem && [keyPath isEqualToString:@"status"]) 
    {
        if (self.currentPlayerLayer.player.currentItem.status == AVPlayerStatusReadyToPlay) 
        {
            //playButton.enabled = YES;
        }
        else if (self.currentPlayerLayer.player.currentItem.status == AVPlayerStatusFailed) 
        {
            NSError *error = [self.currentPlayerLayer.player.currentItem error];
            // Respond to error: for example, display an alert sheet.
            
            if (error) 
            {
                NSAttributedString *errorAttributedString = [[NSAttributedString alloc] initWithString:[NSString localizedStringWithFormat:@"%@", [error localizedDescription]]
                                                                                            attributes:[NSAttributedString standardTextStyleAttributesForFontSize:13.0f textAlignment:NSCenterTextAlignment]];
                
                [self.streamErrorTextField setAttributedStringValue:errorAttributedString];
                
                [self stopPlayback:nil];
            }
        }
    }
    // Deal with other change notifications if appropriate.
    //[super observeValueForKeyPath:keyPath ofObject:object
    //                       change:change context:context];
    return;
}

@end
