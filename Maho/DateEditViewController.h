//
//  DateEditViewController.h
//  Oath
//
//  Created by 堤 健 on 11/03/19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DateEditViewController : UIViewController {
    UIDatePicker *datePicker;
    NSManagedObject *editedObject;
    NSString *editedFieldKey;
    NSString *editedFieldName;
    NSDateFormatter *dateFormatter;
}
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) NSManagedObject *editedObject;
@property (nonatomic, retain) NSString *editedFieldKey;
@property (nonatomic, retain) NSString *editedFieldName;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;

@end
