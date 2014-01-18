//
//  DRPChannelSelectorButton.m
//  DR Player
//
//  Created by Richard Nees on 05.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DRPChannelSelectorButton.h"

@implementation DRPChannelSelectorButton

- (NSImage *)image
{
    NSLog(@"1 %@",[[super image] description]);
    if ([super image] == nil)
    {
        [self setImage:[NSImage imageNamed:@"LogoTitle"]];
        NSLog(@"2 %@",[[super image] description]);
    }
    return [super image];
}

@end
