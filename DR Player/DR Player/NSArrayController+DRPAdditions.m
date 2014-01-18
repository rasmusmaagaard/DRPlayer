//
//  NSArrayController+DRPAdditions.m
//  DR Player
//
//  Created by Richard Nees on 26/03/2013.
//
//

#import "NSArrayController+DRPAdditions.h"

@implementation NSArrayController (DRPAdditions)

- (BOOL)loadStoreControllerWithPath:(NSString *)path andKey:(NSString *)key
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
        return NO;
    
    NSDictionary *storeDict = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    if (storeDict && storeDict[key])
    {
        self.content = storeDict[key];
        self.selectionIndexes = [NSIndexSet indexSet];
        return YES;
    }
    return NO;
}

- (void)writeStoreControllerWithPath:(NSString *)path andKey:(NSString *)key
{
    NSError *error;
    NSDictionary *storeDict = @{DRPLastDate: [NSDate date], key: self.arrangedObjects};
   
    NSData *storeData = [NSKeyedArchiver archivedDataWithRootObject:storeDict];
    
    if(storeData) {
        [storeData writeToFile:path options:NSDataWritingAtomic error:&error];
    }
    else {
        DebugNSLog(@"%@", error);
    }
}

@end
