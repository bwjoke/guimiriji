//
//  WMNotificationCenter.h
//  WEIMI
//
//  Created by King on 4/25/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "NKNotificationCenter.h"

@interface WMNotificationCenter : NKNotificationCenter


@property (nonatomic, retain) NSNumber *hasRequest;
@property (nonatomic, retain) NSNumber *hasNotification;
@property (nonatomic, retain) NSNumber *hasNewFeed;
@property (nonatomic, retain) NSNumber *hasNewMan;
@property (nonatomic, retain) NSNumber *hasNewMessage;

@property (nonatomic, retain) NSDictionary *feedDic;
@property (nonatomic, retain) NSDictionary *manDic;
@property (nonatomic, retain) NSDictionary *imDic;

@property (nonatomic)int numOfNotics;


-(void)getNotificationsCountDelay;

-(void)getNotificationsCount;
@end
