//
//  ActionsViewController.m
//  vow
//
//  Created by 堤 健 on 11/05/26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActionsViewController.h"
#import "Action.h"
#import "Promise.h"

@implementation ActionsViewController

@synthesize promise,action;
@synthesize actionsArray;
@synthesize dateFormatter;
@synthesize tableView;

#pragma mark - Memory management

- (void)dealloc
{
    [super dealloc];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.allowsSelection = NO;
    self.title = [self.dateFormatter stringFromDate:promise.date];
    [self setActionsArray];
    //[self setAdWhirlView];
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

- (void)setActionsArray 
{
    NSManagedObjectContext *context = self.promise.managedObjectContext;
    
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
    if (fetchedObjects == nil){
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    
    NSMutableArray *mutableArray = [fetchedObjects mutableCopy];
    self.actionsArray = mutableArray;
    
    [mutableArray release];
    //[fetchedObjects release];//サンプルではリリースしない
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
}

#pragma mark - Table view data source

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
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
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

#pragma mark AdWhirlDelegate methods
- (void)setAdWhirlView
{
    
    AdWhirlView *awView = [AdWhirlView requestAdWhirlViewWithDelegate:self];
    CGSize adSize = [awView actualAdSize];
    CGRect newFrame = awView.frame;
    newFrame.size.height = adSize.height;
    newFrame.size.width = adSize.width;
    newFrame.origin.x = (self.view.bounds.size.width - adSize.width)/2;
    newFrame.origin.y = 317;
    awView.frame = newFrame;
    
    [self.view addSubview:awView];
    
    
}
- (NSString *)adWhirlApplicationKey
{
    return kAdWhirlIdentifier;
}

- (UIViewController *)viewControllerForPresentingModalView
{
    return self;
}

@end
