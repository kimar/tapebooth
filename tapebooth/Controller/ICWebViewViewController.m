//
//  ICWebViewViewController.m
//  tapebooth
//
//  Created by Marcus Kida on 18.01.13.
//  Copyright (c) 2013 Marcus Kida [indiecoder.net]. All rights reserved.
//

#import "ICWebViewViewController.h"

@interface ICWebViewViewController () <UIWebViewDelegate>
{
    IBOutlet UIWebView *m_WebView;
    NSURL *m_UrlToLoad;
    
    BOOL m_bIsAuthentication;
}
@end

@implementation ICWebViewViewController

@synthesize urlToLoad = m_UrlToLoad;
@synthesize isAuthentication = m_bIsAuthentication;

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
    
    m_UrlToLoad = [NSURL URLWithString:
                   [NSString stringWithFormat:@"https://my.doctape.com/oauth2?client_id=%@&response_type=token&redirect_uri=%@&scope=docs&state=", [kOAuthAppId urlEncodeUsingEncoding:NSUTF8StringEncoding], [kOAuthRedirectUrl urlEncodeUsingEncoding:NSUTF8StringEncoding]]];
    [m_WebView loadRequest:[NSURLRequest requestWithURL:m_UrlToLoad]];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *stTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"WebView Finished: %@ Title: %@", [webView.request.URL description], stTitle);
    
    if([stTitle rangeOfString:@"Success code"].location != NSNotFound)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"WebView Failed to load: %@", error.description);

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
