//
//  DRPChannelUpdateOperation.m
//  DR Player
//
//  Created by Richard Nees on 06/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DRPAppDelegate.h"
#import "DRPListingsUpdateOperation.h"

@implementation DRPListingsUpdateOperation

// NSNotification name to tell the Window controller an image file as found

// -------------------------------------------------------------------------------
//	initWithItem:item
// -------------------------------------------------------------------------------
-(id)init
{
	self = [super init];
    
    
    return self;
}

// -------------------------------------------------------------------------------
//	dealloc:
// -------------------------------------------------------------------------------
- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] postNotificationName:ListingUpdateOperationDidFinish object:self.listingsArray userInfo:nil];
}

// -------------------------------------------------------------------------------
//	main:
//
// -------------------------------------------------------------------------------
-(void)main
{
	@autoreleasepool {
        
        if (![self isCancelled])
        {
            NSMutableArray *channelArray = [[[NSApp delegate] channelsArrayController] content];
            
            self.listingsArray = [NSMutableArray arrayWithCapacity:[channelArray count]];
            
            for (DRPChannel *channel in channelArray)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:UpdateMenuProgressString
                                                                    object:nil
                                                                  userInfo:@{@"statusString": [NSString localizedStringWithFormat:@"Opdaterer %@…", channel.name]}];
                
                NSMutableDictionary *listingDict = [NSMutableDictionary dictionaryWithCapacity:2];
                
                [listingDict setValue:@(channel.tag) forKey:DRPChannelTagKey];
                
                if (channel.listingsType == DRPProgramListingsTypeXML)
                {
                    NSMutableArray *listingsArray = [NSMutableArray arrayWithCapacity:128];
                    
                    NSString *urlString = [NSString localizedStringWithFormat:DRPListingsXMLTypeURLFormatString, channel.identifier];
                    
                    
                    NSXMLDocument *xmlDoc = [[NSXMLDocument alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]
                                                                                 options:NSXMLDocumentTidyXML
                                                                                   error:nil];
                    if (nil != xmlDoc)
                    {
                        NSArray *programNodes = [xmlDoc nodesForXPath:@".//program" error:nil];
                        
                        for (NSXMLNode *node in programNodes)
                        {
                            NSMutableDictionary *newProgram = [NSMutableDictionary dictionaryWithCapacity:10];
                            
                            NSArray *pro_titleArray = [node nodesForXPath:@".//pro_title" error:nil];
                            if (nil != pro_titleArray || [pro_titleArray count] > 0)
                            {
                                NSString *pro_title = [pro_titleArray[0] stringValue];
                                newProgram[@"pro_title"] = pro_title;
                            }
                            NSArray *ppu_isliveArray = [node nodesForXPath:@".//ppu_islive" error:nil];
                            if (nil != ppu_isliveArray || [ppu_isliveArray count] > 0)
                            {
                                NSString *ppu_islive = [ppu_isliveArray[0] stringValue];
                                if ([ppu_islive isEqualToString:@"TRUE"])
                                {
                                    newProgram[@"ppu_islive"] = @YES;
                                }
                                else
                                {
                                    newProgram[@"ppu_islive"] = @NO;
                                }
                            }
                            NSArray *ppu_isrerunArray = [node nodesForXPath:@".//ppu_isrerun" error:nil];
                            if (nil != ppu_isrerunArray || [ppu_isrerunArray count] > 0)
                            {
                                NSString *ppu_isrerun = [ppu_isrerunArray[0] stringValue];
                                if ([ppu_isrerun isEqualToString:@"TRUE"])
                                {
                                    newProgram[@"ppu_isrerun"] = @YES;
                                }
                                else
                                {
                                    newProgram[@"ppu_isrerun"] = @NO;
                                }
                            }
                            NSArray *ppu_descriptionArray = [node nodesForXPath:@".//ppu_description" error:nil];
                            if (nil != ppu_descriptionArray || [ppu_descriptionArray count] > 0)
                            {
                                NSString *ppu_description = [ppu_descriptionArray[0] stringValue];
                                newProgram[@"ppu_description"] = ppu_description;
                            }
                            NSArray *ppu_punchlineArray = [node nodesForXPath:@".//ppu_punchline" error:nil];
                            if (nil != ppu_punchlineArray || [ppu_punchlineArray count] > 0)
                            {
                                NSString *ppu_punchline = [ppu_punchlineArray[0] stringValue];
                                newProgram[@"ppu_punchline"] = ppu_punchline;
                            }
                            NSArray *ppu_www_urlArray = [node nodesForXPath:@".//ppu_www_url" error:nil];
                            if (nil != ppu_www_urlArray || [ppu_www_urlArray count] > 0)
                            {
                                NSString *ppu_www_url = [ppu_www_urlArray[0] stringValue];
                                newProgram[@"ppu_www_url"] = ppu_www_url;
                            }
                            NSArray *prd_genre_codeArray = [node nodesForXPath:@".//prd_genre_code" error:nil];
                            if (nil != prd_genre_codeArray || [prd_genre_codeArray count] > 0)
                            {
                                NSString *prd_genre_code = [prd_genre_codeArray[0] stringValue];
                                newProgram[@"prd_genre_code"] = NSLocalizedStringFromTable(prd_genre_code, @"GenreCodes", @"");
                            }
                            NSArray *ppu_start_timestamp_announcedArray = [node nodesForXPath:@".//ppu_start_timestamp_announced" error:nil];
                            if (nil != ppu_start_timestamp_announcedArray || [ppu_start_timestamp_announcedArray count] > 0)
                            {
                                
                                NSString *startTimeAnnouncedString = [ppu_start_timestamp_announcedArray[0] stringValue];
                                newProgram[@"ppu_start_timestamp_announced"] = [NSDate dateFromDRDateString:startTimeAnnouncedString];
                                
                            }
                            NSArray *ppu_start_timestamp_presentationArray = [node nodesForXPath:@".//ppu_start_timestamp_presentation" error:nil];
                            if (nil != ppu_start_timestamp_presentationArray || [ppu_start_timestamp_presentationArray count] > 0)
                            {
                                NSString *unfilteredStartTimeString = [ppu_start_timestamp_presentationArray[0] stringValue];
                                NSRange myRange = NSMakeRange(0, unfilteredStartTimeString.length-4);
                                NSString *startTimeString = [unfilteredStartTimeString substringWithRange:myRange];
                                newProgram[@"ppu_start_timestamp_presentation"] = [NSDate dateFromDRDateString:startTimeString];
                            }
                            NSArray *ppu_stop_timestamp_presentationArray = [node nodesForXPath:@".//ppu_stop_timestamp_presentation" error:nil];
                            if (nil != ppu_stop_timestamp_presentationArray || [ppu_stop_timestamp_presentationArray count] > 0)
                            {
                                NSString *unfilteredStopTimeString = [ppu_stop_timestamp_presentationArray[0] stringValue];
                                NSRange myRange = NSMakeRange(0, unfilteredStopTimeString.length-4);
                                NSString *stopTimeString = [unfilteredStopTimeString substringWithRange:myRange];
                                newProgram[@"ppu_stop_timestamp_presentation"] = [NSDate dateFromDRDateString:stopTimeString];
                            }
                            
                            [listingsArray addObject:newProgram];
                        }
                    }
                    
                    xmlDoc = nil;
                    
                    [listingDict setValue:listingsArray forKey:DRPProgramListingItemsArray];
                    [self.listingsArray addObject:listingDict];
                    
                }
                else if (channel.listingsType == DRPProgramListingsTypeJSON)
                {
                    __block NSMutableArray *listingsArray = [NSMutableArray arrayWithCapacity:128];
                    
                    NSTimeInterval secondsPerDay = 24 * 60 * 60;
                    
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                    NSDate *splitDate;
                    NSDate *today;
                    NSDate *yesterday;
                    //                    NSDate *tomorrow;
                    splitDate = [NSDate dateWithNaturalLanguageString:@"5am, today"];
                    today = [NSDate date];
                    yesterday = [today dateByAddingTimeInterval:-secondsPerDay];
                    //                    tomorrow = [today dateByAddingTimeInterval:+secondsPerDay];
                    
                    NSString *firstDate;
                    //                    NSString *secondDate;
                    
                    if ([splitDate isEqual:[splitDate laterDate:today]])
                    {
                        firstDate = [dateFormatter stringFromDate:yesterday];
                        //                        secondDate = [dateFormatter stringFromDate:today];
                    }
                    else
                    {
                        firstDate = [dateFormatter stringFromDate:today];
                        //                        secondDate = [dateFormatter stringFromDate:tomorrow];
                    }
                    
                    NSString *urlString = [NSString localizedStringWithFormat:DRPListingsJSONTypeURLFormatString, channel.identifier];
                    
                    NSString *combinedFirstDateString = [urlString stringByAppendingString:firstDate];
                    //                    NSString *combinedSecondDateString = [urlString stringByAppendingString:secondDate];
                    
                    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:combinedFirstDateString]];
                    [request setHTTPMethod:@"GET"];
                    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
                    
                    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
                    
                    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
                    
                    NSURLSessionDataTask *dataTask
                    = [session dataTaskWithRequest:request
                                 completionHandler:
                       ^(NSData *data, NSURLResponse *response, NSError *error)
                       {
                           
                           // Handle errors
                           if (error)
                           {
                               NSLog(@"error getting listings for %@", channel.name);
                           }
                           
                           // Parse data
                           if (data)
                           {
                               
                               NSError *jsonError = nil;
                               NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                                                    JSONObjectWithData:data
                                                                    options:0
                                                                    error:&jsonError];
                               
                               if ([jsonResponse isKindOfClass:[NSArray class]])
                               {
                                   
                                   NSMutableArray *firstDateResultArray = (NSMutableArray *)jsonResponse;
                                   NSLog(@"firstDateResultArray : %@", firstDateResultArray);
                                   
                                   if (firstDateResultArray)
                                   {
                                       listingsArray = firstDateResultArray;
                                       [listingDict setValue:listingsArray forKey:DRPProgramListingItemsArray];
                                       [self.listingsArray addObject:listingDict];
                                       
                                   }
                               }
                           }
                           
                           
                           //                    NSString *jsonObjectFirstDateString = [NSString stringWithContentsOfURL:[NSURL URLWithString:combinedFirstDateString]
                           //                                                                                   encoding:NSUTF8StringEncoding
                           //                                                                                      error:nil];
                           //
                           //                    NSString *jsonObjectSecondDateString = [NSString stringWithContentsOfURL:[NSURL URLWithString:combinedSecondDateString]
                           //                                                                                    encoding:NSUTF8StringEncoding
                           //                                                                                       error:nil];
                           //
                           //
                           
                           
                           
                           
                           //                    NSMutableArray *firstDateResultArray = (NSMutableArray *)[[self.parser objectWithString:jsonObjectFirstDateString] valueForKey:@"result"];
                           //                    NSMutableArray *secondDateResultArray = (NSMutableArray *)[[self.parser objectWithString:jsonObjectSecondDateString] valueForKey:@"result"];
                           //
                           //
                           //                    NSMutableArray *output = [NSMutableArray arrayWithCapacity:[firstDateResultArray count]+[secondDateResultArray count]];
                           //
                           //                    for (NSMutableDictionary *program in firstDateResultArray)
                           //                    {
                           //                        [program setValue:[NSDate dateFromDRDateString:program[@"pg_start"]] forKey:@"ppu_start_timestamp_announced"];
                           //                        [program setValue:[NSDate dateFromDRDateString:program[@"pg_start"]] forKey:@"ppu_start_timestamp_presentation"];
                           //                        [program setValue:[NSDate dateFromDRDateString:program[@"pg_stop"]] forKey:@"ppu_stop_timestamp_presentation"];
                           //                        [output addObject:program];
                           //                    }
                           //
                           //                    for (NSMutableDictionary *program in secondDateResultArray)
                           //                    {
                           //                        [program setValue:[NSDate dateFromDRDateString:program[@"pg_start"]] forKey:@"ppu_start_timestamp_announced"];
                           //                        [program setValue:[NSDate dateFromDRDateString:program[@"pg_start"]] forKey:@"ppu_start_timestamp_presentation"];
                           //                        [program setValue:[NSDate dateFromDRDateString:program[@"pg_stop"]] forKey:@"ppu_stop_timestamp_presentation"];
                           //                        [output addObject:program];
                           //                    }
                           //                    listingsArray = output;
                           
                       }];
                    
                    [dataTask resume];
                    
                    
                }
                
            }
            
        }
        
    }
}

@end
