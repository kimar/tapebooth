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

+ (UILabel *) getNavigationBarLabelWithText:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:20.0f];
    //label.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.text = text;
    [label sizeToFit];
    return label;
}

+ (UIBarButtonItem *) getNavigationBarBackItemWithTarget:(id)target andAction:(SEL)action
{
    UIImage *buttonImage = [UIImage imageNamed:@"BackBarButton.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 61, 30);
    [button setImage:buttonImage
            forState:UIControlStateNormal];
    [button addTarget:target
               action:action
     forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButtonItem;
}

+ (UIBarButtonItem *) getNavigationBarSettingsItemWithTarget:(id)target andAction:(SEL)action
{
    UIImage *buttonImage = [UIImage imageNamed:@"SettingsBarButton.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 35, 30);
    [button setImage:buttonImage
            forState:UIControlStateNormal];
    [button addTarget:target
               action:action
     forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButtonItem;
}

+ (UIBarButtonItem *) getNavigationBarShareItemWithTarget:(id)target andAction:(SEL)action;
{
    UIImage *buttonImage = [UIImage imageNamed:@"ShareButton.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 35, 30);
    [button setImage:buttonImage
            forState:UIControlStateNormal];
    [button addTarget:target
               action:action
     forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButtonItem;
}

+ (UIBarButtonItem *) getNavigationBarMenuItemWithTarget:(id)target andAction:(SEL)action
{
    UIImage *buttonImage = [UIImage imageNamed:@"MenuButton.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 35, 30);
    [button setImage:buttonImage
            forState:UIControlStateNormal];
    [button addTarget:target
               action:action
     forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButtonItem;
}

+ (NSString *) getThumbnailUrlForDocument:(NSString *)document
{
    return [NSString stringWithFormat:@"https://api.doctape.com/v1/doc/%@/thumb_320.jpg", document];
}

+ (NSString *) getOriginalUrlForDocument:(NSString *)document
{
    return [NSString stringWithFormat:@"https://api.doctape.com/v1/doc/%@/original", document];
}

@end
