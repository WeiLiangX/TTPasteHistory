//
//  NSObject+extension.m
//  TTPasteHistory
//
//  Created by 涂飞 on 15/12/29.
//  Copyright © 2015年 tutu. All rights reserved.
//

#import "NSObject+extension.h"
#import "TTPasteHistory.h"

@implementation NSObject (extension)

+ (void)pluginDidLoad:(NSBundle*)bundle
{
    NSLog(@"TTPasteHistory load. path = %@", bundle.bundlePath);
    [TTPasteHistory shareWithBundlePath:bundle.bundlePath];
}


@end
