//
//  ICWebViewViewController.h
//  tapebooth
//
//  Created by Marcus Kida on 18.01.13.
//  Copyright (c) 2013 Marcus Kida [indiecoder.net]. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICWebViewViewController : UIViewController

@property (nonatomic, retain) NSURL *urlToLoad;
@property (nonatomic, assign) BOOL isAuthentication;

@end
