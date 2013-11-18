//
//  NKUserService.m
//  WEIMI
//
//  Created by King on 11/14/12.
//  Copyright (c) 2012 NK.COM. All rights reserved.
//

#import "NKUserService.h"

@implementation NKUserService


-(void)dealloc{
    [super dealloc];
}

$singleService(NKUserService, @"user");


static NSString *const NKAPIGetUser = @"/get";
-(NKRequest*)getUserWithUID:(NSString*)uid andRequestDelegate:(NKRequestDelegate*)rd{
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], NKAPIGetUser];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[NKMUser class] resultType:NKResultTypeSingleObject andResultKey:@""];
    
    if (uid) {
        [newRequest addPostValue:uid forKey:@"id"];
    }

    [self addRequest:newRequest];
    return newRequest;
    
}

static NSString *const NKAPIListUser = @"/li";
-(NKRequest*)listUserWithUIDs:(NSArray*)uids andRequestDelegate:(NKRequestDelegate*)rd{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], NKAPIListUser];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[NKMUser class] resultType:NKResultTypeArray andResultKey:@""];
    
    for (NSString *uid in uids) {
         [newRequest addPostValue:uid forKey:@"id"];
    }

    [self addRequest:newRequest];
    return newRequest;
    
}

static NSString *const NKAPIFollowUser = @"/follow";
-(NKRequest*)followUserWithUID:(NSString*)uid andRequestDelegate:(NKRequestDelegate*)rd{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], NKAPIFollowUser];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[NKMUser class] resultType:NKResultTypeSingleObject andResultKey:@""];
    
    if (uid) {
        [newRequest addPostValue:uid forKey:@"id"];
    }
    
    [self addRequest:newRequest];
    return newRequest;
    
}


static NSString *const NKAPIUNFollowUser = @"/del_friend";
-(NKRequest*)unFollowUserWithUID:(NSString*)uid andRequestDelegate:(NKRequestDelegate*)rd{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], NKAPIUNFollowUser];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[NKMUser class] resultType:NKResultTypeSingleObject andResultKey:@""];
    
    if (uid) {
        [newRequest addPostValue:uid forKey:@"friendid"];
    }
    
    [self addRequest:newRequest];
    return newRequest;
    
}

static NSString *const NKAPIInvite = @"/invite";
-(NKRequest*)inviteUserWithEmail:(NSString*)email andRequestDelegate:(NKRequestDelegate*)rd{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], NKAPIInvite];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[NKMUser class] resultType:NKResultTypeSingleObject andResultKey:@""];
    
    if (email) {
        [newRequest addPostValue:email forKey:@"email"];
    }
    
    [self addRequest:newRequest];
    return newRequest;
    
    
}

static NSString *const NKAPIListFriends = @"/friend_list";
-(NKRequest*)listFriendsWithUID:(NSString*)uid andRequestDelegate:(NKRequestDelegate*)rd{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], NKAPIListFriends];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[NKMUser class] resultType:NKResultTypeArray andResultKey:@""];
    
    if (uid) {
        [newRequest addPostValue:uid forKey:@"id"];
    }
    
    [self addRequest:newRequest];
    return newRequest;
    
    
}

static NSString *const NKAPISetAvatar = @"/avatar";
-(NKRequest*)setAvatarWithAvatar:(NSData*)avatar avatarPath:(NSString*)avatarPath andRequestDelegate:(NKRequestDelegate*)rd{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], NKAPIListFriends];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[NKMUser class] resultType:NKResultTypeSingleObject andResultKey:@""];
    
    if (avatar) {
        [newRequest addData:avatar withFileName:@"avatar.jpg" andContentType:@"image/jpeg" forKey:@"avatar"];
    }
    
    if (avatarPath) {
        [newRequest addPostValue:avatarPath forKey:@"avatarPath"];
    }
    
    [self addRequest:newRequest];
    return newRequest;
}


#pragma mark Login
static NSString *const NKAPILogin = @"/login";
-(NKRequest*)loginWithUsername:(NSString*)username password:(NSString*)password andRequestDelegate:(NKRequestDelegate*)rd{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], NKAPILogin];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[NKMUser class] resultType:NKResultTypeSingleObject andResultKey:@""];
    [newRequest addPostValue:username forKey:@"account"];
    [newRequest addPostValue:password forKey:@"password"];
    
    [self addRequest:newRequest];
    
    
    return newRequest;
    
}

static NSString *const NKAPILogout = @"/logout";
-(NKRequest*)logoutWithRequestDelegate:(NKRequestDelegate*)rd{
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], NKAPILogout];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[NKMActionResult class] resultType:NKResultTypeSingleObject andResultKey:@""];
    
    [self addRequest:newRequest];
    
    
    return newRequest;
    
    
}


#pragma mark Share
static NSString *const NKAPIShareBind = @"/oauth_bind";
-(NKRequest*)socialBindWithType:(NSString*)type uid:(NSString*)uid token:(NSString*)token andRequestDelegate:(NKRequestDelegate*)rd{
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], NKAPIShareBind];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:nil resultType:NKResultTypeOrigin andResultKey:@""];
    
    [newRequest addPostValue:type forKey:@"type"];
    [newRequest addPostValue:uid forKey:@"uid"];
    [newRequest addPostValue:token forKey:@"token"];
    
    [self addRequest:newRequest];
    
    return newRequest;
    
}

#pragma mark Share
static NSString *const NKAPIShareUnBind = @"/oauth_unbind";
-(NKRequest*)socialUnbindWithType:(NSString*)type andRequestDelegate:(NKRequestDelegate*)rd{
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], NKAPIShareUnBind];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:nil resultType:NKResultTypeOrigin andResultKey:@""];
    
    [newRequest addPostValue:type forKey:@"type"];
    
    [self addRequest:newRequest];
    
    return newRequest;
    
}

static NSString *const NKAPISocialLogin = @"/oauth_login_without_emailpass";
-(NKRequest*)socialLoginWithType:(NSString*)type
                         oauthID:(NSString*)oauthID
                           token:(NSString*)token
                           uname:(NSString*)uname
              andRequestDelegate:(NKRequestDelegate*)rd{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], NKAPISocialLogin];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[NKMUser class] resultType:NKResultTypeOrigin andResultKey:@""];
    
    [newRequest addPostValue:type forKey:@"type"];
    [newRequest addPostValue:oauthID forKey:@"uid"];
    [newRequest addPostValue:token forKey:@"token"];
    
    if (uname != nil) {
        [newRequest addPostValue:uname forKey:@"uname"];
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const NKAPISocialRegister = @"/oauth_register";
-(NKRequest*)socialRegisterWithType:(NSString*)type
                            oauthID:(NSString*)oauthID
                              token:(NSString*)token
                            account:(NSString*)account
                           password:(NSString*)password
                              uname:(NSString*)uname
                 andRequestDelegate:(NKRequestDelegate*)rd{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], NKAPISocialRegister];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[NKMUser class] resultType:NKResultTypeSingleObject andResultKey:@""];
    
    [newRequest addPostValue:type forKey:@"type"];
    [newRequest addPostValue:oauthID forKey:@"oauth_id"];
    [newRequest addPostValue:token forKey:@"token"];
    [newRequest addPostValue:account forKey:@"account"];
    [newRequest addPostValue:password forKey:@"password"];
    
    if (uname != nil) {
        [newRequest addPostValue:uname forKey:@"uname"];
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const NKAPISocialReginvite = @"/reginvite";
-(NKRequest *)socialReginvite:(NSString *)mobile uid:(NSString *)uid friendAcount:(NSString *)number andRequestDelegate:(NKRequestDelegate*)rd
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], NKAPISocialReginvite];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[NKMUser class] resultType:NKResultTypeSingleObject andResultKey:@""];
    
    [newRequest addPostValue:mobile forKey:@"mobile"];
    
    if (number != nil) {
        [newRequest addPostValue:number forKey:@"friend_account"];
    }
    
    if (uid) {
        [newRequest addPostValue:uid forKey:@"uid"];
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const NKAPISocialEmail = @"/save_male_email";
-(NKRequest *)socialEmail:(NSString *)email andRequestDelegate:(NKRequestDelegate*)rd
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], NKAPISocialEmail];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[NKMUser class] resultType:NKResultTypeOrigin andResultKey:@""];
    
    
    if (email != nil) {
        [newRequest addPostValue:email forKey:@"email"];
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
}

@end
