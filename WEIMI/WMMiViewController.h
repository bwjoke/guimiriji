//
//  WMMiViewController.h
//  WEIMI
//
//  Created by King on 11/19/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//
#import <MessageUI/MFMessageComposeViewController.h>
#import "WMTableViewController.h"
#import "WMAddMiyuViewController.h"
#import "WMHoneyRequestViewController.h"
#import "WMFeedDetailViewController.h"
#import "WMFeedCell.h"
#import "WMFeedCell2.h"

#import "WMConverstionViewController.h"
#import "WMNotificationCenter.h"

@protocol WMMiViewControllerDelegate;

@interface WMMiViewController : WMTableViewController<WMFeedCellDelegate, WMFeedCell2Delegate,WMAddMiyuViewControllerDelegate,WMHoneyRequestDelegate,WMFeedDetailDelegate,UIAlertViewDelegate,MFMessageComposeViewControllerDelegate,WMConverstionViewControllerDelegate>{
    
    WMMUser *user;
    UILabel *unreadLabel;
    UIImageView *msgIcon;
    BOOL showHeaderInSection;
    
}

@property (nonatomic, retain) WMMUser *user;
@property (nonatomic, assign) id<WMMiViewControllerDelegate> delegate;

@end


@protocol WMMiViewControllerDelegate <NSObject>

@optional

-(void)controller:(WMMiViewController*)controller didUnfollowUser:(WMMUser*)user;

-(void)controller:(WMMiViewController*)controller didfollowUser:(WMMUser*)user;
@end