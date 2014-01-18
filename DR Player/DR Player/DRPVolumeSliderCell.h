//
//  DRPVolumeSliderCell.h
//  DR Player
//
//  Created by Richard Nees on 26/03/2013.
//
//

#import <Cocoa/Cocoa.h>

@interface DRPVolumeSliderCell : NSSliderCell
@property  (nonatomic, strong) NSImage  *knobImage;
@property  (nonatomic, strong) NSImage  *leftImage;
@property  (nonatomic, strong) NSImage  *middleImage;
@property  (nonatomic, strong) NSImage  *rightImage;
@property  (nonatomic, strong) NSImage  *trackerImage;

@end
