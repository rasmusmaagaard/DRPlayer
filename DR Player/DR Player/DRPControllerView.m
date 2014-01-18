//
//  DRPControllerView.m
//  DR Player
//
//  Created by Richard Nees on 16/02/10.
//  Copyright 2010 Section Urbaine Software. All rights reserved.
//

#import "DRPControllerView.h"

@implementation DRPControllerView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    self.layerUsesCoreImageFilters = YES;
    self.wantsLayer = YES;
    self.layer.masksToBounds = YES;
    self.layer.backgroundColor = [NSColor colorWithCalibratedWhite:0.08f alpha:0.2f].CGColor;
    

    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{

}

- (BOOL)mouseDownCanMoveWindow
{
	return NO;
}

@end
