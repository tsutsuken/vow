//
//  RootViewController.h
//  Maho
//
//  Created by 堤 健 on 11/05/08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AddPromiseViewController.h"
#import "AddPromiseForTestViewController.h"
#import "AdWhirlView.h"
#import "AdWhirlDelegateProtocol.h"

@class Promise,Action;

@interface RootViewController : UIViewController <NSFetchedResultsControllerDelegate,AddPromiseViewControllerDelegate,SettingViewControllerDelegate,UIAlertViewDelegate,AddPromiseForTestViewControllerDelegate,AdWhirlDelegate,UITableViewDelegate, UITableViewDataSource> {

    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectContext *addingManagedObjectContext;
    Promise *promise;
    Action *action;
    NSMutableArray *actionsArray;
    NSDateFormatter *dateFormatter;
    UIButton *footerButton;
    IBOutlet UITableView *tableView;
    
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectContext *addingManagedObjectContext;
@property (nonatomic, retain) Promise *promise;
@property (nonatomic, retain) Action *action;
@property (nonatomic, retain) NSMutableArray *actionsArray;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) UIButton *footerButton;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (BOOL)canTakeNewVow;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)setPromise;
- (void)setActionsArray;
- (void)setFooterButton;
- (void)showAddPromiseView;
- (void)addPromiseViewController:(AddPromiseViewController *)controller didFinishWithSave:(BOOL)save;
- (void)addPromiseForTestViewController:(AddPromiseForTestViewController *)controller didFinishWithSave:(BOOL)save;
- (void)sendNotification;
- (void)judgePromise;
- (void)showBeginningAlert;
- (void)showResultAlertWithMessage:(NSString *)message andTitle:(NSString *)title;
- (void)showConfirmAlert;
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
