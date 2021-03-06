//
//  SettingViewController.m
//  Maho
//
//  Created by 堤 健 on 11/03/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"


@implementation SettingViewController

@synthesize delegate;
@synthesize timeIntervalArray;

#pragma mark - Memory management
/*
- (void)dealloc
{
    [super dealloc];
}
*/
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Settings", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                                                            target:self action:@selector(closeSettingView:)];
    
    self.timeIntervalArray =[[NSArray alloc] initWithObjects:
                             NSLocalizedString(@"None",nil),
                             NSLocalizedString(@"Every hour",nil),
                             NSLocalizedString(@"Every 2 hours",nil),
                             NSLocalizedString(@"Every 3 hours",nil),
                             NSLocalizedString(@"Every 4 hours",nil),
                             NSLocalizedString(@"Every 5 hours",nil),
                             nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else{
        return 3;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return NSLocalizedString(@"Settings", nil);
    }
    else {
        return NSLocalizedString(@"Informaton", nil);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *ReminderCellIdentifier = @"Reminder";
    
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReminderCellIdentifier];
        if (cell == nil) {		
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ReminderCellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text = NSLocalizedString(@"Reminder", nil);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
        int timeInterval = [[defaults objectForKey:kTimeInterval] intValue];
        cell.detailTextLabel.text = [self.timeIntervalArray objectAtIndex:timeInterval];
        
        return cell;
        
    }
    else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {		
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.section == 1) {
            
            if (indexPath.row == 0) {
                cell.textLabel.text = NSLocalizedString(@"Support Forum", nil);
            }
            else if(indexPath.row == 1){
                cell.textLabel.text = NSLocalizedString(@"Email Us", nil);
            }
            else if(indexPath.row == 2){
                cell.textLabel.text = NSLocalizedString(@"Legal", nil);
            }

        }
                
        return cell;
    }
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        
       [self showReminderView];
        
    }
    else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            [self showSupportSite];
        }
        else if(indexPath.row == 1){
            [self setEmail];
        }else if(indexPath.row == 2){
            [self showCopyrightView];
        }
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - CloseSettingView

- (void)closeSettingView:(id)sender
{
    [self.delegate settingViewControllerDidFinish:self];
}

#pragma mark - Support

-(void)showSupportSite
{
    if ([self isJapanese]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kSupportURLForJapanese]];
    }
    else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kSupportURLForEnglish]];
    }
}

-(void)showCopyrightView
{
    CopyrightViewController *controller = [[CopyrightViewController alloc] initWithNibName:@"CopyrightViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    //[controller release];
    
}

-(void)showReminderView
{
    ReminderViewController *controller = [[ReminderViewController alloc] initWithNibName:@"ReminderViewController" bundle:nil];
    controller.delegate = self;
    controller.timeIntervalArray = self.timeIntervalArray;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
    controller.timeIntervalInt = [[defaults objectForKey:kTimeInterval] intValue];
    
    [self.navigationController pushViewController:controller animated:YES];
    //[controller release];
    
}
- (void)reminderViewControllerDidFinish:(ReminderViewController *)controller
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: [[NSNumber alloc] initWithInt:controller.timeIntervalInt] forKey:kTimeInterval];
    [defaults synchronize];
    [self.tableView reloadData];
    
    id apDelegate = [[UIApplication sharedApplication] delegate];
    
    [apDelegate setReminder];//Ken
    
}

#pragma mark - Mail

-(void)setEmail
{
	// This sample can run on devices running iPhone OS 2.0 or later  
	// The MFMailComposeViewController class is only available in iPhone OS 3.0 or later. 
	// So, we must verify the existence of the above class and provide a workaround for devices running 
	// earlier versions of the iPhone OS. 
	// We display an email composition interface if MFMailComposeViewController exists and the device can send emails.
	// We launch the Mail application on the device, otherwise.
	
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			[self displayComposerSheet];
		}
		else
		{
			[self launchMailAppOnDevice];
		}
	}
	else
	{
		[self launchMailAppOnDevice];
	}
}

// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet 
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:kEmailSubTitle];
	
    
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:kOurEmailAddress]; 
	[picker setToRecipients:toRecipients];
	
    /*
	NSString *emailBody = @"It is raining in sunny California!";
	[picker setMessageBody:emailBody isHTML:NO];
     */
	
	[self presentModalViewController:picker animated:YES];
    //[picker release];Ken
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			//message.text = @"Result: canceled";
			break;
		case MFMailComposeResultSaved:
			//message.text = @"Result: saved";
			break;
		case MFMailComposeResultSent:
			//message.text = @"Result: sent";
			break;
		case MFMailComposeResultFailed:
			//message.text = @"Result: failed";
			break;
		default:
			//message.text = @"Result: not sent";
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
	//NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=Hello from California!";
    NSString *email = [NSString stringWithFormat:@"mailto:%@?&subject=%@",kOurEmailAddress,kEmailSubTitle];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

-(BOOL)isJapanese
{
    BOOL isJapanese;
    NSUserDefaults *defs = [NSUserDefaults  standardUserDefaults];
    NSArray *languages = [defs objectForKey:@"AppleLanguages"];
    NSString *preferredLang = [languages objectAtIndex:0];
    if ([preferredLang isEqualToString:@"ja"]) {
        isJapanese = YES;
    } else {
        isJapanese = NO;
    }
    return isJapanese;
}

@end
