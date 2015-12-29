//
//  PasteListView.m
//  DocumentDemo
//
//  Created by 涂飞 on 15/12/28.
//  Copyright © 2015年 tutu. All rights reserved.
//

#import "PasteListView.h"

@interface PasteListBackgroundView : NSView

@end

@implementation PasteListBackgroundView

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor whiteColor] set];
    NSRectFill(self.bounds);
}

@end

@implementation PasteListView

- (void)viewDidMoveToWindow
{
    NSView *aFrameView = [[self.window contentView] superview];
    PasteListBackgroundView *backgroundView = [[PasteListBackgroundView alloc] initWithFrame:aFrameView.bounds];
    aFrameView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [aFrameView addSubview:backgroundView positioned:NSWindowBelow relativeTo:aFrameView];
    [super viewDidMoveToWindow];
}

//- (void)drawRect:(NSRect)dirtyRect {
//    [super drawRect:dirtyRect];
//    
//    // Drawing code here.
//}

@end
