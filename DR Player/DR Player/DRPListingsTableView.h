//
//  DRPScrollView.h
//  DR Player
//
//  Created by Richard Nees on 24/02/10.
//  Copyright 2010 Section Urbaine Software. All rights reserved.
//

@interface DRPListingsTableView : NSTableView <NSTableViewDelegate>

@property (nonatomic, weak) IBOutlet NSArrayController   *arrayController;

- (void)scrollToActive;

@end
