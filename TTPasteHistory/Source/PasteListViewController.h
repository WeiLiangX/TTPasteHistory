//
//  PasteListViewController.h
//  DocumentDemo
//
//  Created by 涂飞 on 15/12/24.
//  Copyright © 2015年 tutu. All rights reserved.
//

@protocol PasteListViewControllerDelegate <NSObject>

- (void)onSelectedRowWithIndex:(NSInteger)index;

@end


@interface PasteListViewController : NSViewController

@property(nonatomic, copy) NSArray *arr;
@property(nonatomic, weak) id<PasteListViewControllerDelegate> delegate;

@end
