//
//  RootViewController.m
//  Maho
//
//  Created by 堤 健 on 11/05/08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "Action.h"
#import "Promise.h"

@implementation RootViewController

@synthesize managedObjectContext=__managedObjectContext;
@synthesize addingManagedObjectContext;
@synthesize promise,action;
@synthesize actionsArray;
@synthesize dateFormatter;
@synthesize footerButton;
@synthesize rootTableView;
@synthesize checkBoxTableViewCell;
@synthesize AdMaker;

#pragma mark - Twitter

- (void)showTweetView
{
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    // MeetingSetupViewController.m: error: Semantic Issue: Use of undeclared identifier 'TWTweetComposeViewController'
    
    [twitter setInitialText:[self messageForTwitter]];
    
    [self presentViewController:twitter animated:YES completion:nil];
    
    
    twitter.completionHandler = ^(TWTweetComposeViewControllerResult res) 
    {
        if(res == TWTweetComposeViewControllerResultDone){
            
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Your Tweet was posted succesfully", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            
        }else if(res == TWTweetComposeViewControllerResultCancelled){

        }
        
        
        [self dismissModalViewControllerAnimated:YES];   
    };
}

- (NSString *)messageForTwitter
{
    NSString *messageForTwitter = NSLocalizedString(@"#ToDoToday", nil);
    NSString *actionString = nil;
    
    for (int i = 0; i < [actionsArray count]; i++) {
        if([[actionsArray objectAtIndex:i] valueForKey:@"action"]){
            actionString = [@"\n◆" stringByAppendingString:[[actionsArray objectAtIndex:i] valueForKey:@"action"]];
            NSLog(@"actionString:%@",actionString);
            messageForTwitter = [messageForTwitter stringByAppendingString:actionString];
            actionString = nil;
        }
        
    }
    NSString *footer = [@"\n " stringByAppendingString:[self URLForApp]];
    messageForTwitter = [messageForTwitter stringByAppendingString:footer];

    return messageForTwitter;
}

- (NSString *)URLForApp
{
    id appDelegate = [[UIApplication sharedApplication] delegate];
    if ([appDelegate isJapanese]) {
        return kAppURLForJapanese;
    }
    else{
        return kAppURLForEnglish;
    }
}
#pragma mark - UIActionSheetDelegate

- (void)showActionSheetForOutPut
{
	// open a dialog with two custom buttons
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Tweet",nil),
                                                                      nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	//actionSheet.destructiveButtonIndex = 1;	// make the second button red (destructive)
	[actionSheet showInView:self.view.window]; // show from our table view (pops up in the middle of the table)

}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 0)
	{
		NSLog(@"ok");
        [self showTweetView];
	}
	else
	{
		NSLog(@"cancel");
	}
}

#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}
#pragma mark AdMaker
- (void)setAdMaker
{
    AdMaker = [[AdMakerView alloc] init];
    [AdMaker setAdMakerDelegate:self];
    [AdMaker setFrame:CGRectMake(0, 317, 320, 50)]; //(0, 317, 320, 50)
    [AdMaker start];
    
}

-(UIViewController*)currentViewControllerForAdMakerView:(AdMakerView*)view 
{
    return self;
}

-(NSArray*)adKeyForAdMakerView:(AdMakerView*)view 
{
    return [NSArray arrayWithObjects:kURLForAdMaker,kSiteIDForAdMaker,kZoneIDForAdMaker,nil]; 
}

//広告の取得に成功
- (void)didLoadAdMakerView:(AdMakerView*)view 
{
    [self.view addSubview:AdMaker.view];
}

//広告の取得に失敗
- (void) didFailedLoadAdMakerView:(AdMakerView*)view 
{
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    //self.navigationController.navigationBar.tintColor = [UIColor magentaColor];
    //self.navigationItem.title = [self.dateFormatter stringFromDate:[NSDate date]];
    self.navigationItem.title = NSLocalizedString(@"To do today",nil);
    
    
    UIBarButtonItem *settingButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Settings",nil) style:UIBarButtonItemStylePlain target:self action:@selector(showSettingView)];
     self.navigationItem.leftBarButtonItem = settingButton;
     
    /*
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionSheetForOutPut)];
    self.navigationItem.rightBarButtonItem = tweetButton;
     */
    
    /*
    UIBarButtonItem *testButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Test",nil) style:UIBarButtonItemStylePlain target:self action:@selector(showAddPromiseForTestView)];
    self.navigationItem.rightBarButtonItem = testButton;
     */

    [self setPromise];
    [self setActionsArray];
    [self setFooterButton];
    [self setAdMaker];
    
    NSLog(@"state is %@ in %s",promise.state, __func__);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     NSLog(@"canTakeNewVow %d",[self canTakeNewVow]);
    footerButton.enabled = [self canTakeNewVow];
    [AdMaker viewWillAppear];//広告のviewを表示します。
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [AdMaker viewWillDisappear];//広告のviewが非表示になったことを伝えます。
    
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)setFooterButton
{
    //宣言ボタンの設定
    
    self.footerButton = nil;
    self.rootTableView.tableFooterView = nil;
    
    self.footerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.footerButton.frame = CGRectMake(20, 0, 280, 44);
    self.footerButton.backgroundColor = [UIColor clearColor];
    
    //ボタン有効時
    if ([actionsArray count] == 0) {
        [footerButton setTitle:NSLocalizedString(@"Make today's vow", nil) forState:UIControlStateNormal];
    }
    else{
        [footerButton setTitle:NSLocalizedString(@"Finish", nil) forState:UIControlStateNormal];
    }
    
    //ボタン無効時
    [footerButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    NSString *titleForDisabled = NSLocalizedString(@"You've finished today's task", nil);
    [footerButton setTitle:titleForDisabled forState:UIControlStateDisabled];
    
    [footerButton addTarget:self action:@selector(pushFooterButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
    //footerView.backgroundColor = [UIColor blueColor];
    [footerView addSubview:footerButton];
    
    self.rootTableView.tableFooterView = footerView; 
    //[footerView release];
}
- (BOOL)canTakeNewVow 
{
    if (![promise.state isEqualToString:kPromiseStateDoing]) {
        
        NSString *nowDateString = [self.dateFormatter stringFromDate:[NSDate date]];
        NSString *promiseDateString = [dateFormatter stringFromDate:promise.date];
        
        if ([nowDateString isEqualToString:promiseDateString]) {
            NSLog(@"%s : NO", __func__);
            return NO;
        }
    }
    NSLog(@"%s : YES", __func__);
    
    return YES;

}

#pragma mark - Set data source

- (void)setPromise 
{
    //一番新しいpromiseをセットする
    //初回起動時はnilになる
    self.promise = nil;
    
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Promise" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    if (![[aFetchedResultsController fetchedObjects] count] == 0) {
        self.promise = [[aFetchedResultsController fetchedObjects] objectAtIndex:0];
    }

    NSLog(@"state is %@ in %s",promise.state, __func__);
    
}

- (void)setActionsArray 
{
    //promiseがない、もしくは実行済みの場合はnilを
    //promiseがあり、Doingの場合のみ、該当するactionsArrayを返す
    self.actionsArray = nil;
    if (promise) {
        if ([promise.state isEqualToString:kPromiseStateDoing]) {
            
            NSLog(@"Setting ActionsArray");
            
            NSManagedObjectContext *context = self.managedObjectContext;
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Action"
                                                      inManagedObjectContext:context];
            [fetchRequest setEntity:entity];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"promise == %@", self.promise];
            [fetchRequest setPredicate:predicate];
            //[predicate release];//リリースすると落ちる
            
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"action"
                                                                           ascending:YES];
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
            [fetchRequest setSortDescriptors:sortDescriptors];
            
            NSError *error = nil;
            NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
            if (fetchedObjects == nil) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                exit(-1);  // Fail
            }
            
            NSMutableArray *mutableArray = [fetchedObjects mutableCopy];
            self.actionsArray = mutableArray;
            
        }
    }
    
    NSLog(@"actionsArray count : %i in %s",[actionsArray count], __func__);
    
}

#pragma mark - Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [actionsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *checkBoxCellIdentifier = @"CheckBoxCellIdentifier";
    
    CheckBoxTableViewCell *cell = (CheckBoxTableViewCell *)[tableView dequeueReusableCellWithIdentifier:checkBoxCellIdentifier];
    
    if (cell == nil) {		
        [[NSBundle mainBundle] loadNibNamed:@"CheckBoxTableViewCell" owner:self options:nil];
        cell = checkBoxTableViewCell;
        cell.label.text = NSLocalizedString(@"Ken", nil);
        self.checkBoxTableViewCell = nil;
    }
    
    Action *anAction = [self.actionsArray objectAtIndex:indexPath.row];
    cell.label.text = [[anAction valueForKey:@"action"] description];
    if ([anAction.done boolValue] == YES) {
        [cell.checkBox setSelected:YES];
    }
    else {
        [cell.checkBox setSelected:NO];
    }
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    //actionが0の時にやると落ちる
    Action *anAction = [self.actionsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [[anAction valueForKey:@"action"] description];
    if ([anAction.done boolValue] == YES) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

}

#pragma mark - Table view Edit

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Table view Select

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Action *selectedAction = [actionsArray objectAtIndex:indexPath.row];
    CheckBoxTableViewCell *cell = (CheckBoxTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if ([selectedAction.done boolValue] == YES) {
        [cell.checkBox setSelected:NO];
        selectedAction.done = [NSNumber numberWithBool:NO];
    }
    else {
        [cell.checkBox setSelected:YES];
        selectedAction.done = [NSNumber numberWithBool:YES];
    }
    
    // Save the change.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Handle the error.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark - Push Footer Button

- (IBAction)pushFooterButton:(id)sender 
{
    NSLog(@"state is %@ in %s",promise.state, __func__);
    
    if ([promise.state isEqualToString:kPromiseStateDoing]) {
        
        NSLog(@"showConfirlmAlert");
        [self showConfirmAlert];
        
    }
    else {
        
        NSLog(@"showAddPromiseView");
        [self showAddPromiseView];
        
    }
    
}

- (void)showAddPromiseForTestView
{
    AddPromiseForTestViewController *controller = [[AddPromiseForTestViewController alloc] initWithNibName:@"AddPromiseForTestViewController" bundle:nil];
    controller.delegate = self;
    
    NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
	self.addingManagedObjectContext = addingContext;
	//[addingContext release];
    [addingManagedObjectContext setPersistentStoreCoordinator:[self.managedObjectContext persistentStoreCoordinator]];
    
    
    controller.promise = (Promise *)[NSEntityDescription insertNewObjectForEntityForName:@"Promise" inManagedObjectContext:self.addingManagedObjectContext];
    
    //時分を含まないGMT0の日付をセット
    NSString *nowDateString = [self.dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"Added promise's GMT:9 date is %@",nowDateString);
    controller.promise.date = [self.dateFormatter dateFromString:nowDateString];
    NSLog(@"Added promise's GMT:0 date is %@",controller.promise.date);
    
    controller.promise.state = kPromiseStateDoing;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentModalViewController:navController animated:YES];
    //[controller release];
    
}

- (void)addPromiseForTestViewController:(AddPromiseForTestViewController *)controller didFinishWithSave:(BOOL)save
{
	if (save) {
        
		NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
		[dnc addObserver:self selector:@selector(addControllerContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:addingManagedObjectContext];
		
		NSError *error;
		if (![addingManagedObjectContext save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
		[dnc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:addingManagedObjectContext];
        
        [self setPromise];
        [self setActionsArray];
        [self.rootTableView reloadData];
        [self setFooterButton];
        [self showBeginningAlert];
        id appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate setReminder];
        
	}
	self.addingManagedObjectContext = nil;
    
    [self dismissModalViewControllerAnimated:YES];
    
    NSLog(@"state is %@ in %s",promise.state, __func__);
    
}
////////////////////////////////////////////////////////////////////////////
- (void)showAddPromiseView
{
    AddPromiseViewController *controller = [[AddPromiseViewController alloc] initWithNibName:@"AddPromiseViewController" bundle:nil];
    controller.delegate = self;
    NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
	self.addingManagedObjectContext = addingContext;
	//[addingContext release];
	
	[addingManagedObjectContext setPersistentStoreCoordinator:[self.managedObjectContext persistentStoreCoordinator]];
    
    controller.promise = (Promise *)[NSEntityDescription insertNewObjectForEntityForName:@"Promise" inManagedObjectContext:self.addingManagedObjectContext];//addingContextだった
    
    //時分を含まないGMT0の日付をセット
    NSString *nowDateString = [self.dateFormatter stringFromDate:[NSDate date]];
     NSLog(@"Added promise's GMT:9 date is %@",nowDateString);
    controller.promise.date = [self.dateFormatter dateFromString:nowDateString];
    NSLog(@"Added promise's GMT:0 date is %@",controller.promise.date);
    
    controller.promise.state = kPromiseStateDoing;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentModalViewController:navController animated:YES];
    //[controller release];
    
}

- (void)addPromiseViewController:(AddPromiseViewController *)controller didFinishWithSave:(BOOL)save {
	
	if (save) {

		NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
		[dnc addObserver:self selector:@selector(addControllerContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:addingManagedObjectContext];
		
		NSError *error;
		if (![addingManagedObjectContext save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
		[dnc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:addingManagedObjectContext];
        
	}
	self.addingManagedObjectContext = nil;
    
    [self dismissModalViewControllerAnimated:YES];
    
    NSLog(@"state is %@ in %s",promise.state, __func__);
    
}

- (void)addControllerContextDidSave:(NSNotification*)saveNotification {
	
	// Merging changes causes the fetched results controller to update its results
	[self.managedObjectContext mergeChangesFromContextDidSaveNotification:saveNotification];	
    
    [self setPromise];
    [self setActionsArray];
    [self.rootTableView reloadData];
    [self setFooterButton];
    [self showBeginningAlert];
    id appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate setReminder];
    
    NSLog(@"ManagedObject Saved");
}

- (void)finishPromise
{
    [self judgePromise];
    [self setActionsArray];
    [self.rootTableView reloadData];
    [self setFooterButton];
    footerButton.enabled = [self canTakeNewVow];
    [self sendNotification];
    id appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate resetAllReminders];
    
}

- (void)sendNotification
{
    NSNotification *n = [NSNotification notificationWithName:kNotificationReloadSecondView object:self];
    [[NSNotificationCenter defaultCenter] postNotification:n];
    NSLog(@"%s", __func__);
}

- (void)judgePromise
{
    for (int i = 0; i < [actionsArray count]; i++) {
        if ([[[actionsArray objectAtIndex:i] valueForKey:@"done"] boolValue] == NO) {
            
            promise.state = kPromiseStateFailed;
            
            NSLog(@"stateが%@になったよ！ in %s",promise.state, __func__);
            
            NSError *error = nil;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                exit(-1);
            }
            
            [self showResultAlertWithMessage:NSLocalizedString(@"Unfortunately, you couldn't keep today's vow.", nil) andTitle:NSLocalizedString(@"Finished", nil)];
            
            return;
        }
    }
    promise.state = kPromiseStateComplete;
    
    NSLog(@"stateが%@になったよ！ in %s",promise.state, __func__);
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);
    }
    
    [self showResultAlertWithMessage:NSLocalizedString(@"You've kept today's vow.", nil) andTitle:NSLocalizedString(@"Conguraturations!",nil)];
    
}

#pragma mark - SettingView

-(void)showSettingView
{
	
	SettingViewController *settingViewController = [[SettingViewController alloc] 
                                                    initWithNibName:@"SettingViewController" bundle:[NSBundle mainBundle]];
    settingViewController.delegate = self;
    settingViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingViewController];
    [self presentModalViewController:navController animated:YES];
    
    //[settingViewController release];
	
}

- (void)settingViewControllerDidFinish:(SettingViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Date Formatter

- (NSDateFormatter *)dateFormatter {	
    //時分を含まない日付データを返す
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateStyle:kCFDateFormatterLongStyle];
	}
	return dateFormatter;
}

#pragma mark - UIAlertView

- (void)showBeginningAlert
{
	// open an alert with just an OK button
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Have a nice day!", nil) message:nil
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];	
}

- (void)showResultAlertWithMessage:(NSString *)message andTitle:(NSString *)title
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];	
}
- (void)showConfirmAlert
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Are you sure?", nil) message:nil
                                                   delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"YES", nil), nil];
	[alert show];	
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        [self finishPromise];
    }
}



@end
