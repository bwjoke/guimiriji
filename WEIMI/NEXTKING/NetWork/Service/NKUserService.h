//
//  NKUserService.h
//  WEIMI
//
//  Created by King on 11/14/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//

#import "NKServiceBase.h"

@interface NKUserService : NKServiceBase


dshared(NKUserService);

-(NKRequest*)getUserWithUID:(NSString*)uid andRequestDelegate:(NKRequestDelegate*)rd;
-(NKRequest*)listUserWithUIDs:(NSArray*)uids andRequestDelegate:(NKRequestDelegate*)rd;


-(NKRequest*)followUserWithUID:(NSString*)uid andRequestDelegate:(NKRequestDelegate*)rd;
-(NKRequest*)unFollowUserWithUID:(NSString*)uid andRequestDelegate:(NKRequestDelegate*)rd;


-(NKRequest*)listFriendsWithUID:(NSString*)uid andRequestDelegate:(NKRequestDelegate*)rd;
-(NKRequest*)inviteUserWithEmail:(NSString*)email andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)setAvatarWithAvatar:(NSData*)avatar avatarPath:(NSString*)avatarPath andRequestDelegate:(NKRequestDelegate*)rd;

#pragma mark Login/Logout

-(NKRequest*)loginWithUsername:(NSString*)username password:(NSString*)password andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)logoutWithRequestDelegate:(NKRequestDelegate*)rd;


#pragma mark Share
-(NKRequest*)socialBindWithType:(NSString*)type uid:(NSString*)uid token:(NSString*)token andRequestDelegate:(NKRequestDelegate*)rd;
-(NKRequest*)socialUnbindWithType:(NSString*)type andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)socialLoginWithType:(NSString*)type
                         oauthID:(NSString*)oauthID
                           token:(NSString*)token
                           uname:(NSString*)uname
              andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)socialRegisterWithType:(NSString*)type
                            oauthID:(NSString*)oauthID
                              token:(NSString*)token
                            account:(NSString*)account
                           password:(NSString*)password
                              uname:(NSString*)uname
                 andRequestDelegate:(NKRequestDelegate*)rd;


-(NKRequest *)socialReginvite:(NSString *)mobile uid:(NSString *)uid friendAcount:(NSString *)number andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest *)socialEmail:(NSString *)email andRequestDelegate:(NKRequestDelegate*)rd;
@end
