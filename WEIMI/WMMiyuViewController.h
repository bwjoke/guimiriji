//
//  WMMiyuViewController.h
//  WEIMI
//
//  Created by King on 4/7/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"
#import "WMHoneyView.h"
#import "WMInviteMiViewController.h"
#import "WMMiViewController.h"


@interface WMMiyuViewController : WMTableViewController<WMHoneyViewDelegate,WMInviteDelegate, WMMiViewControllerDelegate>
{
//    WMInviteMiViewController *inviteViewController;
//    WMMiViewController *miViewController;
//    
//    UIView *contentContainer;
}
@property (nonatomic, assign) UIView *contentContainer;
@property (nonatomic, retain) WMInviteMiViewController *inviteViewController;
@property (nonatomic, retain) WMMiViewController *miViewController;

@end
