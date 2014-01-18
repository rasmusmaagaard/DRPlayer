//
//  DRPValueTransformers.h
//  DR Player
//
//  Created by Richard Nees on 02/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRPValueTransformersController               : NSObject
+ (void)setupValueTransformers;
@end

@interface FormattedChannelIdTransformer                : NSValueTransformer @end
@interface FormattedProductionCodeTransformer           : NSValueTransformer @end
@interface FormattedProgramPresentationTransformer      : NSValueTransformer @end
@interface FormattedProgramTimeTransformer              : NSValueTransformer @end
@interface FormattedProgramTitleTransformer             : NSValueTransformer @end
@interface FormattedProgramDescriptionTransformer       : NSValueTransformer @end
@interface FormattedProgramItemsSmallLeftTransformer    : NSValueTransformer @end
@interface FormattedProgramItemsSmallCenterTransformer  : NSValueTransformer @end
@interface ChannelImageSelectorTransformer              : NSValueTransformer @end
@interface ChannelImageCollectionSelectorTransformer    : NSValueTransformer @end
@interface ProgramHasWebLinkTransformer                 : NSValueTransformer @end
@interface ProgramIsRunningTransformer                  : NSValueTransformer @end