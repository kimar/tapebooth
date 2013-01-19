//
//  ICImageViewController.h
//  tapebooth
//
//  Created by Marcus Kida on 19.01.13.
//  Copyright (c) 2013 Marcus Kida [indiecoder.net]. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICImageViewController : UIViewController

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSString *headerTitle;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

@end
