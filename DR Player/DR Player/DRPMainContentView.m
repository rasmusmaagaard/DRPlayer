//
//  DRPMainContentView.m
//  DR Player
//
//  Created by Richard Nees on 16/02/10.
//  Copyright 2010 Section Urbaine Software. All rights reserved.
//

#import "DRPMainContentView.h"
#import "DRPAppDelegate.h"
#import "DRPMainWindow.h"
#import "DRPControlsViewController.h"
#import "DRPTitleBar.h"

@implementation DRPMainContentView

#define kSwipeMinimumLength 0.3

#pragma mark Initialization

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self)
	{
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor blackColor].CGColor;
        
    }
    return self;
}

- (void)dealloc
{
}

- (BOOL)acceptsFirstResponder {
    return YES;		// Use me with the keyboard....
}

- (void)awakeFromNib
{
    self.foregroundGradient = [[NSGradient alloc] initWithColors:
                               @[[NSColor colorWithDeviceWhite:0.333f alpha:0.7f],
                                 [NSColor colorWithDeviceWhite:0.111f alpha:0.7f]]];
    
	
	[self updateTrackingAreas];
	
    
	self.logoImage = [NSImage imageNamed:@"DRLogoLarge"];
}

#pragma mark View Drawing

- (void)drawRect:(NSRect)dirtyRect {
	
	NSRect bgRect = [self bounds];
	
	
	NSBezierPath* box = [NSBezierPath bezierPath];
	CGFloat radius = 5.0;
    if ([[NSApp delegate] inFullScreenMode])
	{
        radius = 0.0;
    }
    
	NSRect newRect = NSInsetRect(bgRect, radius, radius);
	[box appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(newRect), NSMinY(newRect)) radius:radius startAngle:180.0 endAngle:270.0];
	[box appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(newRect), NSMinY(newRect)) radius:radius startAngle:270.0 endAngle:360.0];
	[box appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(newRect), NSMaxY(newRect)) radius:radius startAngle:  0.0 endAngle: 90.0];
	[box appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(newRect), NSMaxY(newRect)) radius:radius startAngle: 90.0 endAngle:180.0];
	[box closePath];
	
	[[NSColor colorWithCalibratedWhite:0.0f alpha:1.0f] set];
    [box fill];
    [self.foregroundGradient drawInBezierPath:box relativeCenterPosition:NSZeroPoint];
    [NSGraphicsContext saveGraphicsState];
    
    [box addClip];
    [NSImage drawNoiseImage];
    [NSGraphicsContext restoreGraphicsState];
    
    [self.logoImage drawAtPoint:NSMakePoint(
                                            self.frame.size.width/2-self.logoImage.size.width/2,
                                            self.frame.size.height/2-self.logoImage.size.height/2
                                            )
                       fromRect:NSZeroRect
                      operation:NSCompositeSourceOver
                       fraction:1.0f];
    
}

#pragma mark Dynamic UI mouse over

- (void)updateTrackingAreas
{
	[self removeTrackingRect:self.viewTrackingRect];
	NSRect trackingRect = [self frame];
	self.viewTrackingRect = [self addTrackingRect:trackingRect owner:self userData:nil assumeInside:YES];
	
	[super updateTrackingAreas];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
	[[[NSApp delegate] controlsViewController] showUIControls:nil];
}

-(void)mouseMoved:(NSEvent *)theEvent
{
    BOOL isBeingAutoShown = [[[NSApp delegate] controlsViewController] isBeingAutoShown];
    
    NSPoint mousePosition = [theEvent locationInWindow];
	if (!isBeingAutoShown && (NSPointInRect(mousePosition, [self frame])))
	{
		[[[NSApp delegate] controlsViewController] showUIControls:nil];
	}
    
    if ([[NSApp delegate] inFullScreenMode])
        [self recreateHideMouseTimer];
    
}

-(void)mouseExited:(NSEvent *)theEvent
{
	[[[NSApp delegate] controlsViewController] hideUIControls:nil];
}

- (void)keyDown:(NSEvent *)theEvent
{
    if ([theEvent keyCode] == 49)
    {
    	//Spacebar to Play/Pause movie playback
        [[NSApp delegate] togglePlayback:nil];
	    return;
    }
    
    [super keyDown:theEvent];
}

- (void)recreateHideMouseTimer
{
    if (_hideMouseTimer != nil) {
        [_hideMouseTimer invalidate];
    }
    
    _hideMouseTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f
                                                       target:self
                                                     selector:@selector(hideMouseCursor:)
                                                     userInfo:nil
                                                      repeats:NO];
}

- (void)hideMouseCursor:(NSTimer *)timer
{
    [NSCursor setHiddenUntilMouseMoves: YES];
}

#pragma mark Double Click

- (void)mouseUp:(NSEvent *)theEvent
{
    if([theEvent clickCount] == 1)
    {
    }
    else if([theEvent clickCount] == 2)
    {
        NSPoint mousePosition = [[[NSApp delegate] mainWindow] convertScreenToBase:[NSEvent mouseLocation]];
        
        if (NSPointInRect(mousePosition, [[[[NSApp delegate] controlsViewController] titleBarView] frame]))
        {
            [[[NSApp delegate] mainWindow] miniaturize:nil];
        }
        else
        {
            [self.window toggleFullScreen:nil];
        }
    }
}

#pragma mark Multitouch

-(void)magnifyWithEvent:(NSEvent *)event
{
	if ([event magnification] > 0.02)
	{
		if (![[NSApp delegate] inFullScreenMode])
		{
			[self.window toggleFullScreen:nil];
		}
	}
	else if ([event magnification] < -0.02)
	{
		if ([[NSApp delegate] inFullScreenMode])
		{
			[self.window toggleFullScreen:nil];
		}
	}
}


- (void)rotateWithEvent:(NSEvent *)event
{
	if ([event rotation] < 0)
	{
		[[NSApp delegate] increaseMovieVolume:nil];
	}
	else
	{
		[[NSApp delegate] decreaseMovieVolume:nil];
	}
}

-(BOOL)recognizeTwoFingerGestures
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:@"AppleEnableSwipeNavigateWithScrolls"];
}

- (void)beginGestureWithEvent:(NSEvent *)event
{
    if (![self recognizeTwoFingerGestures])
        return;
    
    NSSet *touches = [event touchesMatchingPhase:NSTouchPhaseAny inView:nil];
    
    self.twoFingersTouches = [NSMutableDictionary dictionaryWithCapacity:[touches count]];
    
    for (NSTouch *touch in touches) {
        (self.twoFingersTouches)[touch.identity] = touch;
    }
}

- (void)endGestureWithEvent:(NSEvent *)event
{
    if (!self.twoFingersTouches) return;
    
    NSSet *touches = [event touchesMatchingPhase:NSTouchPhaseAny inView:nil];
    
    // release twoFingersTouches early
    NSMutableDictionary *beginTouches = [self.twoFingersTouches copy];
    self.twoFingersTouches = nil;
    
    NSMutableArray *magnitudes = [[NSMutableArray alloc] init];
    
    for (NSTouch *touch in touches)
    {
        NSTouch *beginTouch = beginTouches[touch.identity];
        
        if (!beginTouch) continue;
        
        float magnitude = touch.normalizedPosition.x - beginTouch.normalizedPosition.x;
        [magnitudes addObject:@(magnitude)];
    }
    
    // Need at least two points
    if ([magnitudes count] < 2)
    {
        return;
    }
    
    float sum = 0;
    
    for (NSNumber *magnitude in magnitudes)
        sum += [magnitude floatValue];
    
    
    // Handle natural direction in Lion
    BOOL naturalDirectionEnabled = [[[NSUserDefaults standardUserDefaults] valueForKey:@"com.apple.swipescrolldirection"] boolValue];
    
    if (naturalDirectionEnabled)
        sum *= -1;
    
    // See if absolute sum is long enough to be considered a complete gesture
    float absoluteSum = fabsf(sum);
    
    if (absoluteSum < kSwipeMinimumLength) return;
    
    // Handle the actual swipe
    if (sum > 0)
    {
		[[NSApp delegate] selectAndPlayNextChannel:nil];
    } else
    {
		[[NSApp delegate] selectAndPlayPreviousChannel:nil];
    }
}

@end
