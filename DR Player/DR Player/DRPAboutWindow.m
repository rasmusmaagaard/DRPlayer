//
//  DRPAboutWindow.m
//  DR Player
//
//  Created by Richard Nees on 07/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DRPAboutWindow.h"

@implementation DRPAboutWindow

- (void)awakeFromNib
{
	[self setLevel:NSModalPanelWindowLevel];
    [self setOpaque:NO];
	[self setHasShadow:YES];
}

@end
