//
//  DRPFullscreenWidgetView.h
//  DR Player
//
//  Created by Richard Nees on 27/10/11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DRPFullscreenWidgetView : NSView
@property (nonatomic) NSTrackingRectTag viewTrackingRect;
@property (nonatomic, weak) IBOutlet NSButton *fullscreenButton;

@end
