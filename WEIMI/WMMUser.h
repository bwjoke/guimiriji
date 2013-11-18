//
//  WMMUser.h
//  WEIMI
//
//  Created by King on 3/7/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "NKMUser.h"

@interface WMMUser : NKMUser

@property (nonatomic, retain) NSDate   *createTime;
@property (nonatomic, retain) NSNumber *virtual_user;
@property (nonatomic) BOOL noSMS;

@end
