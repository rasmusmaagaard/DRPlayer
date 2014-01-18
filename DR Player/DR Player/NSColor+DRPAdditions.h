//
//  NSColor+DRPAdditions.h
//  DR Player
//
//  Created by Richard on 07/01/14.
//
//

#import <Cocoa/Cocoa.h>

@interface NSColor (DRPAdditions)

+ (NSColor *)colorFromHexRGB:(NSString *)inColorString;
- (NSString *)hexRGBRepresentation;

@end
