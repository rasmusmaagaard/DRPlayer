//
//  ExampleButton.m
//

#import "DRPButton.h"
#import "DRPButtonCell.h"

@implementation DRPButton

+ (Class)cellClass
{
	return [DRPButtonCell class];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (![aDecoder isKindOfClass:[NSKeyedUnarchiver class]])
		return [super initWithCoder:aDecoder];
	
	NSKeyedUnarchiver *unarchiver = (NSKeyedUnarchiver *)aDecoder;
	Class oldClass = [[self superclass] cellClass];
	Class newClass = [[self class] cellClass];
	
	[unarchiver setClass:newClass forClassName:NSStringFromClass(oldClass)];
	self = [super initWithCoder:aDecoder];
	[unarchiver setClass:oldClass forClassName:NSStringFromClass(oldClass)];
	
	return self;
}

@end
