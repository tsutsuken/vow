//
//  ReminderViewController.h
//  vow
//
//  Created by 堤 健 on 11/05/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReminderViewControllerDelegate;

@interface ReminderViewController : UITableViewController {
    
    id <ReminderViewControllerDelegate> delegate;
    NSArray *timeIntervalArray;
    int timeIntervalInt;
    
}
@property (nonatomic, assign) id <ReminderViewControllerDelegate> delegate;
@property(nonatomic,retain) NSArray *timeIntervalArray;
@property (nonatomic) int timeIntervalInt;

@end

@protocol ReminderViewControllerDelegate
- (void)reminderViewControllerDidFinish:(ReminderViewController *)controller;
@end
