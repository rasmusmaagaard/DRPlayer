//
//  DRPVolumeSlider.m
//  DR Player
//
//  Created by Richard on 03/01/14.
//
//

#import "DRPVolumeSlider.h"
#import "DRPVolumeSliderCell.h"

@implementation DRPVolumeSlider

+ (void)initialize;
{
    if (self == [DRPVolumeSlider class])
    {
        [self setCellClass:[DRPVolumeSliderCell class]];
    }
}
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

#pragma mark - Redraw

- (void)setNeedsDisplayInRect:(NSRect)invalidRect
{
    [super setNeedsDisplayInRect:[self bounds]];
}

@end
