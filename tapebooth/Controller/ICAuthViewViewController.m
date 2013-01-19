//
//  ICWebViewViewController.m
//  tapebooth
//
//  Created by Marcus Kida on 18.01.13.
//  Copyright (c) 2013 Marcus Kida [indiecoder.net]. All rights reserved.
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
                   [NSString stringWithFormat:@"https://my.doctape.com/oauth2?client_id=%@&response_type=token&redirect_uri=%@&scope=docs&state=", [kOAuthAppId urlEncodeUsingEncoding:NSUTF8StringEncoding], [kOAuthRedirectUrl urlEncodeUsingEncoding:NSUTF8StringEncoding]]];
    [m_WebView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{

}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //NSLog(@"WebView Failed to load: %@", error.description);

    if([error.description rangeOfString:@"#access_token="].location != NSNotFound)
    {
        NSString *accessToken = error.description;
        NSArray *splittedUrl = [accessToken componentsSeparatedByString:@"#access_token="];
        if([splittedUrl count] >= 2)
        {
            splittedUrl = [(NSString *)[splittedUrl objectAtIndex:1] componentsSeparatedByString:@"&"];
            if([splittedUrl count] > 0)
            {
                NSString *stToken = (NSString *)[splittedUrl objectAtIndex:0];
                NSLog(@"Token: %@", stToken);
                
                [[NSUserDefaults standardUserDefaults] setObject:stToken forKey:kAuthTokenKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

@end
