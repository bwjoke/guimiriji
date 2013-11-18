//
//  WMOauthViewController.h
//  WEIMI
//
//  Created by steve on 13-9-23.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"
#import "WMOauthCell.h"
#import "WMBindDetailViewController.h"
#import "RennSDK/RennSDK.h"
#import "NKSocial.h"
#import <ShareSDK/ShareSDK.h>

@interface WMOauthViewController : WMTableViewController<WMBindDetailViewDelegate, RennLoginDelegate,TencentLoginDelegate>

@property (nonatomic, copy) void(^goBackAction)(void);

@end
