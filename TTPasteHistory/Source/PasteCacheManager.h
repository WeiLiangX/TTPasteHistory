//
//  PasteCacheManager.h
//  DocumentDemo
//
//  Created by 涂飞 on 15/12/25.
//  Copyright © 2015年 tutu. All rights reserved.
//

extern NSString * const kPasteHistoryKey;

@interface PasteCacheManager : NSObject

+ (instancetype)shareObj;
- (void)cacheObject:(id)obj WithKey:(NSString*)key;
- (void)getCacheObjectWithKey:(NSString*)key completion:(void (^)(NSObject<NSSecureCoding> *))completion;

@end
