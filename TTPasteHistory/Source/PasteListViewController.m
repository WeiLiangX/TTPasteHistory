//
//  PasteListViewController.m
//  DocumentDemo
//
//  Created by 涂飞 on 15/12/24.
//  Copyright © 2015年 tutu. All rights reserved.
//

#import "PasteListViewController.h"
#import <Quartz/Quartz.h>
#import "PasteListTableView.h"

@interface PasteListViewController ()<NSTableViewDataSource, NSTableViewDelegate, PasteListTableViewDelegate>

@property(nonatomic, weak) IBOutlet PasteListTableView *tableView;

@end

@implementation PasteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.tableView.delegate = self;
    self.tableView.pasteListTableDelegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.headerView = nil;
//    self.tableView.backgroundColor = [NSColor greenColor];
//    self.tableView.layer.cornerRadius = 3.0;
}

- (void)viewWillAppear
{
//    [self.tableView reloadData];
}

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if (self.arr)
    {
        return self.arr.count;
    }
    return 0;
}

//- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row;
//{
//    
//    NSTextField *textField = [[NSTextField alloc] initWithFrame:NSRectFromString(@"0,0,200,20")];
//    textField.stringValue = @"yoyo check now";
//    textField.placeholderString = @"wahah";
//    return textField;
//}

- (NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView *cellview = [tableView makeViewWithIdentifier:@"TextCellID" owner:nil];
    NSString *str = self.arr[row];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@"\t\t"];
    cellview.textField.stringValue = str;
    return cellview;
}


#pragma mark - NSTableViewDelegate
//- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
//{
//    return 30;
//}

//- (void)tableViewSelectionDidChange:(NSNotification *)notification
//{
//    
//}

- (BOOL)tableView:(NSTableView *)tableView shouldTrackCell:(NSCell *)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return YES;
}

#pragma mark - PasteListTableViewDelegate
- (void)tableViewSelectedWithIndex:(NSInteger)selectedRow flag:(SelectedFlag)flag
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSelectedRowWithIndex:)])
    {
        [self.delegate onSelectedRowWithIndex:selectedRow];
    }
    [self.tableView deselectRow:selectedRow];
}


@end
