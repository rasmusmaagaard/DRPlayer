//
//  DRPChannelUpdateOperation.h
//  DR Player
//
//  Created by Richard Nees on 06/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRPListingsUpdateOperation : NSOperation

-(id)init;

@property (nonatomic, strong) NSMutableArray   *listingsArray;

@end
