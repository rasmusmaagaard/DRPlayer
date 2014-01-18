//
//  NSImage+DRPAdditions.h
//  DR Player
//
//  Created by Richard Nees on 26/03/2013.
//
//

#import <Cocoa/Cocoa.h>

@interface NSImage (DRPAdditions)

+ (void)drawNoiseImage;
- (NSImage *)horizontallyFlippedImage;
- (NSImage *)verticallyFlippedImage;

@end
