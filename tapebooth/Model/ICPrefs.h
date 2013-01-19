//
//  ICPrefs.h
//  tapebooth
//
//  Created by Marcus Kida on 19.01.13.
//  Copyright (c) 2013 Marcus Kida [indiecoder.net]. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICPrefs : NSObject

+ (void) setAccessToken:(NSString *)accessToken;
+ (NSString *) getAccessToken;
+ (BOOL) hasAccessToken;

@end
