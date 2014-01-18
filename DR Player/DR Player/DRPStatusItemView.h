//
//  RFStatusItemView.h
//  Radio24syv
//
//  Created by Richard Nees on 30/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DRPStatusItemView : NSControl 

@property (nonatomic, getter = isMouseDown) BOOL mouseDown;
@property (nonatomic, strong) NSImage *image;
@property (nonatomic, strong) NSImage *alternateImage;
@property (nonatomic) id target;
@property (nonatomic) SEL action, rightAction;

@end