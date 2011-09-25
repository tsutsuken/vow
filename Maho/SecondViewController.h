//
//  SecondViewController.h
//  Maho
//
//  Created by 堤 健 on 11/04/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <TapkuLibrary/TapkuLibrary.h>

#import "ActionsViewController.h"

@class Promise,Action;

@interface SecondViewController : TKCalendarMonthTableViewController {
	NSMutableArray *dataArray; 
	NSMutableDictionary *dataDictionary;
    Promise *promise;
    Action *action;
    NSDateFormatter *dateFormatter;
}
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (retain,nonatomic) NSMutableArray *dataArray;
@property (retain,nonatomic) NSMutableDictionary *dataDictionary;
@property (nonatomic, retain) Promise *promise;
@property (nonatomic, retain) Action *action;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;

- (void)generateRandomDataForStartDate:(NSDate*)start endDate:(NSDate*)end;
-(void)setNotificationCenter;

@end
