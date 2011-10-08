//
//  AddPromiseViewController.h
//  Maho
//
//  Created by 堤 健 on 11/03/17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SettingViewController.h"

@class Promise,Action,EditableTableViewCell;
@protocol AddPromiseForTestViewControllerDelegate;

@interface AddPromiseForTestViewController : UITableViewController <UIAlertViewDelegate> {
    //id <AddPromiseForTestViewControllerDelegate> delegate;
    Promise *promise;
    Action *action;
    NSDateFormatter *dateFormatter;
    NSMutableArray *actionsArray;
    //EditableTableViewCell *editableTableViewCell;
}
@property (nonatomic, assign) id <AddPromiseForTestViewControllerDelegate> delegate;
@property (nonatomic, retain) Promise *promise;
@property (nonatomic, retain) Action *action;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSMutableArray *actionsArray;
@property (nonatomic, assign) IBOutlet EditableTableViewCell *editableTableViewCell;

- (void)judgePromise;
- (void)finish:(id)sender;
- (void)cancel:(id)sender;
- (void)insertActionAnimated:(BOOL)animated;
- (void)showConfirmAlert;

@end

@protocol AddPromiseForTestViewControllerDelegate
- (void)addPromiseForTestViewController:(AddPromiseForTestViewController *)controller didFinishWithSave:(BOOL)save;
@end
