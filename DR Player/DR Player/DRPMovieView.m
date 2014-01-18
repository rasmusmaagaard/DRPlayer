//
//  DRPMainContentView.m
//  DR Player
//
//  Created by Richard Nees on 15/02/10.
//  Copyright 2010 Section Urbaine Software. All rights reserved.
//

#import "DRPMovieView.h"
#import "DRPAppDelegate.h"
#import "DRPControlsViewController.h"

@implementation DRPMovieView

#pragma mark Initialization

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];

	return self;
}

- (void)dealloc
{
}

#pragma mark View Drawing

//- (void)drawRect:(NSRect)rect 
//{
//}

#pragma mark Misc

- (BOOL)mouseDownCanMoveWindow
{
	return YES;
}


@end
