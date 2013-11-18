//
//  WMUserService.h
//  WEIMI
//
//  Created by King on 3/7/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "NKUserService.h"
#import "WMMUser.h"

@interface WMUserService : NKUserService

dshared(WMUserService);

-(NKRequest*)getUserOauthsWithRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)inviteUserWithAccount:(NSString*)account andRequestDelegate:(NKRequestDelegate*)rd;
-(NKRequest*)cancelInviteUserWithAccount:(NSString*)account andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)getFriendsWithUID:(NSString*)uid andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)getRelatedUsersWithUID:(NSString*)uid andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest *)setUserAvatar:(NSData *)avatar andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest *)setUserName:(NSString *)name andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest *)setUserMobile:(NSString *)name andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest *)setTopicnick:(NSString *)topicnick andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest *)addFriend:(NSString *)uid from:(NSString *)from andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest *)cancleFriend:(NSString *)uid andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest *)getNotificationCountWithRequestDelegate:(NKRequestDelegate*)rd;

- (NKRequest *)getUserInfoWithRequestDelegate:(NKRequestDelegate*)rd;

- (NKRequest *)getUserInfoByID:(NSString *)uid WithRequestDelegate:(NKRequestDelegate*)rd;

- (NKRequest *)updateUnivWithRequestDelegate:(NKRequestDelegate*)rd univ_id:(NSString *)univ_id;

@end
