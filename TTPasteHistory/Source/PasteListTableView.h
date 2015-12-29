//
//  PasteListTableView.h
//  DocumentDemo
//
//  Created by 涂飞 on 15/12/28.
//  Copyright © 2015年 tutu. All rights reserved.
//

typedef NS_ENUM(NSUInteger, SelectedFlag)
{
    SELECTED_BY_KEY,    //upArrow || downArrow
    SELECTED_BY_MOUSE
};

@protocol PasteListTableViewDelegate <NSObject>

- (void)tableViewSelectedWithIndex:(NSInteger)index flag:(SelectedFlag)flag;

@end

@interface PasteListTableView : NSTableView

@property(nonatomic, weak) id<PasteListTableViewDelegate> pasteListTableDelegate;

@end
