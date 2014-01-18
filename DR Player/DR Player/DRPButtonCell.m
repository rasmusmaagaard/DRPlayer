//
//  ExampleButtonCell.m
//
//  Created by Sean Patrick O'Brien on 4/3/08.
//  Copyright 2008 MolokoCacao. All rights reserved.
//

#import "DRPButtonCell.h"

#import "NSBezierPath+MCAdditions.h"
#import "NSShadow+MCAdditions.h"

@implementation DRPButtonCell

- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView
{
	static NSGradient *pressedGradient = nil;
	static NSGradient *normalGradient = nil;
	static NSColor *strokeColor = nil;
	static NSShadow *dropShadow = nil;
	static NSShadow *innerShadow1 = nil;
	static NSShadow *innerShadow2 = nil;
	
	if (pressedGradient == nil) {
		pressedGradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:.506 alpha:1.0]
														endingColor:[NSColor colorWithCalibratedWhite:.376 alpha:1.0]];
		normalGradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:.67 alpha:1.0]
													   endingColor:[NSColor whiteColor]];
		
		dropShadow = [[NSShadow alloc] initWithColor:[NSColor colorWithCalibratedWhite:.863 alpha:.75]
											  offset:NSMakeSize(0, -1.0) blurRadius:1.0];
		innerShadow1 = [[NSShadow alloc] initWithColor:[NSColor blackColor] offset:NSZeroSize blurRadius:3.0];
		innerShadow2 = [[NSShadow alloc] initWithColor:[NSColor colorWithCalibratedWhite:0.0 alpha:.52]
												offset:NSMakeSize(0.0, -2.0) blurRadius:8.0];
		
		strokeColor = [NSColor colorWithCalibratedWhite:.26 alpha:1.0];
	}

	// adjust the drawing area by 1 point to account for the drop shadow
	NSRect rect = frame;
	rect.size.height -= 1;
	CGFloat radius = 3.5;

	NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:radius yRadius:radius];

	// draw drop shadow
	[NSGraphicsContext saveGraphicsState];
	[dropShadow set];
	[path fill];
	[NSGraphicsContext restoreGraphicsState];
	
	// draw the gradient fill
	NSGradient *gradient = self.isHighlighted ? pressedGradient : normalGradient;
	[gradient drawInBezierPath:path angle:-90];

	// draw the inner stroke
	[strokeColor setStroke];
	[path strokeInside];

	if (self.isHighlighted) {
		// pressed button gets two inner shadows for depth
		[path fillWithInnerShadow:innerShadow1];
		[path fillWithInnerShadow:innerShadow2];
	}
}

@end
