//
//  WMHoneyRequestViewController.h
//  WEIMI
//
//  Created by steve on 13-4-11.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//
@protocol WMHoneyRequestDelegate <NSObject>

@optional
-(void)didFollow;

-(void)didUnFollow;

@end

#import "WMTableViewController.h"

@interface WMHoneyRequestViewController : WMTableViewController<UIAlertViewDelegate>

@property(nonatomic,retain)WMMUser *user;
@property(nonatomic,assign)NKKVOImageView *avatarView;
@property(nonatomic,assign)id<WMHoneyRequestDelegate>delegate;
@property(nonatomic)BOOL showHeaderBar;
@end
