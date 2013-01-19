//
//  ICPrefs.m
//  tapebooth
//
//  Created by Marcus Kida on 19.01.13.
//  Copyright (c) 2013 Marcus Kida [indiecoder.net]. All rights reserved.
//

#import "ICPrefs.h"

@implementation ICPrefs

+ (void) setAccessToken:(NSString *)accessToken
{
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:kAuthTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *) getAccessToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kAuthTokenKey];
}

+ (BOOL) hasAccessToken
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kAuthTokenKey] length] > 0?YES:NO;
}

@end
