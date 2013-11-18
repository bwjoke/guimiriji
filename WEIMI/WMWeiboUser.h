//
//  WMWeiboUser.h
//  WEIMI
//
//  Created by steve on 13-5-24.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMModel.h"

@interface WMWeiboUser : WMModel

@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSString *weiboId;
@property(nonatomic,assign) BOOL hasInvited;
@property(nonatomic,assign) BOOL localHasInvited;
@property(nonatomic,retain) NSString *avatarPath;
@property(nonatomic,retain) UIImage *avatar;
@end
