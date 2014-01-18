//
//  DRPMainContentView.h
//  DR Player
//
//  Created by Richard Nees on 16/02/10.
//  Copyright 2010 Section Urbaine Software. All rights reserved.
//



@class DRPMainWindow;

@interface DRPMainContentView : NSView 

@property (nonatomic, strong) NSMutableDictionary *twoFingersTouches;
@property NSTrackingRectTag viewTrackingRect;
@property (nonatomic, strong) NSImage *logoImage;
@property (nonatomic, strong) NSGradient *foregroundGradient;
@property (nonatomic, strong) NSTimer *hideMouseTimer;

- (void)recreateHideMouseTimer;
- (void)hideMouseCursor:(NSTimer *)timer;

@end
