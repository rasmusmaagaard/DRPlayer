//
//  DRPWidgetView.h
//  DR Player
//
//  Created by Richard Nees on 16/02/10.
//  Copyright 2010 Section Urbaine Software. All rights reserved.
//

@interface DRPWidgetView : NSView 
@property (nonatomic, getter = isActiveState) BOOL activeState;
@property (nonatomic) NSTrackingRectTag viewTrackingRect;
@property (nonatomic, weak) IBOutlet NSButton *closeButton;
@property (nonatomic, weak) IBOutlet NSButton *miniaturizeButton;
@property (nonatomic, weak) IBOutlet NSButton *zoomButton;

- (void)refresh;

@end
