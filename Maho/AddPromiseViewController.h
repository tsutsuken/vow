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
@protocol AddPromiseViewControllerDelegate;

@interface AddPromiseViewController : UITableViewController <UIAlertViewDelegate> {
    id <AddPromiseViewControllerDelegate> delegate;
    Promise *promise;
    Action *action;
    NSDateFormatter *dateFormatter;
    NSMutableArray *actionsArray;
    EditableTableViewCell *editableTableViewCell;
}
@property (nonatomic, assign) id <AddPromiseViewControllerDelegate> delegate;
@property (nonatomic, retain) Promise *promise;
@property (nonatomic, retain) Action *action;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSMutableArray *actionsArray;
@property (nonatomic, assign) IBOutlet EditableTableViewCell *editableTableViewCell;

- (void)addAction;
- (void)finish:(id)sender;
- (void)cancel:(id)sender;
- (UIColor *)initWithHex:(NSString *)string alpha:(CGFloat)alpha;
- (void)insertActionAnimated:(BOOL)animated;
- (void)showConfirmAlert;

@end

@protocol AddPromiseViewControllerDelegate
- (void)addPromiseViewController:(AddPromiseViewController *)controller didFinishWithSave:(BOOL)save;
@end
