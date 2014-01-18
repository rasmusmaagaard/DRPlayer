//
//  DRPSelectedListingController.m
//  DR Player
//
//  Created by Richard Nees on 01/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DRPSelectedListingController.h"

@implementation DRPSelectedListingController


- (NSArray *)arrangeObjects:(NSArray *)objects
{
    NSMutableArray *matchedObjects = [NSMutableArray arrayWithCapacity:[objects count]];
    for (NSMutableDictionary *program in objects) 
    {
        NSDate *startDate = program[@"ppu_start_timestamp_presentation"];
        NSDate *stopDate  = program[@"ppu_stop_timestamp_presentation"];
        NSDate *nowDate   = [NSDate date];
        
        if ((![startDate isEqual:[startDate laterDate:nowDate]]) && (![stopDate isEqual:[stopDate earlierDate:nowDate]]))
        {
            [matchedObjects addObject:program];
        }
    }
    return [super arrangeObjects:matchedObjects];
}

@end
