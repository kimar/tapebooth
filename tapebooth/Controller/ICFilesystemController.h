//
//  ICFilesystemController.h
//  tapebooth
//
//  Created by Marcus Kida on 05.07.13.
//  Copyright (c) 2013 Marcus Kida [indiecoder.net]. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICFilesystemController : NSObject

+ (id) sharedInstance;

- (BOOL) cachedFileExists:(NSString *)filename;
- (BOOL) storeData:(NSData *)data forCachedFile:(NSString *)filename;
- (NSData *) dataForCachedFile:(NSString *)filename;

@end
