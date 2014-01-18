//
//  DRPScrollView.m
//  DR Player
//
//  Created by Richard Nees on 24/02/10.
//  Copyright 2010 Section Urbaine Software. All rights reserved.
//

#import "DRPAppDelegate.h"
#import "DRPListingsTableView.h"
#import "DRPStatusViewController.h"

@implementation DRPListingsTableView

- (void)showProgramDescription:sender
{
    [[[NSApp delegate] statusViewController] performShowProgramDescription:sender];
    [[[NSApp delegate] panelViewController] performShowProgramDescription:sender];
}

- (void)awakeFromNib
{
    [self setDelegate:self];
    [self setDoubleAction:@selector(showProgramDescription:)];
    [self setTarget:self];
}

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex
{
	return YES;
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
	[self noteHeightOfRowsWithIndexesChanged:[NSIndexSet  
											  indexSetWithIndexesInRange:NSMakeRange(0,
																					 [@([self numberOfRows]) unsignedIntValue] 
																					 )]];
//	if ([self action] && [self target])
//		[[self target] performSelector:[self action]];
	
}

- (void)tableViewSelectionIsChanging:(NSNotification *)aNotification
{
	[self noteHeightOfRowsWithIndexesChanged:[NSIndexSet  
											  indexSetWithIndexesInRange:NSMakeRange(0,
																					 [@([self numberOfRows]) unsignedIntValue] 
																					 )]];
	[self setNeedsDisplay:YES];
}

- (BOOL)isOpaque {
	
    return NO;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    if ([[self selectedRowIndexes] containsIndex:row])
	{
		return 42.0f;
	}
	else
	{
		return 17.0f;
	}
}

- (void)highlightSelectionInClipRect:(NSRect)clipRect
{
    NSColor *bgColor = [NSColor colorWithDeviceWhite:0.666f alpha:0.2f];
    
    float rowHeight = [self rowHeight] + [self intercellSpacing].height;
    NSRect visibleRect = [self visibleRect];
    NSRect highlightRect;
    
    highlightRect.origin = NSMakePoint(
                                       NSMinX(visibleRect),
                                       (int)(NSMinY(clipRect)/rowHeight)*rowHeight);
    highlightRect.size = NSMakeSize(
                                    NSWidth(visibleRect),
                                    rowHeight - [self intercellSpacing].height);
    
    if (NSMinY(highlightRect) < NSMaxY(clipRect))
    {
        [bgColor set];
        NSRectFillUsingOperation([self rectOfRow:[self selectedRow]], NSCompositeSourceOver);
    }
    
    [super highlightSelectionInClipRect: clipRect];
}


- (void)drawBackgroundInClipRect:(NSRect)clipRect
{
	
}

- (id)_highlightColorForCell:(NSCell *)cell
{
	return nil;
}

- (BOOL)acceptsFirstResponder
{
	return NO;
}

- (void)scrollToActive
{
    for (NSMutableDictionary *program in [self.arrayController arrangedObjects])
    {
        NSDate *startDate = program[@"ppu_start_timestamp_presentation"];
        NSDate *stopDate  = program[@"ppu_stop_timestamp_presentation"];
        NSDate *nowDate   = [NSDate date];
        
        if ((![startDate isEqual:[startDate laterDate:nowDate]]) && (![stopDate isEqual:[stopDate earlierDate:nowDate]]))
        {
            //[self.arrayController setSelectedObjects:[NSArray arrayWithObject:program]];
            [self scrollRowToVisible:[self.arrayController.arrangedObjects indexOfObjectIdenticalTo:program]];
            break;
        }
    }
}


@end
