//
//  ICDefinitions.h
//  tapebooth
//
//  Created by Marcus Kida on 18.01.13.
//  Copyright (c) 2013 Marcus Kida [marcuskida.de]. All rights reserved.
//

// OAuth
#define kOAuthAppId                 @"109189f2-f204-4bde-8278-12b0d283f223"
#define kOAuthApiAuthUrl            @"https://api.doctape.com/oauth2"
#define kOAuthRedirectUrl           @"urn:ietf:wg:oauth:2.0:oob"
#define kOAuthScopes                @"account.read file.create file.read file.update file.delete tape.read tape.update"

// TestFlight
#define kTestFlightAppToken         @""

// UserDefaults Keys
#define kAuthTokenKey               @"authToken"

// Commonly Used
#define kScreenWidth                [UIScreen mainScreen].bounds.size.width
#define kScreenHeight               [UIScreen mainScreen].bounds.size.height