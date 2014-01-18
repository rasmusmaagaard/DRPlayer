//
//  DRPValueTransformers.m
//  DR Player
//
//  Created by Richard Nees on 02/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DRPValueTransformers.h"

@implementation DRPValueTransformersController

+ (void)setupValueTransformers
{
    NSValueTransformer *formattedChannelIdTrans = [[FormattedChannelIdTransformer alloc] init];
    [NSValueTransformer setValueTransformer:formattedChannelIdTrans forName:NSStringFromClass([FormattedChannelIdTransformer class])];
    
    NSValueTransformer *formattedProductionCodeTrans = [[FormattedProductionCodeTransformer alloc] init];
    [NSValueTransformer setValueTransformer:formattedProductionCodeTrans forName:NSStringFromClass([FormattedProductionCodeTransformer class])];
    
    NSValueTransformer *formattedProgramPresentationTrans = [[FormattedProgramPresentationTransformer alloc] init];
    [NSValueTransformer setValueTransformer:formattedProgramPresentationTrans forName:NSStringFromClass([FormattedProgramPresentationTransformer class])];
    
    NSValueTransformer *formattedProgramTitleTrans = [[FormattedProgramTitleTransformer alloc] init];
    [NSValueTransformer setValueTransformer:formattedProgramTitleTrans forName:NSStringFromClass([FormattedProgramTitleTransformer class])];
    
    NSValueTransformer *formattedProgramTimeTrans = [[FormattedProgramTimeTransformer alloc] init];
    [NSValueTransformer setValueTransformer:formattedProgramTimeTrans forName:NSStringFromClass([FormattedProgramTimeTransformer class])];
    
    NSValueTransformer *formattedProgramDescriptionTrans = [[FormattedProgramDescriptionTransformer alloc] init];
    [NSValueTransformer setValueTransformer:formattedProgramDescriptionTrans forName:NSStringFromClass([FormattedProgramDescriptionTransformer class])];
    
    NSValueTransformer *formattedProgramItemsSmallLeftTrans = [[FormattedProgramItemsSmallLeftTransformer alloc] init];
    [NSValueTransformer setValueTransformer:formattedProgramItemsSmallLeftTrans forName:NSStringFromClass([FormattedProgramItemsSmallLeftTransformer class])];
    
    NSValueTransformer *formattedProgramItemsSmallCenterTrans = [[FormattedProgramItemsSmallCenterTransformer alloc] init];
    [NSValueTransformer setValueTransformer:formattedProgramItemsSmallCenterTrans forName:NSStringFromClass([FormattedProgramItemsSmallCenterTransformer class])];
    
    NSValueTransformer *channelImageSelectorTrans = [[ChannelImageSelectorTransformer alloc] init];
    [NSValueTransformer setValueTransformer:channelImageSelectorTrans forName:NSStringFromClass([ChannelImageSelectorTransformer class])];
    
    NSValueTransformer *channelImageCollectionSelectorTrans = [[ChannelImageCollectionSelectorTransformer alloc] init];
    [NSValueTransformer setValueTransformer:channelImageCollectionSelectorTrans forName:NSStringFromClass([ChannelImageCollectionSelectorTransformer class])];
    
    NSValueTransformer *programHasWebLinkTrans = [[ProgramHasWebLinkTransformer alloc] init];
    [NSValueTransformer setValueTransformer:programHasWebLinkTrans forName:NSStringFromClass([ProgramHasWebLinkTransformer class])];
    
    NSValueTransformer *programIsRunningTrans = [[ProgramIsRunningTransformer alloc] init];
    [NSValueTransformer setValueTransformer:programIsRunningTrans forName:NSStringFromClass([ProgramIsRunningTransformer class])];
}

@end

@implementation FormattedChannelIdTransformer

+ (Class)transformedValueClass {
    return [NSAttributedString class];
}

- (id)transformedValue:(id)value {
    if (value == nil) {
        return nil;
    }
    
	NSMutableAttributedString *descriptionString = [[NSMutableAttributedString alloc] initWithString:@""];
	
	NSAttributedString *attrString0 = [[NSAttributedString alloc] initWithString:[NSString localizedStringWithFormat:@"%@", value] 
                                                                      attributes:[NSAttributedString boldTextStyleAttributesForFontSize:24.0f textAlignment:NSRightTextAlignment]];
	[descriptionString appendAttributedString:attrString0];
    
    return descriptionString;
}

@end

@implementation FormattedProductionCodeTransformer

+ (Class)transformedValueClass {
    return [NSAttributedString class];
}

- (id)transformedValue:(id)value {
    if (value == nil) {
        return nil;
    }
    
	NSMutableAttributedString *descriptionString = [[NSMutableAttributedString alloc] initWithString:@""];
	
	NSMutableParagraphStyle *pStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[pStyle setLineBreakMode:NSLineBreakByTruncatingTail];
	[pStyle setAlignment:NSLeftTextAlignment];
	   
	NSDictionary *emphasizedAttributes = @{NSForegroundColorAttributeName: [NSColor colorWithCalibratedWhite:1.0 alpha:1.0], 
                                           NSFontAttributeName: [NSFont boldSystemFontOfSize:11.0f], 
                                           NSParagraphStyleAttributeName: pStyle};
	
	
	
	
	
	NSAttributedString *attrString0 =
	[[NSAttributedString alloc] initWithString:[NSString localizedStringWithFormat:@"%@", NSLocalizedStringFromTable(value, @"GenreCodes", @"")] attributes:emphasizedAttributes];
	[descriptionString appendAttributedString:attrString0];
	
    return descriptionString;
}

@end

@implementation FormattedProgramPresentationTransformer

+ (Class)transformedValueClass {
    return [NSAttributedString class];
}

- (id)transformedValue:(id)value 
{
    if ([value count] > 0)
    {
        NSMutableDictionary *currentListing = value[0];
        
        NSMutableAttributedString *descriptionString = [[NSMutableAttributedString alloc] initWithString:@""];
        
        NSMutableParagraphStyle *pStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [pStyle setLineBreakMode:NSLineBreakByTruncatingTail];
        [pStyle setAlignment:NSLeftTextAlignment];
        
        NSDictionary *titleEmphasizedAttributes = @{NSForegroundColorAttributeName: [NSColor colorWithCalibratedWhite:1.0 alpha:1.0], 
                                                    NSFontAttributeName: [NSFont boldSystemFontOfSize:9.0f], 
                                                    NSParagraphStyleAttributeName: pStyle};
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterNoStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
        NSDate *dateToTransform1 = [currentListing valueForKey:@"ppu_start_timestamp_announced"];
        NSString *announcedDateString = [dateFormatter stringFromDate:dateToTransform1];
        
        NSString *pro_title = [currentListing valueForKey:@"pro_title"];
        
        NSAttributedString *attrString0 =
        [[NSAttributedString alloc] initWithString:[NSString localizedStringWithFormat:@"%@ ", announcedDateString] attributes:titleEmphasizedAttributes];
        [descriptionString appendAttributedString:attrString0];
        
        NSAttributedString *attrString1 =
        [[NSAttributedString alloc] initWithString:[NSString localizedStringWithFormat:@"%@", pro_title] attributes:titleEmphasizedAttributes];
        [descriptionString appendAttributedString:attrString1];
        
        return descriptionString;
        
    }
    return nil;
}

@end

@implementation FormattedProgramTimeTransformer

+ (Class)transformedValueClass {
    return [NSAttributedString class];
}

- (id)transformedValue:(id)value {
    if (value == nil) {
        return nil;
    }
    
	NSMutableAttributedString *descriptionString = [[NSMutableAttributedString alloc] initWithString:@""];
	
	NSMutableParagraphStyle *pStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[pStyle setLineBreakMode:NSLineBreakByTruncatingTail];
	[pStyle setAlignment:NSRightTextAlignment];
	   
	NSDictionary *timeEmphasizedAttributes = @{NSForegroundColorAttributeName: [NSColor colorWithCalibratedWhite:1.0 alpha:1.0], 
                                               NSFontAttributeName: [NSFont boldSystemFontOfSize:12.0f], 
                                               NSParagraphStyleAttributeName: pStyle};
	
	
	
	NSDictionary *timeAttributes = @{NSForegroundColorAttributeName: [NSColor colorWithCalibratedWhite:1.0 alpha:0.3], 
                                     NSFontAttributeName: [NSFont systemFontOfSize:9.0f], 
                                     NSParagraphStyleAttributeName: pStyle};
	
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterNoStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	
	NSDate *dateToTransform1 = [value valueForKey:@"ppu_start_timestamp_announced"];
	NSString *startAnnouncedDateString = [dateFormatter stringFromDate:dateToTransform1];
	NSDate *dateToTransform2 = [value valueForKey:@"ppu_start_timestamp_presentation"];
	NSString *startPresentationDateString = [dateFormatter stringFromDate:dateToTransform2];
	NSDate *dateToTransform3 = [value valueForKey:@"ppu_stop_timestamp_presentation"];
	NSString *stopPresentationDateString = [dateFormatter stringFromDate:dateToTransform3];
	
	NSAttributedString *attrString0 =
	[[NSAttributedString alloc] initWithString:[NSString localizedStringWithFormat:@"%@", startAnnouncedDateString] attributes:timeEmphasizedAttributes];
	[descriptionString appendAttributedString:attrString0];
	
	NSAttributedString *attrString1 =
	[[NSAttributedString alloc] initWithString:[NSString localizedStringWithFormat:@"\n%@", startPresentationDateString] attributes:timeAttributes];
	[descriptionString appendAttributedString:attrString1];
	
	NSAttributedString *attrString2 =
	[[NSAttributedString alloc] initWithString:[NSString localizedStringWithFormat:@"\n%@", stopPresentationDateString] attributes:timeAttributes];
	[descriptionString appendAttributedString:attrString2];
	
	return descriptionString;
}

@end

@implementation FormattedProgramTitleTransformer

+ (Class)transformedValueClass {
    return [NSAttributedString class];
}

- (id)transformedValue:(id)value {
    if (value == nil) {
        return nil;
    }
    
	NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc] initWithString:@""];
	
	NSMutableParagraphStyle *pStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[pStyle setLineBreakMode:NSLineBreakByTruncatingTail];
	[pStyle setAlignment:NSLeftTextAlignment];
	   
	NSDictionary *titleEmphasizedAttributes = @{NSForegroundColorAttributeName: [NSColor colorWithCalibratedWhite:1.0 alpha:1.0], 
                                                NSFontAttributeName: [NSFont boldSystemFontOfSize:12.0f], 
                                                NSParagraphStyleAttributeName: pStyle};
    
    NSDictionary *titleAttributes = @{NSForegroundColorAttributeName: [NSColor colorWithCalibratedWhite:1.0 alpha:1.0], 
                                      NSFontAttributeName: [NSFont systemFontOfSize:9.0f], 
                                      NSParagraphStyleAttributeName: pStyle};
    	
	NSAttributedString *attrString =
	[[NSAttributedString alloc] initWithString:[NSString localizedStringWithFormat:@"%@", [value valueForKey:@"pro_title"]] attributes:titleEmphasizedAttributes];
	[titleAttributedString appendAttributedString:attrString];
	
    if ([value valueForKey:@"ppu_punchline"])
    {
        NSAttributedString *attrString =
        [[NSAttributedString alloc] initWithString:[NSString localizedStringWithFormat:@"\n%@", [value valueForKey:@"ppu_punchline"]] attributes:titleAttributes];
        [titleAttributedString appendAttributedString:attrString];
    }
	
	if ([value valueForKey:@"pro_category"])
    {
        NSAttributedString *attrString =
        [[NSAttributedString alloc] initWithString:[NSString localizedStringWithFormat:@"\n%@", [value valueForKey:@"pro_category"]] attributes:titleAttributes];
        [titleAttributedString appendAttributedString:attrString];
    }
	
	return titleAttributedString;
}

@end

@implementation FormattedProgramDescriptionTransformer

+ (Class)transformedValueClass {
    return [NSAttributedString class];
}

- (id)transformedValue:(id)value {
    if (value == nil) {
        return nil;
    }
    
	NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc] initWithString:@""];
	
	
	NSMutableParagraphStyle *pStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[pStyle setLineBreakMode:NSLineBreakByWordWrapping];
	[pStyle setAlignment:NSLeftTextAlignment];
	   
	NSDictionary *titleEmphasizedAttributes = @{NSForegroundColorAttributeName: [NSColor colorWithCalibratedWhite:1.0 alpha:1.0], 
                                                NSFontAttributeName: [NSFont systemFontOfSize:11.0f], 
                                                NSParagraphStyleAttributeName: pStyle};
    
	
	NSAttributedString *attrString =
	[[NSAttributedString alloc] initWithString:[NSString localizedStringWithFormat:@"%@", value] attributes:titleEmphasizedAttributes];
	[titleAttributedString appendAttributedString:attrString];
	
	return titleAttributedString;
}

@end

@implementation FormattedProgramItemsSmallLeftTransformer

+ (Class)transformedValueClass {
    return [NSAttributedString class];
}

- (id)transformedValue:(id)value {
    if (value == nil) {
        return nil;
    }
    
	NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc] initWithString:@""];
	   
	NSDictionary *titleEmphasizedAttributes = @{NSForegroundColorAttributeName: [NSColor colorWithCalibratedWhite:1.0 alpha:1.0], 
                                                NSFontAttributeName: [NSFont systemFontOfSize:11.0f]};
    	
	NSAttributedString *attrString =
	[[NSAttributedString alloc] initWithString:[NSString localizedStringWithFormat:@"%@", value] attributes:titleEmphasizedAttributes];
	[titleAttributedString appendAttributedString:attrString];
	
	return titleAttributedString;
}

@end

@implementation FormattedProgramItemsSmallCenterTransformer

+ (Class)transformedValueClass {
    return [NSAttributedString class];
}

- (id)transformedValue:(id)value {
    if (value == nil) {
        return nil;
    }
    
	NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc] initWithString:@""];
	
    NSMutableParagraphStyle *pStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[pStyle setLineBreakMode:NSLineBreakByTruncatingTail];
	[pStyle setAlignment:NSCenterTextAlignment];
	   
	NSDictionary *titleEmphasizedAttributes = @{NSForegroundColorAttributeName: [NSColor colorWithCalibratedWhite:1.0 alpha:1.0], 
                                                NSFontAttributeName: [NSFont systemFontOfSize:11.0f], 
                                                NSParagraphStyleAttributeName: pStyle};
    
	
	NSAttributedString *attrString =
	[[NSAttributedString alloc] initWithString:[NSString localizedStringWithFormat:@"%@", value] attributes:titleEmphasizedAttributes];
	[titleAttributedString appendAttributedString:attrString];
	
	return titleAttributedString;
}

@end

@implementation ChannelImageSelectorTransformer

+ (Class)transformedValueClass 
{
	return [NSImage class];
}

- (id)transformedValue:(id)value 
{
    if (value == nil) 
    {
        NSImage *defaultImage = [NSImage imageNamed:@"DRLogoLarge"];
		return defaultImage;
    }
    
    NSImage *newImage = nil;
    newImage = [[NSImage alloc] initWithContentsOfFile:[[[NSString channelIconDirectoryPath] stringByAppendingPathComponent:[value stringValue]] stringByAppendingPathExtension:@"tiff"]];
    
    NSImage *channelImageBackground = [[NSImage imageNamed:@"ChannelSelectorAlternate"] copy];
    
    [channelImageBackground lockFocus];
    [newImage drawAtPoint:NSMakePoint(channelImageBackground.size.width/2-newImage.size.width/2,
                                      (channelImageBackground.size.height/2-newImage.size.height/2))
                 fromRect:NSZeroRect
                operation:NSCompositeSourceOver
                 fraction:1.0f];
    [channelImageBackground unlockFocus];

    
    
	return channelImageBackground;

//    return newImage;
}

@end

@implementation ChannelImageCollectionSelectorTransformer

+ (Class)transformedValueClass 
{
	return [NSImage class];
}

- (id)transformedValue:(id)value 
{
	if (value == nil) 
    {
//        NSImage *defaultImage = [NSImage imageNamed:@"DRLogoLarge"];
//		return defaultImage;
        return nil;
	}
    
    NSImage *newImage = nil;
    newImage = [[NSImage alloc] initWithContentsOfFile:[[[NSString channelIconDirectoryPath] stringByAppendingPathComponent:[value stringValue]] stringByAppendingPathExtension:@"tiff"]];
    
	return newImage;
}

@end

@implementation ProgramHasWebLinkTransformer

+ (Class)transformedValueClass {
	return [NSNumber class];
}

- (id)transformedValue:(id)value 
{
	BOOL isHidden = YES;

	if (value == nil) {
        return @(isHidden);
	}
	
    if ([value length] < 7)
        return @(isHidden);
    
	
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@", value];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    if (url && url.scheme && (url.host && ![url.host isEqualToString:@"(null)"]))
    {
        isHidden = NO;
    }
	
	return @(isHidden);
}

@end

@implementation ProgramIsRunningTransformer

+ (Class)transformedValueClass {
	return [NSImage class];
}

- (id)transformedValue:(id)value {
	if (value == nil) {
		return nil;
	}
    
    NSDate *startDate = [value valueForKey:@"ppu_start_timestamp_presentation"];
    NSDate *stopDate  = [value valueForKey:@"ppu_stop_timestamp_presentation"];
    NSDate *nowDate   = [NSDate date];
    
    if ((![startDate isEqual:[startDate laterDate:nowDate]]) && (![stopDate isEqual:[stopDate earlierDate:nowDate]]))
    {
        return [NSImage imageNamed:@"StatusRunning"];
    }
	
    return nil;
}

@end
