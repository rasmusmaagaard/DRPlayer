//
//  NSDate+DRPAdditions.m
//  DR Player
//
//  Created by Richard Nees on 26/03/2013.
//
//

#import "NSDate+DRPAdditions.h"

@implementation NSDate (DRPAdditions)

+ (NSDate *)dateFromDRDateString:(NSString *)drDateString
{
	
	NSArray *drDateStringComponents = [drDateString componentsSeparatedByString:@"T"];
	
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	
	NSArray *drDateStringComponentsDateComponents = [drDateStringComponents[0] componentsSeparatedByString:@"-"];
	[comps setYear:[drDateStringComponentsDateComponents[0] intValue]];
	[comps setMonth:[drDateStringComponentsDateComponents[1] intValue]];
	[comps setDay:[drDateStringComponentsDateComponents[2] intValue]];
	
	NSArray *drDateStringComponentsTimeComponents = [drDateStringComponents[1] componentsSeparatedByString:@":"];
	[comps setHour:[drDateStringComponentsTimeComponents[0] intValue]];
	[comps setMinute:[drDateStringComponentsTimeComponents[1] intValue]];
	[comps setSecond:[drDateStringComponentsTimeComponents[2] intValue]];
	
	
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	[gregorian setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Copenhagen"]];
	
	NSDate *date = [gregorian dateFromComponents:comps];
    
	return date;
}

@end
