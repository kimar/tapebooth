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

typedef enum
{
    PhotoActionSheet = 100,
    ActionActionSheet
} ActionSheetAlertViewTags;

typedef enum
{
    MainTableView = 100,
    MenuTableView
} TableViewTags;

#import "ICWelcomeViewController.h"

@interface ICWelcomeViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
{
    IBOutlet UITableView *m_TableView;
    IBOutlet UIButton *m_SignInButton;
    IBOutlet PaperFoldView *m_PaperFoldView;
    IBOutlet UIView *m_pMainView;
    
    BOOL m_bShowsShotPhoto;
    UIImage *m_ShotPhoto;
    UITableView *m_MenuTableView;
    NSMutableArray *m_aDocuments;
    EIImagePickerDelegate *m_pImagePickerDelegate;
}
@end

@implementation ICWelcomeViewController

@synthesize showsShotPhoto = m_bShowsShotPhoto;
@synthesize shotPhoto = m_ShotPhoto;

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
    [self.navigationItem setRightBarButtonItem:[ICPrefs getNavigationBarSettingsItemWithTarget:self andAction:@selector(showActionSheet:)]];
    
    m_MenuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 150, kScreenHeight) style:UITableViewStylePlain];
    [m_MenuTableView setBackgroundColor:[UIColor clearColor]];
    [m_MenuTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [m_MenuTableView setTag:MenuTableView];
    [m_MenuTableView setDelegate:self];
    [m_MenuTableView setDataSource:self];
    
    UIView *menuCarrierView = [[UIView alloc] initWithFrame:m_MenuTableView.frame];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [imageView setImage:[UIImage imageNamed:@"FabricBackground.png"]];
    [menuCarrierView addSubview:imageView];
    [menuCarrierView addSubview:m_MenuTableView];
    
    [m_PaperFoldView setLeftFoldContentView:menuCarrierView foldCount:3 pullFactor:.9f];
    [m_PaperFoldView setCenterContentView:m_pMainView];
    [m_PaperFoldView setEnableLeftFoldDragging:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(!m_ShotPhoto)
        m_bShowsShotPhoto = NO;
    
    if([ICPrefs hasAccessToken])
        [m_PaperFoldView setEnableLeftFoldDragging:YES];
    
    [self refreshDocuments];
    [self refreshMenu];
}

#pragma mark - PrivateMethods
- (void) refreshDocuments
{
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

- (void) refreshMenu
{
    [m_MenuTableView reloadData];
}

#pragma mark - IBActions
- (IBAction) authButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"ShowWebView" sender:self];
}

- (IBAction) showActionSheet:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"What do you want to do?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:NULL
                                                    otherButtonTitles:@"Upload photo", @"About", nil];
    actionSheet.tag = ActionActionSheet;
    [actionSheet showInView:self.view];
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

- (IBAction) selectPhotoSource:(id)sender
{
    if (!m_pImagePickerDelegate)
    {
        m_pImagePickerDelegate = [[EIImagePickerDelegate alloc] init];
        
        __weak ICWelcomeViewController *controller = self;
        [m_pImagePickerDelegate setImagePickerCompletionBlock:^(UIImage *pickerImage) {
            controller.showsShotPhoto = YES;
            controller.shotPhoto = pickerImage;
            [controller performSegueWithIdentifier:@"ShowImageView" sender:controller];

        }];
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select your photosource"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Photo Roll", @"Camera", nil];
        actionSheet.tag = PhotoActionSheet;
        [actionSheet showInView:self.view];
        
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select your photosource"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Photo Roll", nil];
        actionSheet.tag = PhotoActionSheet;
        [actionSheet showInView:self.view];
    }
}

# pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == PhotoActionSheet)
    {
        switch (buttonIndex) {
            case 0:
                [m_pImagePickerDelegate presentFromController:self withSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                break;
            case 1:
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                {
                    [m_pImagePickerDelegate presentFromController:self withSourceType:UIImagePickerControllerSourceTypeCamera];
                }
                break;
            default:
                break;
        }
    }
    else if(actionSheet.tag = ActionActionSheet)
    {
        switch (buttonIndex)
        {
            case 0:
                [self selectPhotoSource:NULL];
                break;
                
            case 1:
                [self showImprint:NULL];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - Segues
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowImageView"])
    {
        ICImageViewController *viewController = (ICImageViewController *)segue.destinationViewController;
        
        if(m_bShowsShotPhoto)
        {
            viewController.image = m_ShotPhoto;
            m_ShotPhoto = NULL;
            viewController.headerTitle = @"New Photo";
        }
        else
        {
            ICDocument *document = (ICDocument *)[m_aDocuments objectAtIndex:[m_TableView indexPathForSelectedRow].row];
            viewController.imageUrl = [ICPrefs getOriginalUrlForDocument:document.documentId];
            viewController.headerTitle = document.name;
        }
    }
}

#pragma mark - UITableView Datasource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == MenuTableView)
        return 2;
    else
        return [m_aDocuments count];
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == MenuTableView)
    {
        if (indexPath.row == 0)
        {
            return 120.0f;
        }
        else
        {
            return 50.0f;
        }
    }
    return 90.0f;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == MenuTableView)
    {
        NSString *stCellIdentifier = [NSString stringWithFormat:@"MenuCell-%d", indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stCellIdentifier];
        
        if(!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stCellIdentifier];
                
        if(indexPath.row == 0)
        {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

            UIImageView *nameBadgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80, 150, 40)];
            [nameBadgeImageView setImage:[UIImage imageNamed:@"NameBadge.png"]];
            [nameBadgeImageView setContentMode:UIViewContentModeScaleAspectFit];
            [cell.contentView addSubview:nameBadgeImageView];
            
            UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 8, 80, 80)];
            [profileImageView.layer setCornerRadius:5.0f];
            [profileImageView setClipsToBounds:YES];
            [cell.contentView addSubview:profileImageView];
            
            UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 88, 150, 30)];
            [usernameLabel setTextAlignment:NSTextAlignmentCenter];
            [usernameLabel setFont:[UIFont fontWithName:@"MarkerFelt-Thin" size:13.0f]];
            [usernameLabel setTextColor:[UIColor blackColor]];
            [usernameLabel setBackgroundColor:[UIColor clearColor]];
            //[usernameLabel setShadowColor:[UIColor blackColor]];
            [cell.contentView addSubview:usernameLabel];
            
            [cell.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ProfileBackground.png"]]];
            
            [ICApiRequestController getAccountDataWithCompletion:^(NSDictionary *account) {
                XLog(@"Avatar: %@", [account objectForKey:@"avatar"]);
                [profileImageView setImageWithURL:
                 [NSURL URLWithString:[account objectForKey:@"avatar"]]
                 placeholderImage:
                 [UIImage imageNamed:@"AvatarPlaceholder.png"]
                 ];
                [usernameLabel setText:[account objectForKey:@"username"]];
            }];
        }
        else
        {
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];

            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height)];
            [imageView setImage:[UIImage imageNamed:@"MenuItemBackground.png"]];
            [cell.contentView addSubview:imageView];
            
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height)];
            [textLabel setBackgroundColor:[UIColor clearColor]];
            [textLabel setTextColor:[UIColor whiteColor]];
            [textLabel setShadowColor:[UIColor blackColor]];
            [textLabel setText:@"Upload"];
            [textLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
            [textLabel setTextAlignment:NSTextAlignmentCenter];
            [cell.contentView addSubview:textLabel];
        }
        
        
        return cell;
    }
    else
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
                           placeholderImage:[UIImage imageNamed:@"DocumentPlaceholder.png"]];
        [filenameLabel setText:document.name];
        [filesizeLabel setText:[NSString stringWithFormat:@"%.0f kB", (float)[document.documentSize intValue]/1000]];
        [filetypeLabel setText:[NSString stringWithFormat:@"%@", document.extension]];
        
        return cell;
    }
}

#pragma mark - UITableView Delegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(tableView.tag == MenuTableView)
    {
        if(indexPath.row == 1)
        {
            [self showActionSheet:NULL];
        }
    }
}

@end
