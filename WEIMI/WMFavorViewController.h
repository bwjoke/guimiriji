//
//  WMFavorViewController.h
//  WEIMI
//
//  Created by King on 4/7/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"
#import "WMHoneyView.h"
#import "WMInviteMiViewController.h"
#import "WMMiViewController.h"
#import "WMFollowedMenViewController.h"
#import "WMMiViewController.h"

@interface WMFavorViewController : WMTableViewController<WMHoneyViewDelegate,WMInviteDelegate,WMMiViewControllerDelegate>

@property (nonatomic, assign) UIView *contentContainer;
@property (nonatomic, retain) WMInviteMiViewController *inviteViewController;

@property (nonatomic, retain) WMFollowedMenViewController *followedMenViewController;
@property (nonatomic, retain) WMMiViewController *miViewController;
@end
