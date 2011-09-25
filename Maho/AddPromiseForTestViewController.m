//
//  AddPromiseViewController.m
//  Maho
//
//  Created by 堤 健 on 11/03/17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddPromiseForTestViewController.h"
#import "Action.h"
#import "Promise.h"
#import "DateEditViewController.h"
#import "MahoAppDelegate.h"
#import "EditableTableViewCell.h"


@implementation AddPromiseForTestViewController

@synthesize delegate;
@synthesize promise;
@synthesize action;
@synthesize dateFormatter;
@synthesize actionsArray;
@synthesize editableTableViewCell;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Memory management

- (void)dealloc
{
    [dateFormatter release];
    [promise release];
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
    self.title = NSLocalizedString(@"Test", nil);
    self.actionsArray = [NSMutableArray array];
    self.tableView.allowsSelectionDuringEditing = YES;
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                                                            target:self action:@selector(finish:)] autorelease];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                                                           target:self action:@selector(cancel:)] autorelease];
    
    //self.navigationController.navigationBar.tintColor = [self initWithHex:kNavBarColor alpha:0.5];
    self.editing = YES;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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

#pragma mark - CloseAddPromiseView

- (void)finish:(id)sender {

    [self showConfirmAlert];
}

- (void)cancel:(id)sender {
	[delegate addPromiseViewController:self didFinishWithSave:NO];
}

#pragma mark - Push Footer Button

- (void)judgePromise
{
    for (int i = 0; i < [actionsArray count]; i++) {
        if ([[[actionsArray objectAtIndex:i] valueForKey:@"done"] boolValue] == NO) {
            promise.state = kPromiseStateFailed;
            return;
        }
    }
    promise.state = kPromiseStateComplete;
    NSLog(@"state became %@", promise.state);
    
    NSManagedObjectContext *context = promise.managedObjectContext;
    NSError *error = nil;
    if (![context save:&error]) {
        // Handle the error.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
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
    return [actionsArray count]+ 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *dateCellIdentifier = @"Date";
    static NSString *insertionCellIdentifier = @"InsertAction";
    static NSString *editableCellIdentifier = @"EditableTableViewCell";
    
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dateCellIdentifier];
        if (cell == nil) {		
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dateCellIdentifier] autorelease];
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.text = [self.dateFormatter stringFromDate:promise.date];
        
        return cell;

    }
    else{
        if (indexPath.row == [actionsArray count]) {
            ///アクション挿入用のセル
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:insertionCellIdentifier];
            if (cell == nil) {		
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:insertionCellIdentifier] autorelease];
                cell.textLabel.textAlignment = UITextAlignmentCenter;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            cell.textLabel.text = @"Add Action";
            
            return cell;
        }
        else {
            
            EditableTableViewCell *cell = (EditableTableViewCell *)[tableView dequeueReusableCellWithIdentifier:editableCellIdentifier];
            
            if (cell == nil) {		
                [[NSBundle mainBundle] loadNibNamed:@"EditableTableViewCell" owner:self options:nil];
                cell = editableTableViewCell;
                cell.textField.placeholder = NSLocalizedString(@"Action", nil);
                self.editableTableViewCell = nil;
            }
            
            // Set the tag on the text field to the row number so it can be identified later if edited.
            cell.textField.tag = indexPath.row;
            
            Action *anAction = [actionsArray objectAtIndex:indexPath.row];
            
            // If the tag at this row in the tags array is related to the event, display a checkmark, otherwise remove any checkmark that might have been present.
            cell.textField.text = anAction.action;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            return cell;
        }

    }
        
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return NSLocalizedString(@"Edit Date", nil);
    }
    else {
    return NSLocalizedString(@"Today, I do", nil);
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    else {
        return NSLocalizedString(@"", nil);
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 44.0;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 44.0;
}
#pragma mark - Table view Edit

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (indexPath.section == 0) {
        return UITableViewCellEditingStyleNone;
    }
    else{
        
        if (indexPath.row == [actionsArray count]) {
            return UITableViewCellEditingStyleInsert;
        }
        return UITableViewCellEditingStyleDelete;
        
    }
    
    
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //編集モードで横のボタンが押された時の処理
	NSManagedObjectContext *context = promise.managedObjectContext;
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
		////////// Actionを削除する.
		// Ensure the cell is not being edited, otherwise the callback in textFieldShouldEndEditing: may look for a non-existent row.
		EditableTableViewCell *cell = (EditableTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell.textField becomeFirstResponder];
		[cell.textField resignFirstResponder];
        
		Action *deletingAction = [actionsArray objectAtIndex:indexPath.row];
		[context deleteObject:deletingAction];
		[actionsArray removeObject:deletingAction];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		
		// Save the change.
		NSError *error = nil;
		if (![context save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);
		}	
        
        if ([actionsArray count] == 0) {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
		
    }
	
	if (editingStyle == UITableViewCellEditingStyleInsert) {
        [self insertActionAnimated:YES];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        //[self addAction];
	}	
}

#pragma mark - Table view Select

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Disable selection of Actions.
    if (indexPath.section == 1) {
        return nil;
    }
    else return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //通常モード時にセルをタップした時の処理
    switch (indexPath.section) {
        case 0: {
            
             DateEditViewController *controller = [[DateEditViewController alloc] initWithNibName:@"DateEditViewController" bundle:nil];
             controller.editedObject = self.promise;
             controller.editedFieldKey = @"date";
             controller.editedFieldName = NSLocalizedString(@"Date",@"display name for Date");
             [self.navigationController pushViewController:controller animated:YES];
             [controller release];
             
        } break;
        case 1: {
            
        } break;
    }
}

- (void)insertActionAnimated:(BOOL)animated {
	
	//新しいactionを作成
    //DBのpromiseにactionを追加
    //viewのactionsArrayにactionを追加
    //cellを挿入
    //cellを編集状態にする
	
	Action *newAction = [NSEntityDescription insertNewObjectForEntityForName:@"Action" inManagedObjectContext:promise.managedObjectContext];
	
	[promise addActionsObject:newAction];
    
    [actionsArray addObject:newAction];
    NSLog(@"Action count %d", [actionsArray count]);
    
    NSError *error = nil;
    if (![promise.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);
    }
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[actionsArray count]-1 inSection:1];
    UITableViewRowAnimation animationStyle = UITableViewRowAnimationNone;
	if (animated) {
		animationStyle = UITableViewRowAnimationFade;
	}
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:animationStyle];
	
	EditableTableViewCell *cell = (EditableTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
	[cell.textField becomeFirstResponder];
}

#pragma mark - Editing text fields
/*
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
	Action *editedAction = [actionsArray objectAtIndex:textField.tag];
	editedAction.action = textField.text;
	
	return YES;
}	
*/
- (void)textFieldDidChange:(UITextField *)textField {
    
	Action *editedAction = [actionsArray objectAtIndex:textField.tag];
	editedAction.action = textField.text;
    
    NSLog(@"textFieldから挿入されたアクション:%@ %s",editedAction.action ,__func__);

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {	
	[textField resignFirstResponder];
	return YES;	
}

#pragma mark - Date Formatter

- (NSDateFormatter *)dateFormatter {	
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateStyle:kCFDateFormatterLongStyle];
	}
	return dateFormatter;
}
- (UIColor *) initWithHex:(NSString *)string alpha:(CGFloat)alpha {
    UIColor *color = nil;
    if (string && [string length] == 7) {
        NSString *colorString = [NSString stringWithFormat:
                                 @"0x%@ 0x%@ 0x%@",
                                 [string substringWithRange:NSMakeRange(1, 2)],
                                 [string substringWithRange:NSMakeRange(3, 2)],
                                 [string substringWithRange:NSMakeRange(5, 2)]];
        
        unsigned red, green, blue;
        NSScanner *scanner = [NSScanner scannerWithString:colorString];
        if ([scanner scanHexInt:&red] && [scanner scanHexInt:&green] && [scanner scanHexInt:&blue]) {
            color = [[UIColor alloc] initWithRed:(float)red / 0xff
                                           green:(float)green / 0xff
                                            blue:(float)blue / 0xff
                                           alpha:alpha];
        }
    }
    return color;
}

#pragma mark - UIAlertView

- (void)showConfirmAlert
{
    NSString *message = NSLocalizedString(@"＊You can make one vow per day.\n＊You cannot edit this later.",nil);
    // 注意_タイトルを変えると、下のコードも変えなきゃダメ
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Do you make a vow?", nil) message:message
                                                   delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Yes, I do", nil), nil];
	[alert show];	
	[alert release];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        [delegate addPromiseForTestViewController:self didFinishWithSave:YES];
    }
}

@end
