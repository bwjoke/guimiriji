//
//  WMUserService.m
//  WEIMI
//
//  Created by King on 3/7/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMUserService.h"

@implementation WMUserService


-(void)dealloc{
    [super dealloc];
}

$singleService(WMUserService, @"user");

#pragma mark Share
static NSString *const NKAPIGetOauths = @"/oauths";
-(NKRequest*)getUserOauthsWithRequestDelegate:(NKRequestDelegate*)rd{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], NKAPIGetOauths];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:nil resultType:NKResultTypeOrigin andResultKey:@""];
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPIInviteFriend = @"/invite_friend";
-(NKRequest*)inviteUserWithAccount:(NSString*)account andRequestDelegate:(NKRequestDelegate*)rd{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIInviteFriend];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMUser class] resultType:NKResultTypeSingleObject andResultKey:@""];
    
    if (account) {
        [newRequest addPostValue:account forKey:@"account"];
    }
    
    [self addRequest:newRequest];
    return newRequest;
    
}

static NSString *const WMAPICancelInviteFriend = @"/cancel_invite_friend";
-(NKRequest*)cancelInviteUserWithAccount:(NSString*)account andRequestDelegate:(NKRequestDelegate*)rd{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPICancelInviteFriend];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMUser class] resultType:NKResultTypeSingleObject andResultKey:@""];
    
    if (account) {
        [newRequest addPostValue:account forKey:@"account"];
    }
    
    [self addRequest:newRequest];
    return newRequest;
}


static NSString *const WMAPIGetFriends = @"/get_friends";
-(NKRequest*)getFriendsWithUID:(NSString*)uid andRequestDelegate:(NKRequestDelegate*)rd{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIGetFriends];
    
    if (uid) {
        urlString = [urlString stringByAppendingFormat:@"?uid=%@", uid];
    }
    
    NKRequest *newRequest = [NKRequest getRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMUser class] resultType:NKResultTypeArray andResultKey:@""];
    [self addRequest:newRequest];
    return newRequest;
    
}

static NSString *const WMAPIGetRelatedUsers = @"/get_related_users";
-(NKRequest*)getRelatedUsersWithUID:(NSString*)uid andRequestDelegate:(NKRequestDelegate*)rd{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIGetRelatedUsers];
    
    if (uid) {
        urlString = [urlString stringByAppendingFormat:@"?uid=%@", uid];
    }
    
    NKRequest *newRequest = [NKRequest getRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMUser class] resultType:NKResultTypeArray andResultKey:@""];
    [self addRequest:newRequest];
    return newRequest;
    
}

static NSString *const WMAPISetUserAvatar = @"/avatar_upload";
-(NKRequest *)setUserAvatar:(NSData *)avatar andRequestDelegate:(NKRequestDelegate*)rd;
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPISetUserAvatar];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMUser class] resultType:NKResultTypeOrigin andResultKey:@""];
    
    if (avatar) {
        [newRequest addData:avatar withFileName:@"avatar.jpg" andContentType:@"image/jpeg" forKey:@"avatar"];
    }
    
    [self addRequest:newRequest];
    return newRequest;
}

static NSString *const WMAPISetUserName = @"/update_nick";
-(NKRequest *)setUserName:(NSString *)name andRequestDelegate:(NKRequestDelegate*)rd;
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPISetUserName];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[NKMUser class] resultType:NKResultTypeSingleObject andResultKey:@""];
    
    if (name) {
        [newRequest addPostValue:name forKey:@"nickname"];
    }
    
    [self addRequest:newRequest];
    return newRequest;
}

static NSString *const WMAPISetUserMobile = @"/update_mobile";
-(NKRequest *)setUserMobile:(NSString *)name andRequestDelegate:(NKRequestDelegate*)rd;
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPISetUserMobile];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[NKMUser class] resultType:NKResultTypeSingleObject andResultKey:@""];
    
    if (name) {
        [newRequest addPostValue:name forKey:@"mobile"];
    }
    
    [self addRequest:newRequest];
    return newRequest;
}

static NSString *const WMAPISetTopicnick = @"/update_topicnick";
-(NKRequest *)setTopicnick:(NSString *)topicnick andRequestDelegate:(NKRequestDelegate*)rd;
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPISetTopicnick];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[NKMUser class] resultType:NKResultTypeSingleObject andResultKey:@""];
    
    if (topicnick) {
        [newRequest addPostValue:topicnick forKey:@"nickname"];
    }
    
    [self addRequest:newRequest];
    return newRequest;
}

static NSString *const WMAPIaddFriend= @"/add_friend";
-(NKRequest *)addFriend:(NSString *)uid from:(NSString *)from andRequestDelegate:(NKRequestDelegate*)rd;
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIaddFriend];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[NKMUser class] resultType:NKResultTypeSingleObject andResultKey:@""];
    
    if (uid) {
        [newRequest addPostValue:uid forKey:@"friendid"];
    }
    
    if (from) {
        [newRequest addPostValue:from forKey:@"from"];
    }
    
    [self addRequest:newRequest];
    return newRequest;
}

static NSString *const WMAPIcancleFriend = @"/cancel_friend";
-(NKRequest *)cancleFriend:(NSString *)uid andRequestDelegate:(NKRequestDelegate*)rd;
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIcancleFriend];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[NKMUser class] resultType:NKResultTypeSingleObject andResultKey:@""];
    
    if (uid) {
        [newRequest addPostValue:uid forKey:@"friendid"];
    }
    
    [self addRequest:newRequest];
    return newRequest;
}


static NSString *const WMAPIGetNotificationCount = @"/loop";
-(NKRequest *)getNotificationCountWithRequestDelegate:(NKRequestDelegate*)rd{
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIGetNotificationCount];
    NKRequest *newRequest = [NKRequest getRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:nil resultType:NKResultTypeOrigin andResultKey:@""];
    [self addRequest:newRequest];
    return newRequest;
}

static NSString *const WMAPIGetUserInfo = @"/get";
- (NKRequest *)getUserInfoWithRequestDelegate:(NKRequestDelegate*)rd {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIGetUserInfo];
    NKRequest *newRequest = [NKRequest getRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:nil resultType:NKResultTypeOrigin andResultKey:@""];
    [self addRequest:newRequest];
    return newRequest;
}

- (NKRequest *)getUserInfoByID:(NSString *)uid WithRequestDelegate:(NKRequestDelegate*)rd {
    NSString *urlString = [NSString stringWithFormat:@"%@%@?uid=%@",[self serviceBaseURL], WMAPIGetUserInfo,uid];
    NKRequest *newRequest = [NKRequest getRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:nil resultType:NKResultTypeOrigin andResultKey:@""];
    [self addRequest:newRequest];
    return newRequest;
}

static NSString *const WMAPIUpdateUniv = @"/update_univ";
- (NKRequest *)updateUnivWithRequestDelegate:(NKRequestDelegate*)rd univ_id:(NSString *)univ_id {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIUpdateUniv];
    NKRequest *newRequest = [NKRequest getRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:nil resultType:NKResultTypeOrigin andResultKey:@""];
    
    if (univ_id) {
        [newRequest addPostValue:univ_id forKey:@"univ_id"];
    }
    
    [self addRequest:newRequest];
    return newRequest;
}

@end
