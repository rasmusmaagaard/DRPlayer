//
//  DRPCheckBox.m
//  DR Player
//
//  Created by Richard Nees on 08/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DRPCheckBox.h"

@implementation DRPCheckBox

- (void)awakeFromNib
{
	[[self cell] setAttributedTitle:[self makeAttributedStringFrom:[self title]]];
    [[self cell] setBackgroundStyle:(NSBackgroundStyleLight|NSBackgroundStyleRaised)];
}


- (NSAttributedString *)makeAttributedStringFrom:(NSString *)title 
{
	NSMutableAttributedString *attrStatusString = [[NSMutableAttributedString alloc] initWithString:title];
	NSRange range = NSMakeRange(0, [attrStatusString length]);
	[attrStatusString addAttributes:[NSAttributedString standardTextStyleAttributesForFontSize:[[self font] pointSize] textAlignment:NSLeftTextAlignment] range:range];
	return attrStatusString;
	
}

@end
