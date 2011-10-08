//
//  MahoAppDelegate.h
//  Maho
//
//  Created by 堤 健 on 11/04/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Promise,Action;
@interface MahoAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    
    NSDateFormatter *dateFormatter;
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationControllerForRootView;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationControllerForSecondView;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) NSDateFormatter *dateFormatter;

- (void)setReminder;
- (void)resetAllReminders;
- (int)countOfReminder;
- (NSString *)messageForReminderWith:(Promise *)promise;
- (Promise *)promiseForReminder;
- (NSMutableArray *)setActionsArrayWith:(Promise *)promise;
- (NSDateFormatter *)dateFormatter;
- (BOOL)isJapanese;

@end