//
//  ICWebViewViewController.m
//  tapebooth
//
//  Created by Marcus Kida on 18.01.13.
//  Copyright (c) 2013 Marcus Kida [marcuskida.de]. All rights reserved.
//

#import "ICAuthViewViewController.h"

@interface ICAuthViewViewController () <UIWebViewDelegate>
{
    IBOutlet UIWebView *m_WebView;
}
@end

@implementation ICAuthViewViewController

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
    
    [self.navigationItem setTitleView:[ICPrefs getNavigationBarLabelWithText:@"Login"]];
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

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSURL *url = [NSURL URLWithString:
                   [NSString stringWithFormat:@"https://my.doctape.com/oauth2?client_id=%@&response_type=token&redirect_uri=%@&scope=%@&state=",
                    [kOAuthAppId urlEncodeUsingEncoding:NSUTF8StringEncoding],
                    [kOAuthRedirectUrl urlEncodeUsingEncoding:NSUTF8StringEncoding],
                    [@"account docs upload" urlEncodeUsingEncoding:NSUTF8StringEncoding]
                    ]
                  ];
    //XLog(@"GETTING: %@", url.description);
    [m_WebView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if([html rangeOfString:@"Success code="].location != NSNotFound)
    {
        NSString *stToken = [html stringByReplacingOccurrencesOfString:@"Success code=" withString:@""];
        [ICPrefs setAccessToken:stToken];
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    XLog(@"");
    [self.navigationController popViewControllerAnimated:YES];
}

@end
