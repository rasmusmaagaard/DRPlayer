//
//  RFPrefsViewController.m
//  Radio24syv
//
//  Created by Richard Nees on 29/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DRPPrefsViewController.h"
#import "DRPAppDelegate.h"

@implementation DRPPrefsViewController


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
}

- (void)awakeFromNib
{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
	
    [self.versionTextField setStringValue:[NSString localizedStringWithFormat:@"Version %@ (v%@)", infoPlist[@"CFBundleShortVersionString"], infoPlist[@"CFBundleVersion"]]];
    [self.copyrightTextField setStringValue:NSLocalizedStringFromTable(@"NSHumanReadableCopyright", @"InfoPlist", @"")];
    
}

- (IBAction)checkForUpdatesProxy:(id)sender
{
    [[[NSApp delegate] updater] checkForUpdates:sender];
    
    [self.statusMenuPrefsPopover performClose:sender];
}

@end
