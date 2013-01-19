//
//  ICImageViewController.m
//  tapebooth
//
//  Created by Marcus Kida on 19.01.13.
//  Copyright (c) 2013 Marcus Kida [indiecoder.net]. All rights reserved.
//

#import "ICImageViewController.h"

@interface ICImageViewController ()
{
    IBOutlet UIImageView *m_ImageView;
    IBOutlet UIActivityIndicatorView *m_ActivityIndicator;
    
    NSString *m_stImageUrl;
    NSString *m_stTitle;
}
@end

@implementation ICImageViewController

@synthesize imageUrl = m_stImageUrl;
@synthesize headerTitle = m_stTitle;
@synthesize activityIndicator = m_ActivityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.navigationItem setTitleView:[ICPrefs getNavigationBarLabelWithText:m_stTitle]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"TopBar.png"]
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem setLeftBarButtonItem:[ICPrefs getNavigationBarBackItemWithTarget:self andAction:@selector(popBack:)]];
}

- (void) popBack: (id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    __weak ICImageViewController *controller = self;
    [m_ImageView setImageWithURL:[NSURL URLWithString:m_stImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if(!error)
        {
            [controller.activityIndicator setHidden:YES];
        }
        else
        {
            // Needs warning to inform user that something went wrong
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
