//
//  SelectActionViewController.m
//  Maho
//
//  Created by 堤 健 on 11/04/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SelectActionViewController.h"
#import "Action.h"
#import "Habit.h"
#import "EditableTableViewCell.h"


@implementation SelectActionViewController

@synthesize delegate;
@synthesize fetchedResultsController=__fetchedResultsController;
@synthesize managedObjectContext=__managedObjectContext;
@synthesize action;
@synthesize editableTableViewCell;
@synthesize habitsArray;

#pragma mark - Memory management
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [__fetchedResultsController release];
    [__managedObjectContext release];
    [super dealloc];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Select Action", nil);
    self.tableView.allowsSelectionDuringEditing = YES;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
     self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
     target:self action:@selector(cancel:)] autorelease];
     
    NSManagedObjectContext *context = action.managedObjectContext;
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Habit"
											  inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"habit"
																   ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSError *error;
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	if (fetchedObjects == nil) {
		// Handle the error.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
	
	NSMutableArray *mutableArray = [fetchedObjects mutableCopy];
	self.habitsArray = mutableArray;
	[mutableArray release];
	
	[fetchRequest release];
	[sortDescriptor release];
	[sortDescriptors release];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /*
    if ([habitsArray count] == 0) {
		[self setEditing:YES animated:NO];
		[self insertHabitAnimated:NO];
	}
     */
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}
#pragma mark - Save and cancel operations

- (IBAction)cancel:(id)sender {
	[delegate selectActionViewController:self didFinishWithSave:NO];
}

- (IBAction)save:(id)sender {
	[delegate selectActionViewController:self didFinishWithSave:YES];
}
#pragma mark - Table view data source methods
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return [[self.fetchedResultsController sections] count];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Habitの表示数は%d個です",[habitsArray count]);
    NSUInteger count = [habitsArray count];
	if (self.editing) {
		count++;
	}
    return count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *HabitCellIdentifier = @"Habit";
    static NSString *InsertionCellIdentifier = @"InsertHabit";
    
    NSUInteger row = indexPath.row;
	
	if (row == [habitsArray count]) {
        
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InsertionCellIdentifier];
		if (cell == nil) {		
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:InsertionCellIdentifier] autorelease];
			cell.textLabel.text = @"Add Habit";
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
		return cell;
	}
    else{
        
        EditableTableViewCell *cell = (EditableTableViewCell *)[tableView dequeueReusableCellWithIdentifier:HabitCellIdentifier];
        
        if (cell == nil) {		
            [[NSBundle mainBundle] loadNibNamed:@"EditableTableViewCell" owner:self options:nil];
            cell = editableTableViewCell;
            self.editableTableViewCell = nil;
        }
        
        // Set the tag on the text field to the row number so it can be identified later if edited.
        cell.textField.tag = row;
        
        Habit *habit = [habitsArray objectAtIndex:row];
        
        // If the tag at this row in the tags array is related to the event, display a checkmark, otherwise remove any checkmark that might have been present.
        cell.textField.text = habit.habit;
        
        return cell;
    }

}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    //NSManagedObject *managedObject = [habitsArray objectAtIndexPath:indexPath];
    //cell.textLabel.text = [[managedObject valueForKey:@"habit"] description];
    cell.textLabel.text = @"Habit";
}
#pragma mark - Editing rows

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// The add row gets an insertion marker, the others a delete marker.
	if (indexPath.row == [habitsArray count]) {
		return UITableViewCellEditingStyleInsert;
	}
    return UITableViewCellEditingStyleDelete;
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
	
	// Don't show the Back button while editing.
	[self.navigationItem setHidesBackButton:editing animated:YES];
    
	
	[self.tableView beginUpdates];
	
    NSUInteger count = [habitsArray count];
    
    NSArray *habitInsertIndexPath = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:count inSection:0]];
    
	// Add or remove the Add row as appropriate.
    UITableViewRowAnimation animationStyle = UITableViewRowAnimationNone;
	if (editing) {
		if (animated) {
			animationStyle = UITableViewRowAnimationFade;
		}
		[self.tableView insertRowsAtIndexPaths:habitInsertIndexPath withRowAnimation:animationStyle];
	}
	else {
        [self.tableView deleteRowsAtIndexPaths:habitInsertIndexPath withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tableView endUpdates];
	
	// If editing is finished, save the managed object context.
	
	if (!editing) {
		NSManagedObjectContext *context = action.managedObjectContext;
		NSError *error = nil;
		if (![context save:&error]) {
			// Handle the error.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
	}
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSManagedObjectContext *context = action.managedObjectContext;
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
		// Delete the tag.
		
		// Ensure the cell is not being edited, otherwise the callback in textFieldShouldEndEditing: may look for a non-existent row.
		EditableTableViewCell *cell = (EditableTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
		[cell.textField resignFirstResponder];
        
		
		// Find the tag to delete.
		Habit *habit = [habitsArray objectAtIndex:indexPath.row];
        
		// Delete the tag from the context.  Because the relationship between Tag and Event is defined in both directions, and the delete rule is nullify, Core Data automatically removes the tag from any relationships in which it is present.
		[context deleteObject:tag];
        
		// Remove the tag from the tags array and the corresponding row from the table view.
		[tagsArray removeObject:tag];
		
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		
		// Save the change.
		NSError *error = nil;
		if (![context save:&error]) {
			// Handle the error.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}	
		
    }
	
	if (editingStyle == UITableViewCellEditingStyleInsert) {
		[self insertTagAnimated:YES];
		// Don't save yet as the user must set a name.
	}	
}


- (void)insertHabitAnimated:(BOOL)animated {
	
	// Create a new instance of Tag, insert it into the tags array, and add a corresponding new row to the table view.
	
	Habit *habit = [NSEntityDescription insertNewObjectForEntityForName:@"Habit" inManagedObjectContext:action.managedObjectContext];
	
	// Add the new tag to the tags array and to the table view.	
	[habitsArray addObject:habit];
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[habitsArray count]-1 inSection:0];
    UITableViewRowAnimation animationStyle = UITableViewRowAnimationNone;
	if (animated) {
		animationStyle = UITableViewRowAnimationFade;
	}
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:animationStyle];
	
	// Start editing the tag's name.
	EditableTableViewCell *cell = (EditableTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
	[cell.textField becomeFirstResponder];

}

#pragma mark - Selection and moving

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [habitsArray count]) {
        [self addHabit];
        
    }
    else {
        /*
        NSString *habitString = [[self.fetchedResultsController objectAtIndexPath:indexPath] valueForKey:@"habit"];
        [self.action setValue:@"Habit" forKey:@"action"];
        [delegate selectActionViewController:self didFinishWithSave:YES];
         */
    }
}

#pragma mark - Add Habit

- (void)addHabit
{
    //HabitをDBに追加
    //Habitをセルに追加
    //編集可能な状態にする
}
/*
#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil)
    {
        return __fetchedResultsController;
    }
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Habit" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"habit" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"SelectAction"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error])
    {

	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}    

#pragma mark - Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type)
    {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}
*/
@end
