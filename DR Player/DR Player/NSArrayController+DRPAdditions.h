//
//  NSArrayController+DRPAdditions.h
//  DR Player
//
//  Created by Richard Nees on 26/03/2013.
//
//

#import <Cocoa/Cocoa.h>

@interface NSArrayController (DRPAdditions)

- (BOOL)loadStoreControllerWithPath:(NSString *)path andKey:(NSString *)key;
- (void)writeStoreControllerWithPath:(NSString *)path andKey:(NSString *)key;

@end
