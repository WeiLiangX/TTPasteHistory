//
//  PasteCacheManager.m
//  DocumentDemo
//
//  Created by 涂飞 on 15/12/25.
//  Copyright © 2015年 tutu. All rights reserved.
//

#import "PasteCacheManager.h"
#import <AppKit/NSApplication.h>

NSString * const kPasteHistoryKey = @"kPasteHistoryKey";

@interface PasteCacheManager()

@property(nonatomic, strong) NSCache *memoryCache;
@property(nonatomic, strong) NSFileManager *fileManager;
@property(nonatomic, strong) dispatch_queue_t ioQueue;
@property(nonatomic, strong) NSString *cacheFilePath;

@end

@implementation PasteCacheManager

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
        _memoryCache = [[NSCache alloc] init];
        
        _ioQueue = dispatch_queue_create("com.tt.paste", DISPATCH_QUEUE_SERIAL);
        NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _cacheFilePath = [pathArr[0] stringByAppendingPathComponent:@"com.tt.paste"];
        
        dispatch_async(_ioQueue, ^{
            _fileManager = [[NSFileManager alloc] init];
            [[NSFileManager defaultManager] createDirectoryAtPath:_cacheFilePath withIntermediateDirectories:YES attributes:nil error:nil];
        });
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillExit:) name:NSApplicationWillTerminateNotification object:nil];
    }
    return self;
}

- (void)cacheObject:(id)obj WithKey:(NSString*)key
{
    [_memoryCache setObject:obj forKey:key];
    
    NSData *cacheData = [NSKeyedArchiver archivedDataWithRootObject:obj];
    dispatch_async(self.ioQueue, ^{
        NSString *cachePath = [self _cachePathWithKey:key];
        [_fileManager createFileAtPath:cachePath contents:cacheData attributes:nil];
    });
}

- (void)getCacheObjectWithKey:(NSString *)key completion:(void (^)(NSObject<NSSecureCoding> *))completion
{
    id obj = [_memoryCache objectForKey:key];
    if (obj)
    {
        completion(obj);
        return;
    }
    dispatch_async(self.ioQueue, ^{
        NSString *cachePath = [self _cachePathWithKey:key];
        NSData *data = [_fileManager contentsAtPath:cachePath];
        if (data)
        {
            completion([NSKeyedUnarchiver unarchiveObjectWithData:data]);
        }
        else
        {
            completion(nil);
        }
    });
}

- (void)applicationWillExit:(NSNotification*)notification
{
    
}

- (NSString*)_cachePathWithKey:(NSString*)key
{
    return [_cacheFilePath stringByAppendingPathComponent:key];
}


@end
