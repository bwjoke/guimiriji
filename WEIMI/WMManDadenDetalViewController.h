//
//  WMManDadenDetalViewController.h
//  WEIMI
//
//  Created by steve on 13-5-23.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//
@protocol WMManDafenDelegate <NSObject>

@optional
-(void)shouldRefreshData;

@end

#import "WMTableViewController.h"
#import "WMManFeedCell.h"
#import "WMBaoliaoXiangqingViewController.h"

@interface WMManDadenDetalViewController : WMTableViewController<WMBaoliaoXiangqingDelegate,WMManFeedCellDelegate,UIActionSheetDelegate>

@property (nonatomic, retain) WMMMan *man;

@property (nonatomic)BOOL shouldGetNotification;
@property (nonatomic, assign) id<WMManDafenDelegate>delegate;
@end
