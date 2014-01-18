//
//  DRPCurrentListingController.m
//  DR Player
//
//  Created by Richard Nees on 29/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DRPCurrentListingController.h"

//

@implementation DRPCurrentListingController

- (NSArray *)arrangeObjects:(NSArray *)objects
{
    NSMutableArray *matchedObjects = [NSMutableArray arrayWithCapacity:[objects count]];
    
    for (NSMutableDictionary *program in objects) 
    {
        if ([[NSDate date] compare:program[@"ppu_stop_timestamp_presentation"]] !=  NSOrderedDescending) 
            [matchedObjects addObject:program];

    }
    return [super arrangeObjects:matchedObjects];
}

@end
