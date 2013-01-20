//
//  ICImageViewController.m
//  tapebooth
//
//  Created by Marcus Kida on 19.01.13.
//  Copyright (c) 2013 Marcus Kida [indiecoder.net]. All rights reserved.
//

typedef enum
{
    NameAlertView = 100
} AlertViewTags;

#import "ICImageViewController.h"

@interface ICImageViewController () <UIAlertViewDelegate>
{
    IBOutlet UIImageView *m_ImageView;
    IBOutlet UIActivityIndicatorView *m_ActivityIndicator;
    
    UIImage *m_pImage;
    NSString *m_stImageUrl;
    NSString *m_stTitle;
}
@end

@implementation ICImageViewController

@synthesize imageUrl = m_stImageUrl;
@synthesize headerTitle = m_stTitle;
@synthesize activityIndicator = m_ActivityIndicator;
@synthesize image = m_pImage;

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
    [self.navigationItem setRightBarButtonItem:[ICPrefs getNavigationBarShareItemWithTarget:self andAction:@selector(showShareActionSheet:)]];
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
    
    if(m_pImage)
    {
        [m_ImageView setImage:m_pImage];
        [m_ActivityIndicator setHidden:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Note"
                                                        message:@"Please name your photo:"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Upload", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alert.tag = NameAlertView;
        [alert show];
    }
    else
    {
        [ICApiRequestController getFileWithDocumentUrl:m_stImageUrl
                                           andProgress:^(long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                                                
                                                
                                        } andCompletion:^(UIImage *image) {
                                                
                                                [m_ActivityIndicator setHidden:YES];
                                                [m_ImageView setImage:image];
                                            }];
    }
}

#pragma mark - IBActions
- (IBAction) showShareActionSheet:(id)sender
{
    SHKItem *item = [SHKItem image:m_ImageView.image
                             title:
                     [NSString stringWithFormat:@"%@ #tapebooth", self.headerTitle]
                     ];
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    [SHK setRootViewController:self];
    [actionSheet showInView:self.view];
}

#pragma mark - AlertView Delegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == NameAlertView)
    {
        [ICApiRequestController postDocumentWithJpegData:UIImageJPEGRepresentation(m_ImageView.image, .8f)
                                             andFilename:[(UITextField *)[alertView textFieldAtIndex:0] text]
                                             andProgress:^(long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                                                 XLog(@"Sent %llu of %llu bytes", totalBytesWritten, totalBytesExpectedToWrite);
                                             } 
                                           andCompletion:^(BOOL success) {
                                               XLog(@"Success: %@", success?@"YES":@"NO");
                                           }];
    }
}

@end
