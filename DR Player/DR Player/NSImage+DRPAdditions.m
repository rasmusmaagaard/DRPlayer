//
//  NSImage+DRPAdditions.m
//  DR Player
//
//  Created by Richard Nees on 26/03/2013.
//
//

#import "NSImage+DRPAdditions.h"

@implementation NSImage (DRPAdditions)

+ (void)drawNoiseImage
{
//    NSUInteger size = 128.0f * 128.0f;
//    char *rgba = (char *)malloc(size); srand(124);
//    for(NSUInteger i=0; i < size; ++i){rgba[i] = rand()%256*0.015f;}
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
//    CGContextRef bitmapContext =
//    CGBitmapContextCreate(rgba, 128.0f, 128.0f, 8, 128.0f, colorSpace, kCGBitmapAlphaInfoMask|kCGImageAlphaNone);
//    CFRelease(colorSpace);
//    free(rgba);
//    CGImageRef noisePattern = CGBitmapContextCreateImage(bitmapContext);
////    CFRelease(bitmapContext);
//    
//    NSGraphicsContext *newContext = [NSGraphicsContext currentContext];
//    NSAssert(newContext, @"DRPImageUtilities");
//    
//    [NSGraphicsContext saveGraphicsState];
//    [newContext setCompositingOperation:NSCompositePlusLighter];
//    CGRect noisePatternRect = CGRectZero;
//    noisePatternRect.size = CGSizeMake(CGImageGetWidth(noisePattern), CGImageGetHeight(noisePattern));
//    
//    CGContextRef context = [newContext graphicsPort];
//    CGContextDrawTiledImage(context, noisePatternRect, noisePattern);
//    [NSGraphicsContext restoreGraphicsState];
//    
////    CFRelease(noisePattern);
}

- (NSImage *)horizontallyFlippedImage
{
    NSAffineTransform *transform = [NSAffineTransform transform];
    NSSize dimensions = self.size;
    
    NSAffineTransformStruct flip = { -1.0f, 0.0f, 0.0f, 1.0f, dimensions.width, 0.0f };

    NSImage *flippedImage = [[NSImage alloc] initWithSize:dimensions];
    [flippedImage lockFocus];
    [transform setTransformStruct:flip];
    [transform concat];
    [self drawAtPoint:NSZeroPoint
             fromRect:NSMakeRect(0.0f, 0.0f, dimensions.width, dimensions.height)
            operation:NSCompositeCopy
             fraction:1.0f];
    [flippedImage unlockFocus];
    
    return flippedImage;

}

- (NSImage *)verticallyFlippedImage
{
    NSAffineTransform *transform = [NSAffineTransform transform];
    NSSize dimensions = self.size;

    NSAffineTransformStruct flip = { 1.0, 0.0, 0.0, -1.0, 0.0, dimensions.height};

    NSImage *flippedImage = [[NSImage alloc] initWithSize:dimensions];
    [flippedImage lockFocus];
    [transform setTransformStruct:flip];
    [transform concat];
    [self drawAtPoint:NSZeroPoint
             fromRect:NSMakeRect(0.0f, 0.0f, dimensions.width, dimensions.height)
            operation:NSCompositeCopy
             fraction:1.0f];
    [flippedImage unlockFocus];
    
    return flippedImage;

}

@end
