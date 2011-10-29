//
//  MahoAppDelegate.m
//  Maho
//
//  Created by 堤 健 on 11/04/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MahoAppDelegate.h"
#import "SecondViewController.h"
#import "RootViewController.h"
#import "Action.h"
#import "Promise.h"

@implementation MahoAppDelegate


@synthesize window=_window;

@synthesize managedObjectContext=__managedObjectContext;

@synthesize managedObjectModel=__managedObjectModel;

@synthesize persistentStoreCoordinator=__persistentStoreCoordinator;

@synthesize navigationControllerForRootView=_navigationControllerForRootView;

@synthesize navigationControllerForSecondView=_navigationControllerForSecondView;

@synthesize tabBarController=_tabBarController;

@synthesize dateFormatter;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    //self.window.rootViewController = self.navigationController;
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)awakeFromNib
{
    RootViewController *rootViewController = (RootViewController *)[self.navigationControllerForRootView topViewController];
    rootViewController.managedObjectContext = self.managedObjectContext;
    
    SecondViewController *secondViewController = (SecondViewController *)[self.navigationControllerForSecondView topViewController];
    secondViewController.managedObjectContext = self.managedObjectContext;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Maho" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Maho.sqlite"];
    
    
    //ver1.0からのアップデートの為に、DBのマイグレーションを行うオプションを設定
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Reminder

-(void)setReminder{
    
    //約束作成時★
    //設定の変更時★
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    //第１チェック:リマインダーの設定がNoneならセットしない
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int remindInterval = [[defaults objectForKey:kTimeInterval] intValue];
    if (remindInterval == 0){
        NSLog(@"Don't set Reminder%s",__func__);
        return;
    }
    
    //第２チェック:promiseがdoingじゃない場合はリマインドはセットしない
    Promise *promise = [self promiseForReminder];
    if (![promise.state isEqualToString:kPromiseStateDoing]) {
        NSLog(@"Don't set Reminder%s",__func__);
        return;
    }
    
    NSString *message = [self messageForReminderWith:promise];
    int countOfReminder = [self countOfReminder];
    
    for (int i = 0; i < countOfReminder; i++) {
        
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        if (localNotif == nil){
            return;
        }
        
        localNotif.alertBody = message;

        localNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow:(i+1)*remindInterval*60*60];
        NSLog(@"%i個目の remindDate:%@",i+1,localNotif.fireDate);
        //localNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow:7];
        
        
        localNotif.timeZone = [NSTimeZone defaultTimeZone];
        //localNotif.hasAction = NO;
        localNotif.alertAction = NSLocalizedString(@"Confirm",nil);
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        //[localNotif release];Ken
        
    }
    
    NSLog(@"セットされているリマインドの数:%i",[[[UIApplication sharedApplication] scheduledLocalNotifications] count]); 
    
}

-(void)resetAllReminders{
    //約束終了時
    NSLog(@"%s",__func__);
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
}

- (int)countOfReminder
{
    //(明日の0時-今の時間)÷時間間隔
    //今日が終わった時に再設定した場合、また鳴ってしまう
     //promiseの日付の最後の時間と比べれば良い
    
    NSDate *currentDate = [NSDate date];
    NSLog(@"currentDate:%@ %s",currentDate,__func__);
    
    NSString *endOfTodayString = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:24*60*60]];
    NSDate *endOfTodayDate = [self.dateFormatter dateFromString:endOfTodayString];
    
    NSTimeInterval interval = [endOfTodayDate timeIntervalSinceDate:currentDate];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int remindInterval = [[defaults objectForKey:kTimeInterval] intValue];
    
    int countOfReminder = interval / (remindInterval*60*60);
    NSLog(@"countOFReminder:%i %s",countOfReminder,__func__);
    
    return countOfReminder;
    
}
- (NSString *)messageForReminderWith:(Promise *)promise
{
    //要修正、文章が長過ぎて入らない
     //５行目の途中で切れちゃってる
    //現在doingのpromise
    //settingから呼び出すので、引数は無理→contextから呼び出す

    
    NSMutableArray *actionsArray = [self setActionsArrayWith:promise];
    
    NSString *preMessage = NSLocalizedString(@"To do today", nil);
    NSString *actionString = nil;
    for (int i = 0; i < [actionsArray count]; i++) {
        if([[actionsArray objectAtIndex:i] valueForKey:@"action"]){
            actionString = [@"\n•" stringByAppendingString:[[actionsArray objectAtIndex:i] valueForKey:@"action"]];
            //actionString = [@"\n" stringByAppendingString:@"Ken"];
            NSLog(@"actionString:%@",actionString);
            //bodyに追加
            preMessage = [preMessage stringByAppendingString:actionString];
            actionString = nil;
        }
        
    }
    //NSString *message = [preMessage stringByAppendingString:NSLocalizedString(@"\n",nil)];
    //NSLog(@"message:%@",message);
    //return message;
    return preMessage;
    
}

- (Promise *)promiseForReminder 
{
    //一番新しいpromiseをセットする
    Promise *promise = nil;
    
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Promise" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
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
    
    if (![[aFetchedResultsController fetchedObjects] count] == 0) {
        promise = [[aFetchedResultsController fetchedObjects] objectAtIndex:0];
    }
    
    /*Ken
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptors release];
    [sortDescriptor release];
     */
    
    NSLog(@"promise.state  %@ in %s",[promise valueForKey:@"state"], __func__);
    
    return promise;
    
}

- (NSMutableArray *)setActionsArrayWith:(Promise *)promise
{
    //promiseがない、もしくは実行済みの場合はnilを
    //promiseがあり、Doingの場合のみ、該当するactionsArrayを返す
    NSMutableArray *array = [NSMutableArray array];
    if (promise) {
        if ([promise.state isEqualToString:kPromiseStateDoing]) {
            
            NSManagedObjectContext *context = self.managedObjectContext;
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Action"
                                                      inManagedObjectContext:context];
            [fetchRequest setEntity:entity];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"promise == %@", promise];
            [fetchRequest setPredicate:predicate];
            //[predicate release];//リリースすると落ちる
            
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"action"
                                                                           ascending:YES];
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
            [fetchRequest setSortDescriptors:sortDescriptors];
            
            NSError *error = nil;
            NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
            if (fetchedObjects == nil) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                exit(-1);  // Fail
            }
            
            array = [fetchedObjects mutableCopy];
            
            //[fetchedObjects release];//サンプルではリリースしない
            /*Ken
            [fetchRequest release];
            [sortDescriptor release];
            [sortDescriptors release];
             */
            
        }
    }
    
    return array;
    
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

#pragma mark - Language
-(BOOL)isJapanese
{
    BOOL isJapanese;
    NSUserDefaults *defs = [NSUserDefaults  standardUserDefaults];
    NSArray *languages = [defs objectForKey:@"AppleLanguages"];
    NSString *preferredLang = [languages objectAtIndex:0];
    if ([preferredLang isEqualToString:@"ja"]) {
        isJapanese = YES;
    } else {
        isJapanese = NO;
    }
    return isJapanese;
}
@end
