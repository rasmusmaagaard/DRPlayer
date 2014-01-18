//
//  SURecessedTextField.m
//  Skype Utility
//
//  Created by Richard Nees on 12/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DRPTextField.h"

@implementation DRPTextField

- (NSAttributedString *)makeAttributedStringFrom:(NSString *)title 
{
	NSMutableAttributedString *attrStatusString = [[NSMutableAttributedString alloc] initWithString:title];
	NSRange range = NSMakeRange(0, [attrStatusString length]);
	[attrStatusString addAttributes:[NSAttributedString standardLightTextStyleAttributesForFontSize:[[self font] pointSize] textAlignment:[[self cell] alignment]] range:range];
	return attrStatusString;
	
}

- (void)viewWillDraw
{
    [[self cell] setBackgroundStyle:(NSBackgroundStyleDark|NSBackgroundStyleRaised)];
    [[self cell] setAttributedStringValue:[self makeAttributedStringFrom:[self stringValue]]];
}

@end
