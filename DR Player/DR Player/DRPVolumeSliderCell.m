//
//  DRPVolumeSliderCell.m
//  DR Player
//
//  Created by Richard Nees on 26/03/2013.
//
//

#import "DRPVolumeSliderCell.h"

@implementation DRPVolumeSliderCell

- (NSImage *)knobImage
{
    NSRect imageRect = NSMakeRect(0.0f, 0.0f, NSHeight(self.controlView.frame), NSHeight(self.controlView.frame));
    NSImage *image = [[NSImage alloc] initWithSize:imageRect.size];
    
    [image lockFocus];
    
    NSBezierPath *path = [NSBezierPath bezierPathWithOvalInRect:imageRect];
    [path setWindingRule:NSEvenOddWindingRule];   // set the winding rule for filling
    [path addClip];
    
    [[NSColor whiteColor] set];
    [path fill];
    
    [image unlockFocus];
    
    return image;
}

- (NSImage *)trackerImage
{
    NSRect imageRect = NSMakeRect(0.0f, 0.0f, NSHeight(self.controlView.frame), NSHeight(self.controlView.frame));
    NSImage *image = [[NSImage alloc] initWithSize:imageRect.size];
    
    [image lockFocus];
    
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:imageRect];
    [path setWindingRule:NSEvenOddWindingRule];   // set the winding rule for filling
    [path addClip];
    
    [[NSColor lightGrayColor] set];
    [path fill];
    
    [image unlockFocus];
    
    return image;
}

- (NSImage *)middleImage
{
    NSRect imageRect = NSMakeRect(0.0f, 0.0f, 10.0f, NSHeight(self.controlView.frame));
    NSImage *image = [[NSImage alloc] initWithSize:imageRect.size];
    
    [image lockFocus];
    
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:imageRect];
//    [path setWindingRule:NSEvenOddWindingRule];   // set the winding rule for filling
    [path addClip];
    
    [[NSColor darkGrayColor] set];
    [path fill];
    
    [image unlockFocus];
    
    return image;
}

- (NSImage *)leftImage
{
    NSRect imageRect = NSMakeRect(0.0f, 0.0f, NSHeight(self.controlView.frame), NSHeight(self.controlView.frame));
    NSImage *image = [[NSImage alloc] initWithSize:imageRect.size];
    
    NSPoint point;
    CGFloat radius;
    
    // make smaller than enclosing frame
    radius = imageRect.size.height / 2.0f;
    point = imageRect.origin;
    point.x += radius;
    point.y += radius;
    
    
    [image lockFocus];
    
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path setWindingRule:NSEvenOddWindingRule];   // set the winding rule for filling
    
    [path appendBezierPathWithArcWithCenter:point
                                     radius:radius
                                 startAngle:90.0f
                                   endAngle:270.0f];
    [path closePath];
    
    [path addClip];
    
    [[NSColor lightGrayColor] set];
    [path fill];
    
    [image unlockFocus];
    
    NSRect halfImageRect = imageRect;
    halfImageRect.size.width = halfImageRect.size.width/2;
    NSImage *halfImage = [[NSImage alloc] initWithSize:halfImageRect.size];
    
    [halfImage lockFocus];
    
    [image drawAtPoint:NSZeroPoint
              fromRect:halfImageRect
             operation:NSCompositeSourceOver
              fraction:1.0f];
    
    [halfImage unlockFocus];

    return halfImage;
}

- (NSImage *)rightImage
{
    NSRect imageRect = NSMakeRect(0.0f, 0.0f, NSHeight(self.controlView.frame), NSHeight(self.controlView.frame));
    NSImage *image = [[NSImage alloc] initWithSize:imageRect.size];
    
    NSPoint point;
    CGFloat radius;
    
    // make smaller than enclosing frame
    radius = imageRect.size.height / 2.0f;
    point = imageRect.origin;
    point.x += radius;
    point.y += radius;
    
    
    [image lockFocus];
    
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path setWindingRule:NSEvenOddWindingRule];   // set the winding rule for filling
    
    [path appendBezierPathWithArcWithCenter:point
                                     radius:radius
                                 startAngle:270.0f
                                   endAngle:90.0f];
    [path closePath];
    
    [path addClip];
    
    [[NSColor darkGrayColor] set];
    [path fill];
    
    [image unlockFocus];
    
    NSRect halfImageRect = imageRect;
    halfImageRect.origin.x = halfImageRect.size.width/2;
    halfImageRect.size.width = halfImageRect.size.width/2;
    NSImage *halfImage = [[NSImage alloc] initWithSize:halfImageRect.size];
    
    [halfImage lockFocus];
    
    [image drawAtPoint:NSZeroPoint
              fromRect:halfImageRect
             operation:NSCompositeSourceOver
              fraction:1.0f];
    
    [halfImage unlockFocus];
    
    return halfImage;
}

- (void)drawKnob:(NSRect)knobRect
{
	[[self controlView] lockFocus];
    NSPoint drawPoint;
	drawPoint.x = knobRect.origin.x + roundf((knobRect.size.width - self.knobImage.size.width) / 2);
	drawPoint.y =  roundf((knobRect.size.height - self.knobImage.size.height) / 2);
    
    [self.knobImage drawAtPoint:drawPoint
                       fromRect:NSZeroRect
                      operation:NSCompositeSourceOver
                       fraction:1.0f];
    
    [[self controlView] unlockFocus];
    
}

- (void)drawBarInside:(NSRect)cellFrame flipped:(BOOL)flipped
{
    NSRect slideRect = cellFrame;
//    slideRect.origin.y += 2.0f;
    
    // Create a Canvas
	NSImage *canvas = [[NSImage alloc] initWithSize:slideRect.size];
	NSRect canvasRect = NSMakeRect(0, 0, [canvas size].width, [canvas size].height);
	
    
	// Draw fill onto Canvas
	[canvas lockFocus];
	[self.leftImage drawInRect:NSMakeRect(slideRect.origin.x,
                                          slideRect.origin.y,
                                          self.leftImage.size.width,
                                          self.leftImage.size.height)
                      fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];
    
    [self.middleImage drawInRect:NSMakeRect(slideRect.origin.x+self.leftImage.size.width,
                                            slideRect.origin.y,
                                            slideRect.size.width-(self.leftImage.size.width+self.rightImage.size.width),
                                            self.middleImage.size.height)
                        fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];
    
        
    CGFloat comparisionWidth = slideRect.size.width - (self.leftImage.size.width + self.rightImage.size.width);

    CGFloat adjustedPosition = roundf(comparisionWidth * self.doubleValue);
 
    [self.trackerImage drawInRect:NSMakeRect(slideRect.origin.x+self.leftImage.size.width,
                                             slideRect.origin.y,
                                             adjustedPosition,
                                             self.trackerImage.size.height)
                         fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];
    
    
    
    [self.rightImage drawInRect:NSMakeRect(slideRect.size.width-self.rightImage.size.width,
                                           slideRect.origin.y,
                                           self.rightImage.size.width,
                                           self.rightImage.size.height)
                       fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];
    
    
	[canvas unlockFocus];
    
	// Draw canvas
	[[self controlView] lockFocus];
	[canvas drawInRect:slideRect
			  fromRect:canvasRect
			 operation:NSCompositeSourceOver
			  fraction:1.0f];
	[[self controlView] unlockFocus];
    
    
	
    
}

- (void) drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView*)controlView {
    cellFrame = [self drawingRectForBounds:cellFrame];
    [controlView lockFocus];
    //_trackRect = cellFrame;
    [self drawBarInside:cellFrame flipped:[controlView isFlipped]];
    [self drawKnob];
    [controlView unlockFocus];
}

- (BOOL)_usesCustomTrackImage
{
	return YES;
}

- (BOOL)startTrackingAt:(NSPoint)startPoint inView:(NSView *)controlView
{
    //	isPressed = YES;
	return [super startTrackingAt:startPoint inView:controlView];
}

- (void)stopTracking:(NSPoint)lastPoint at:(NSPoint)stopPoint inView:(NSView *)controlView mouseIsUp:(BOOL)flag
{
    //	isPressed = NO;
	[super stopTracking:(NSPoint)lastPoint at:(NSPoint)stopPoint inView:(NSView *)controlView mouseIsUp:(BOOL)flag];
}

@end
