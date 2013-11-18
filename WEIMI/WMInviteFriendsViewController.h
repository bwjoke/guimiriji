//
//  WMInviteFriendsViewController.h
//  WEIMI
//
//  Created by steve on 13-5-24.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"
#import "WMWeiboUserCell.h"

@interface WMInviteFriendsViewController : WMTableViewController<WMWeiboUserDelegate>

@property(nonatomic,retain)WMMMan *man;
@end
