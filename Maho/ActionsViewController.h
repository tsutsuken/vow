//
//  ActionsViewController.h
//  vow
//
//  Created by 堤 健 on 11/05/26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Promise,Action;

@interface ActionsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>{
    
    IBOutlet UITableView *actionTableView;
    Promise *promise;
    Action *action;
    NSMutableArray *actionsArray;
    NSDateFormatter *dateFormatter;
    
}
@property (nonatomic, retain) IBOutlet UITableView *actionTableView;
@property (nonatomic, retain) Promise *promise;
@property (nonatomic, retain) Action *action;
@property (nonatomic, retain) NSMutableArray *actionsArray;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;

- (void)setActionsArray;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
