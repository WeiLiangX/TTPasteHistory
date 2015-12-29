//
//  PasteHistoryModel.h
//  DocumentDemo
//
//  Created by 涂飞 on 15/12/27.
//  Copyright © 2015年 tutu. All rights reserved.
//

@interface PasteHistoryModel : NSObject

+ (instancetype)shareObj;

- (void)updateItems;

- (void)updateItemsWithSelectedIndex:(NSInteger)index;

- (NSArray*)itemArr;

@end
