//
//  WMSistersViewController.h
//  WEIMI
//
//  Created by steve on 13-6-20.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"
#import "WMInviteMiViewController.h"
#import "WMMiViewController.h"
#import "WMHoneyView.h"

@interface WMSistersViewController : WMTableViewController<WMHoneyViewDelegate,WMInviteDelegate, WMMiViewControllerDelegate>

@property (nonatomic, assign) UIView *contentContainer;
@property (nonatomic, retain) WMInviteMiViewController *inviteViewController;
@property (nonatomic, retain) WMMiViewController *miViewController;
@end
