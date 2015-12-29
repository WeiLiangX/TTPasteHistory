//
//  PasteHistoryModel.m
//  DocumentDemo
//
//  Created by 涂飞 on 15/12/27.
//  Copyright © 2015年 tutu. All rights reserved.
//

#import "PasteHistoryModel.h"
#import <Quartz/Quartz.h>
#import <Carbon/Carbon.h>

#import "PasteCacheManager.h"

#define kMaxShowPasteHistoryCount 10

@interface PasteHistoryModel()
{
    id _monitor;
}

@property(nonatomic, strong) NSMutableArray<NSString*> *items;

@end

@implementation PasteHistoryModel

+ (instancetype)shareObj
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        __weak __typeof(self) weakSelf = self;
        [[PasteCacheManager shareObj] getCacheObjectWithKey:kPasteHistoryKey completion:^(NSObject<NSSecureCoding> *obj) {
            if (obj && [obj isKindOfClass:[NSMutableArray class]])
            {
                weakSelf.items = (NSMutableArray*)obj;
            }
            else
            {
                weakSelf.items = [NSMutableArray array];
            }
        }];
//        _items = [NSMutableArray array];
//        [self updateItems];
        __weak __typeof(self) weakself = self;
        _monitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:^NSEvent * _Nullable(NSEvent * _Nonnull event){
            if ([event keyCode] == kVK_ANSI_V
                && ([event modifierFlags] & NSCommandKeyMask)
                && !([event modifierFlags] & NSShiftKeyMask))
            {
                [weakself updateItems];
            }
            return event;
        }];
    }
    return self;
}

- (void)dealloc
{
    if (_monitor)
    {
        [NSEvent removeMonitor:_monitor];
    }
}

- (void)updateItems
{
//    NSLog(@"%s", __FUNCTION__);
    
    NSRegularExpression *re = [[NSRegularExpression alloc] initWithPattern:@"[ |\n|\t]+" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    NSArray *classArrays = [NSArray arrayWithObject:[NSString class]];
    NSDictionary *dict = [NSDictionary dictionary];
    
    BOOL ok = [pasteboard canReadObjectForClasses:classArrays options:dict];
    if (ok)
    {
        NSArray *objects = [pasteboard readObjectsForClasses:classArrays options:dict];
        [objects enumerateObjectsUsingBlock:^(id  _Nonnull objOutter, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([objOutter isKindOfClass:[NSString class]])
            {
                NSString *str1 = (NSString*)objOutter;
                
                NSTextCheckingResult *result = [re firstMatchInString:str1 options:0 range:NSMakeRange(0, str1.length)];
                if (result.range.location == 0)
                {
                    str1 = [str1 stringByReplacingCharactersInRange:result.range withString:@""];
                }
                
                    NSUInteger index = [self.items indexOfObjectPassingTest:^BOOL(id  _Nonnull objInner, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSString *str2 = (NSString*)objInner;
                        
                        if (str1 && str2 && ![str1 isEqualToString:@""] && [str1 isEqualToString:str2])
                        {
                            return YES;
                        }
                        
                        return NO;
                    }];
                    if (index == NSNotFound)
                    {
                        [self.items insertObject:str1 atIndex:0];
                        if (self.items.count > kMaxShowPasteHistoryCount)
                        {
                            [self.items removeObjectAtIndex:(self.items.count - 1)];
                        }
                        [[PasteCacheManager shareObj] cacheObject:self.items WithKey:kPasteHistoryKey];
                    }
                }
            
        }];
    }

}

- (void)updateItemsWithSelectedIndex:(NSInteger)index
{
    if (self.items.count <= 1)
    {
        return;
    }
    if (index >=0 && index < self.items.count)
    {
        id obj1 = self.items[index];
        id obj2 = self.items[0];
        
        self.items[0] = obj1;
        self.items[index] = obj2;
    }
    [[PasteCacheManager shareObj] cacheObject:self.items WithKey:kPasteHistoryKey];
}

- (NSArray*)itemArr
{
    return [self.items copy];
}

@end
