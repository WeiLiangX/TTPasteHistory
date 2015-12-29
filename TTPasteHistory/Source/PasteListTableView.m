//
//  PasteListTableView.m
//  DocumentDemo
//
//  Created by 涂飞 on 15/12/28.
//  Copyright © 2015年 tutu. All rights reserved.
//

#import "PasteListTableView.h"
#import <Carbon/Carbon.h>

@interface PasteListTableView()
{
    NSInteger _selectedRow;
}

@end

@implementation PasteListTableView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

//不知道为什么这里 重载mouseUp，跑不到这里来。但是同样是NSControl
//NSButton 重载mouseUp时可以。
- (void)mouseDown:(NSEvent *)theEvent
{
//    NSPoint globalLocation = [theEvent locationInWindow];
//    NSPoint localLocation = [self convertPoint:globalLocation fromView:nil];
//    NSInteger clickedRow = [self rowAtPoint:localLocation];
//    
//    [super mouseDown:theEvent];
//    
//    if (clickedRow != -1) {
//        [self.pasteListTableDelegate tableViewSelectedWithIndex:clickedRow flag:SELECTED_BY_MOUSE];
//    }
    [super mouseDown:theEvent];
    
    if ([theEvent clickCount] > 1)
    {
        [self _selectedRowDone];
    }
}

- (void)keyDown:(NSEvent *)theEvent
{
    if ([theEvent keyCode] == kVK_UpArrow || [theEvent keyCode] == kVK_DownArrow)
    {
        NSInteger count = [self numberOfRows];
        if (count <= 0)
        {
            return;
        }
        NSInteger selectedIndex = self.selectedRow;
        if ([theEvent keyCode] == kVK_UpArrow)
        {
            selectedIndex = selectedIndex == -1 ?
                                    (count - 1) : (selectedIndex - 1);
        }
        else
        {
            selectedIndex = selectedIndex == -1 ? 0 : (selectedIndex + 1);
        }
        if (selectedIndex < 0)
        {
            selectedIndex = [self numberOfRows] - 1;
        }
        if (selectedIndex >= [self numberOfRows])
        {
            selectedIndex = 0;
        }
        
        [self selectRowIndexes:[NSIndexSet indexSetWithIndex:selectedIndex] byExtendingSelection:NO];
        
    }
    else if ([theEvent keyCode] == kVK_Return)
    {
        [self _selectedRowDone];
    }
    else
    {
        [super keyDown:theEvent];
    }
}

- (void)_selectedRowDone
{
    _selectedRow = self.selectedRow;
    NSLog(@"%s - %ld", __FUNCTION__, (long)_selectedRow);
    if (_selectedRow == -1 && _selectedRow >= [self numberOfRows])
    {
        return;
    }
    if (self.pasteListTableDelegate && [self.pasteListTableDelegate respondsToSelector:@selector(tableViewSelectedWithIndex:flag:)])
    {
        [self.pasteListTableDelegate tableViewSelectedWithIndex:_selectedRow flag:SELECTED_BY_KEY];
    }
}

@end
