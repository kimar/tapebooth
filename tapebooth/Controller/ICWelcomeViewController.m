//
//  ICWelcomeViewController.m
//  tapebooth
//
//  Created by Marcus Kida on 18.01.13.
//  Copyright (c) 2013 Marcus Kida [indiecoder.net]. All rights reserved.
//

typedef enum
{
    Thumbnail = 100,
    Filename,
    Filesize,
    Filetype
} ViewTags;

#import "ICWelcomeViewController.h"

@interface ICWelcomeViewController () <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *m_TableView;
    IBOutlet UIButton *m_SignInButton;
    
    NSMutableArray *m_aDocuments;
}
@end

@implementation ICWelcomeViewController

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
    
    [self.navigationItem setTitleView:[ICPrefs getNavigationBarLabelWithText:@"tapebooth"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"TopBar.png"]
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem setRightBarButtonItem:[ICPrefs getNavigationBarSettingsItemWithTarget:self andAction:@selector(showImprint:)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [ICApiRequestController getAllDocumentsWithCompletion:^(NSArray *documents) {
        XLog(@"Documents: %d", [documents count]);
        
        if([documents count] > 0)
        {
            [m_SignInButton setHidden:YES];
            [m_TableView setHidden:NO];
        }
        else
        {
            [m_SignInButton setHidden:NO];
            [m_TableView setHidden:YES];
        }
        
        m_aDocuments = [[NSMutableArray alloc] initWithArray:documents];
        [m_TableView reloadData];
    }];
}

#pragma mark - IBActions
- (IBAction) authButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"ShowWebView" sender:self];
}

- (IBAction) showImprint:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Imprint"
                                                    message:@"Developed from Jan 18th - Jan 20th 2013 by Marcus Kida on a lovely Hackathon at @doctapers somewhere in Hannover Germany.\nhttp://indiecoder.net\n\nMany thanks to MediaLoot.com for their GUI Artwork."
                                                   delegate:NULL
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - Segues
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowImageView"])
    {
        ICDocument *document = (ICDocument *)[m_aDocuments objectAtIndex:[m_TableView indexPathForSelectedRow].row];
        ICImageViewController *viewController = (ICImageViewController *)segue.destinationViewController;
        viewController.imageUrl = [ICPrefs getOriginalUrlForDocument:document.documentId];
        viewController.headerTitle = document.name;
    }
}

#pragma mark - UITableView Datasource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_aDocuments count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *stCellIdentifier = @"DocumentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stCellIdentifier];
    
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stCellIdentifier];
    
    ICDocument *document = (ICDocument *)[m_aDocuments objectAtIndex:indexPath.row];

    // Setup Views
    UIImageView *thumbnailImageView = (UIImageView *)[cell viewWithTag:Thumbnail];
    [thumbnailImageView.layer setCornerRadius:5.0f];
    UILabel *filenameLabel = (UILabel *)[cell viewWithTag:Filename];
    UILabel *filesizeLabel = (UILabel *)[cell viewWithTag:Filesize];
    UILabel *filetypeLabel = (UILabel *)[cell viewWithTag:Filetype];
    
    XLog(@"URL String: %@", [ICPrefs getThumbnailUrlForDocument:document.documentId]);
    [thumbnailImageView setImageWithURL:[NSURL URLWithString:[ICPrefs getThumbnailUrlForDocument:document.documentId]]
                       placeholderImage:[UIImage imageNamed:@"FabricBackground.png"]];
    [filenameLabel setText:document.name];
    [filesizeLabel setText:[NSString stringWithFormat:@"%.0f kB", (float)[document.documentSize intValue]/1000]];
    [filetypeLabel setText:[NSString stringWithFormat:@"%@", document.extension]];

    return cell;
}

#pragma mark - UITableView Delegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
