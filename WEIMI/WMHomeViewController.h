//
//  WMHomeViewController.h
//  WEIMI
//
//  Created by King on 10/24/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"
#import "WMInviteMiViewController.h"
#import "WMMiViewController.h"
#import "WMFollowedMenViewController.h"

@interface WMHomeViewController : WMTableViewController <WMInviteDelegate, WMMiViewControllerDelegate>{

    UIView *avatarContainer;
    UIView *contentContainer;
    
    WMInviteMiViewController *inviteViewController;
    WMMiViewController *miViewController;
    
    UIScrollView *bookScrollView;
    
}

@property (nonatomic, assign) UIView *avatarContainer;
@property (nonatomic, assign) UIView *contentContainer;

@property (nonatomic, retain) WMInviteMiViewController *inviteViewController;
@property (nonatomic, retain) WMMiViewController *miViewController;
@property (nonatomic, retain) WMFollowedMenViewController *followedMenViewController;

@property (nonatomic, assign) UIScrollView *bookScrollView;

@end
