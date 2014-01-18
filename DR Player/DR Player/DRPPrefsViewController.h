//
//  RFPrefsViewController.h
//  Radio24syv
//
//  Created by Richard Nees on 29/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DRPPrefsViewController : NSViewController

@property (nonatomic, weak) IBOutlet NSPopover           *statusMenuPrefsPopover;

@property (nonatomic, weak) IBOutlet NSTextField         *versionTextField;
@property (nonatomic, weak) IBOutlet NSTextField         *copyrightTextField;
@property (nonatomic, weak) IBOutlet NSButton            *updateButton;
@property (nonatomic, weak) IBOutlet NSButton            *quitButton;


- (IBAction)checkForUpdatesProxy:(id)sender;

@end
