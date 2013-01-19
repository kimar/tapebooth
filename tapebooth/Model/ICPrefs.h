//
//  ICPrefs.h
//  tapebooth
//
//  Created by Marcus Kida on 19.01.13.
//  Copyright (c) 2013 Marcus Kida [indiecoder.net]. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICPrefs : NSObject

#pragma mark - Access Token
+ (void) setAccessToken:(NSString *)accessToken;
+ (NSString *) getAccessToken;
+ (BOOL) hasAccessToken;

#pragma mark - Navigation Bar
+ (UILabel *) getNavigationBarLabelWithText:(NSString *)text;
+ (UIBarButtonItem *) getNavigationBarBackItemWithTarget:(id)target andAction:(SEL)action;
+ (UIBarButtonItem *) getNavigationBarSettingsItemWithTarget:(id)target andAction:(SEL)action;
+ (UIBarButtonItem *) getNavigationBarShareItemWithTarget:(id)target andAction:(SEL)action;

#pragma mark - Media
+ (NSString *) getThumbnailUrlForDocument:(NSString *)document;
+ (NSString *) getOriginalUrlForDocument:(NSString *)document;

@end
