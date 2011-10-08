//
//  CheckBoxTableViewCell.h
//  vow
//
//  Created by 堤 健 on 11/10/03.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckBoxTableViewCell : UITableViewCell{
    
    UIButton *checkBox;
    UILabel *label;
    
}

@property (nonatomic, retain) IBOutlet UIButton *checkBox;
@property (nonatomic, retain) IBOutlet UILabel *label;
@end
