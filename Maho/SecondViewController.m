//
//  SecondViewController.m
//  Maho
//
//  Created by 堤 健 on 11/04/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import "Promise.h"
#import "Action.h"

@implementation SecondViewController

@synthesize managedObjectContext=__managedObjectContext;
@synthesize dataArray, dataDictionary;
@synthesize promise,action;
@synthesize dateFormatter;

- (void) viewDidLoad{
    
	[super viewDidLoad];
    [self setNotificationCenter];
    self.title = NSLocalizedString(@"Calendar",nil);
    /*
    UIBarButtonItem *todayButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Today",nil) style:UIBarButtonItemStylePlain target:self action:@selector(selectToday)];
    self.navigationItem.rightBarButtonItem = todayButton;
    [todayButton release];
     */
    
	//[self.monthView selectDate:[NSDate month]];たぶんいらない
    TKDateInformation info = [[NSDate date] dateInformationWithTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *date = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	[self.monthView selectDate:date];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
     
	//NSLog(@"Date: %@",date);
	
}

- (void)selectToday
{
    TKDateInformation info = [[NSDate date] dateInformationWithTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *date = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	[self.monthView selectDate:date];
    
}
- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate{
	[self generateRandomDataForStartDate:startDate endDate:lastDate];
    NSLog(@"GMT:0 Startdate: %@ Lastdate: %@",startDate,lastDate);
    
	return dataArray;
}
- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)date{
	
	// CHANGE THE DATE TO YOUR TIMEZONE
	TKDateInformation info = [date dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	NSDate *myTimeZoneDay = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone systemTimeZone]];
	
	NSLog(@"Date Selected: %@",myTimeZoneDay);

	[self.tableView reloadData];
}

- (void) calendarMonthView:(TKCalendarMonthView*)mv monthDidChange:(NSDate*)d animated:(BOOL)animated{
	[super calendarMonthView:mv monthDidChange:d animated:animated];
	[self.tableView reloadData];
}

- (void) generateRandomDataForStartDate:(NSDate*)start endDate:(NSDate*)end
{
	
	NSLog(@"Delegate Range: %@ %@ %d",start,end,[start daysBetweenDate:end]);
	
	self.dataArray = [NSMutableArray array];//マークするかしないかの目印
	self.dataDictionary = [NSMutableDictionary dictionary];
    
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Promise" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    //要確認、    
    //GMTの日付で条件をつける(Startdate Enddate)
    //startdate（ローカルでの時分なし）をGMT:0に変換して検索
    //startDate以上、endDate以下
    
    TKDateInformation info = [start dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *startDateForPredicate = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone systemTimeZone]];
    NSLog(@"startDateForPredicate %@",startDateForPredicate);
    info = [end dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *endDateForPredicate = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone systemTimeZone]];
    NSLog(@"endDateForPredicate %@",endDateForPredicate);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", startDateForPredicate, endDateForPredicate];
     [fetchRequest setPredicate:predicate];
     
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
    
    NSArray *fetchedObjects = [aFetchedResultsController fetchedObjects];
    
    /*Ken
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptors release];
    [sortDescriptor release];
     */

    for (int i = 0; i < [fetchedObjects count]; i++) {
        //格納する日付は、GMT:0をローカルでの時分なしに変換したもの
        //startDateはローカルでの時分なし
        Promise *aPromise = [fetchedObjects objectAtIndex:i];
        if (![aPromise.state isEqualToString:kPromiseStateDoing]) {
            
            NSLog(@"DB : promise.date %@",aPromise.date);
            
            TKDateInformation info = [aPromise.date dateInformationWithTimeZone:[NSTimeZone systemTimeZone]];
            info.hour = 0;
            info.minute = 0;
            info.second = 0;
            
            NSDate *date = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            [self.dataDictionary setObject:aPromise forKey:date];
            NSLog(@"Local : promise.date %@",date);
            
        }
    }
    
    NSDate *d = start;
    while(YES){
        
        Promise *bPromise = [self.dataDictionary objectForKey:d];
		if (bPromise) {
            NSLog(@"Promise.state %@",bPromise.state);
            if ([bPromise.state isEqualToString:kPromiseStateComplete]) {
                [self.dataArray addObject:[NSNumber numberWithInt:1]];
            }
            else {
                [self.dataArray addObject:[NSNumber numberWithInt:2]];
            }
        }
        else{
            [self.dataArray addObject:[NSNumber numberWithBool:NO]];
        }
		
		TKDateInformation info = [d dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		info.day++;
		d = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        //ここで終了の判定
		if([d compare:end]==NSOrderedDescending) break;
        
	}
	
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
	return 1;
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{	
    
	Promise *aPromise = [dataDictionary objectForKey:[self.monthView dateSelected]];
    NSMutableArray *actionsArray = [[NSMutableArray alloc] initWithArray:[aPromise.actions allObjects]];
	if(actionsArray == nil) return 0;
	return [actionsArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    Promise *aPromise = [dataDictionary objectForKey:[self.monthView dateSelected]];
    NSMutableArray *actionsArray = [[NSMutableArray alloc] initWithArray:[aPromise.actions allObjects]];
    Action *anAction = [actionsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [[anAction valueForKey:@"action"] description];
    if ([anAction.done boolValue] == YES) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActionsViewController *controller = [[ActionsViewController alloc] initWithNibName:@"ActionsViewController" bundle:nil];
    controller.promise = [dataDictionary objectForKey:[self.monthView dateSelected]];
    [[self navigationController] pushViewController:controller animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)setNotificationCenter
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(reloadSecondView) name:kNotificationReloadSecondView object:nil];
    
}

- (void)reloadSecondView
{
    [self.monthView reload];//更新は出来るけど、選択を解除する
    [self.tableView reloadData]; 
}

#pragma mark - Date Formatter

- (NSDateFormatter *)dateFormatter 
{	
    //時分を含まない日付データを返す
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateStyle:kCFDateFormatterLongStyle];
	}
	return dateFormatter;
}
@end
