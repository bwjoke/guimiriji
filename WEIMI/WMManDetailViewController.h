//
//  WMManDetailViewController.h
//  WEIMI
//
//  Created by King on 11/22/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//
@protocol WMManDetailDelegate <NSObject>

@optional
-(void)shouldReload;

@end

#import "WMTableViewController.h"
#import "WMManFeedCell.h"
#import "WMBaoliaoXiangqingViewController.h"
#import "WMManDadenDetalViewController.h"
#import "WMInviteFriendsViewController.h"
#import "WMRelationViewController.h"
#import "WMInterestViewController.h"

@interface WMManDetailViewController : WMTableViewController<WMBaoliaoXiangqingDelegate,WMManFeedCellDelegate,WMManDafenDelegate,UIActionSheetDelegate,WMRelationViewControllerDelegate, WMCharacterViewControllerDelegate>
{
    
}

@property (nonatomic, retain) WMMMan *man;

@property (nonatomic)BOOL shouldGetNotification;

@property (nonatomic)BOOL shouldNotBackToRoot;

@property (nonatomic)BOOL isFromUniversity;

@property (nonatomic, assign) UIButton *followButton;

@property (nonatomic, retain)id<WMManDetailDelegate>delegate;


+(id)manDetailWithMan:(WMMMan*)man;
-(void)addTableViewHeader;

@end
