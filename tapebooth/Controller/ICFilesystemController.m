//
//  ICFilesystemController.m
//  tapebooth
//
//  Created by Marcus Kida on 05.07.13.
//  Copyright (c) 2013 Marcus Kida [indiecoder.net]. All rights reserved.
//

#import "ICFilesystemController.h"

@interface ICFilesystemController ()
{
    NSFileManager *_fileManager;
    NSString *_cachePath;
}
@end

@implementation ICFilesystemController

+ (id) sharedInstance
{
    static ICFilesystemController *fscontroller = nil;
    if(!fscontroller)
    {
        fscontroller = [[ICFilesystemController alloc] init];
        [fscontroller initialize];
    }
    return fscontroller;
}

- (void) initialize
{
    _fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    BOOL isDir = NO;
    NSError *error;
    if (![_fileManager fileExistsAtPath:cachePath isDirectory:&isDir] && isDir == NO)
    {
        [_fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    _cachePath = cachePath;
}

- (BOOL) cachedFileExists:(NSString *)filename
{
    BOOL isDir = NO;
    if([_fileManager fileExistsAtPath:[_cachePath stringByAppendingPathComponent:filename] isDirectory:&isDir])
    {
        if(!isDir)
            return YES;
    }
    return NO;
}

- (BOOL) storeData:(NSData *)data forCachedFile:(NSString *)filename
{
    return [data writeToFile:[_cachePath stringByAppendingPathComponent:filename] atomically:YES];
}

- (NSData *) dataForCachedFile:(NSString *)filename
{
    return [NSData dataWithContentsOfFile:[_cachePath stringByAppendingPathComponent:filename]];
}

@end
