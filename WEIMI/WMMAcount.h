//
//  WMAcount.h
//  WEIMI
//
//  Created by steve on 13-4-25.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMMUser.h"

@interface WMMAcount : WMMUser


@property(nonatomic,retain)NSString *loginNmae,*password,*loginEmail,*accessToken,*headeUrl,*phoneNumber,*oauthId,*type, *socialID;

+(id)shareAcount;

+(id)clean;
@end
