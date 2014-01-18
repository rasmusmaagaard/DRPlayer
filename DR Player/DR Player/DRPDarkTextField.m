//
//  DRPDarkTextField.m
//  DR Player
//
//  Created by Richard on 04/01/14.
//
//

#import "DRPDarkTextField.h"

@implementation DRPDarkTextField

- (NSAttributedString *)makeAttributedStringFrom:(NSString *)title
{
	NSMutableAttributedString *attrStatusString = [[NSMutableAttributedString alloc] initWithString:title];
	NSRange range = NSMakeRange(0, [attrStatusString length]);
	[attrStatusString addAttributes:[NSAttributedString standardTextStyleAttributesForFontSize:[[self font] pointSize] textAlignment:[[self cell] alignment]] range:range];
	return attrStatusString;
	
}

- (void)viewWillDraw
{
    [[self cell] setBackgroundStyle:(NSBackgroundStyleLight|NSBackgroundStyleRaised)];
    [[self cell] setAttributedStringValue:[self makeAttributedStringFrom:[self stringValue]]];
}

@end
