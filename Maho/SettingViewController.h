//
//  SettingViewController.h
//  Maho
//
//  Created by 堤 健 on 11/03/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "CopyrightViewController.h"
#import "ReminderViewController.h"

@protocol SettingViewControllerDelegate;
@interface SettingViewController : UITableViewController<MFMailComposeViewControllerDelegate,ReminderViewControllerDelegate>{
    id <SettingViewControllerDelegate> delegate;
    NSArray *timeIntervalArray;
}
@property (nonatomic, assign) id <SettingViewControllerDelegate> delegate;
@property(nonatomic,retain) NSArray *timeIntervalArray;

-(void)showSupportSite;
-(void)setEmail;
-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;
-(BOOL)isJapanese;
-(void)showCopyrightView;
-(void)showReminderView;

@end

@protocol SettingViewControllerDelegate
- (void)settingViewControllerDidFinish:(SettingViewController *)controller;
@end
