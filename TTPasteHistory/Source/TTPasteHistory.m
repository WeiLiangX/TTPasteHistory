//
//  TTPasteHistory.m
//  TTPasteHistory
//
//  Created by 涂飞 on 15/12/29.
//  Copyright © 2015年 tutu. All rights reserved.
//

#import "TTPasteHistory.h"
#import <Carbon/Carbon.h>

#import "SFBPopovers/SFBPopover.h"
#import "PasteListViewController.h"
#import "PasteCacheManager.h"
#import "VVKeyboardEventSender.h"
#import "PasteHistoryModel.h"

#define POPOVER_WIDTH 300
#define POPOVER_HEIGHT 188


@interface TTPasteHistory()<PasteListViewControllerDelegate>
{
    id _monitor;
    __block id _notifObj;
}

@property (nonatomic, strong) SFBPopover *popOver;
@property (nonatomic, strong) NSString *bundlePath;
@property (nonatomic, assign) BOOL bSourceTextInput;    //焦点是否在代码编辑区

@end


@implementation TTPasteHistory

+ (instancetype)shareWithBundlePath:(NSString *)bundlePath
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithBundlePath:bundlePath];
    });
    return instance;
}

- (instancetype)initWithBundlePath:(NSString*)bundlePath {
    self = [super init];
    self.bundlePath = bundlePath;
    self.bSourceTextInput = false;
    
    [PasteCacheManager shareObj];
    [PasteHistoryModel shareObj];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationDidLaunchingFinished:) name:NSApplicationDidFinishLaunchingNotification object:nil];
    
    return self;
}

- (void)onApplicationDidLaunchingFinished:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextViewSelectionDidChangeNotif:) name:@"NSTextViewDidChangeSelectionNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextViewDidEndNotif:) name:NSTextDidEndEditingNotification object:nil];
    
    
    __weak __typeof(self) weakself = self;
    _monitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:^NSEvent * _Nullable(NSEvent * _Nonnull event) {
        
        // if NSEvent is Command + Shift + V
        if ([event type] == NSKeyDown && [event keyCode] == kVK_ANSI_V
            && ([event modifierFlags] & NSCommandKeyMask) && ([event modifierFlags] & NSShiftKeyMask))
        {
            [[PasteHistoryModel shareObj] updateItems];
            
            if (_notifObj && [_notifObj isKindOfClass:NSClassFromString(@"DVTSourceTextView")])
            {
                DVTSourceTextView *sourceTextView = (DVTSourceTextView*)_notifObj;
                if (weakself.bSourceTextInput)
                {
                    [weakself _showPopOverWithTextView:sourceTextView];
                }
            }
        }
        
        if ([event type] == NSKeyDown && [event keyCode] == kVK_Escape)
        {
            [weakself _hidePopOver];
        }
        return event;
    }];

}

- (void)onTextViewSelectionDidChangeNotif:(NSNotification*)notification
{
    id obj = notification.object;
    // let we know current edit in sourceEdit
    if (obj && [obj isKindOfClass:NSClassFromString(@"DVTSourceTextView")])
    {
        _notifObj = obj;
        self.bSourceTextInput = YES;
    }
//    if (obj && [obj isKindOfClass:NSClassFromString(@"DVTSourceTextView")])
//    {
//        DVTSourceTextView *sourceTextView = (DVTSourceTextView*)obj;
//        _textView = sourceTextView;
//    }
//    else
//    {
//        _textView
//    }
}

- (void)onTextViewDidEndNotif:(NSNotification*)notification
{
    id obj = notification.object;
    if (obj && [obj isKindOfClass:NSClassFromString(@"DVTSourceTextView")])
    {
        self.bSourceTextInput = NO;
    }
}


- (void)_showPopOverWithTextView:(NSTextView*)textView
{
    if (textView == nil)
    {
        return;
    }
    
    NSRange range = [[textView selectedRanges] objectAtIndex:0].rangeValue;
    
    NSRect selectedRectOnScreen = [textView firstRectForCharacterRange:range actualRange:NULL];
    NSRect selectedRectInWindow = [textView.window convertRectFromScreen:selectedRectOnScreen];
    //    NSRect selectedRectInView = [self.textView convertRect:selectedRectInWindow fromView:nil];
    
    
    if (!self.popOver)
    {
        PasteListViewController *plvc = [[PasteListViewController alloc] initWithNibName:@"PasteListViewController" bundle:[NSBundle bundleWithPath:self.bundlePath]];
        plvc.arr = [PasteHistoryModel shareObj].itemArr;
        plvc.delegate = self;
        
        self.popOver = [[SFBPopover alloc] initWithContentViewController:plvc];
        [self.popOver setDrawsArrow:NO];
        [self.popOver setArrowHeight:0.01];
        [self.popOver setViewMargin:0.01];
        self.popOver.closesWhenApplicationBecomesInactive = YES;
        self.popOver.closesWhenPopoverResignsKey = YES;
        self.popOver.animates = NO;
    }
    
    [self.popOver displayPopoverInWindow:textView.window atPoint:selectedRectInWindow.origin chooseBestLocation:YES];
    
}

- (void)dealloc
{
    if (_monitor)
    {
        [NSEvent removeMonitor:_monitor];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)_hidePopOver
{
    if (self.popOver)
    {
        [self.popOver closePopover:nil];
        self.popOver = nil;
    }
}

- (void)onSelectedRowWithIndex:(NSInteger)index
{
    NSUInteger count = [PasteHistoryModel shareObj].itemArr.count;
    if (count <= 0
        || index >= count
        || index < 0)
    {
        return;
    }
    NSString *str = [PasteHistoryModel shareObj].itemArr[index];
    
    [[PasteHistoryModel shareObj] updateItemsWithSelectedIndex:index];
    [self _hidePopOver];
    
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard declareTypes:@[NSStringPboardType] owner:nil];
    [pasteboard setString:str forType:NSStringPboardType];
    
    VVKeyboardEventSender *eventSender = [[VVKeyboardEventSender alloc] init];
    [eventSender beginKeyBoradEvents];
    [eventSender sendKeyCode:kVK_ANSI_V withModifier:NSCommandKeyMask];
    
    [eventSender endKeyBoradEvents];
}


@end
