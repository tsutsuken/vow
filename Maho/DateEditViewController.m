//
//  DateEditViewController.m
//  Oath
//
//  Created by 堤 健 on 11/03/19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateEditViewController.h"


@implementation DateEditViewController

@synthesize datePicker;
@synthesize editedObject;
@synthesize editedFieldKey;
@synthesize editedFieldName;
@synthesize dateFormatter;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Memory management

/*
- (void)dealloc
{
    [editedObject release];
    [editedFieldKey release];
    [editedFieldName release];
    [datePicker release];
    [super dealloc];
}
*/
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
    // Set the title to the user-visible name of the field.
	self.title = editedFieldName;
    
	// Configure the save and cancel buttons.
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem = saveButton;
	//[saveButton release];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	//[cancelButton release];
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
    NSDate *date = [editedObject valueForKey:editedFieldKey];
    if (date == nil) date = [NSDate date];
    datePicker.date = date;
}
		
#pragma mark -
#pragma mark Save and cancel operations

- (IBAction)save {
    //時分を含まないGMT0の日付をセット
    NSString *selectedDateString = [self.dateFormatter stringFromDate:datePicker.date];
    NSLog(@"selectedDateString GMT:9 is %@",selectedDateString);
    NSDate *selectedDate = [self.dateFormatter dateFromString:selectedDateString];
    NSLog(@"selectedDate GMT:0 date is %@",selectedDate);

    [editedObject setValue:selectedDate forKey:editedFieldKey];
    NSError *error = nil;
	if (![editedObject.managedObjectContext save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);
	}
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)cancel {
    // Don't pass current value to the edited object, just pop.
    [self.navigationController popViewControllerAnimated:YES];
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

@end
