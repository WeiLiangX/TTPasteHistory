//
//  IDEKit.h
//  TTPasteHistory
//
//  Created by 涂飞 on 15/12/29.
//  Copyright © 2015年 tutu. All rights reserved.
//

#ifndef IDEKIT_H
#define IDEKIT_H
#import <AppKit/AppKit.h>


#import <Cocoa/Cocoa.h>

@class DVTTextCompletionDataSource;

@interface DVTCompletingTextView : NSTextView

@property (readonly) DVTTextCompletionDataSource *completionsDataSource;

- (BOOL)shouldAutoCompleteAtLocation:(unsigned long long)arg1;

@end


@interface DVTSourceTextView : DVTCompletingTextView

@end


#endif /* IDEKIT_H */
