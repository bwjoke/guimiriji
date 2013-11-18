//
//  NKMAccount.h
//  NEXTKING
//
//  Created by King on 10/24/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//

#import "NKMUser.h"

extern NSString *const NKWillLogoutNotificationKey;
extern NSString *const NKLoginFinishNotificationKey;

extern NSString *const NKAccountTypeOrigin;
extern NSString *const NKAccountTypeWeibo;
extern NSString *const NKAccountTypeRenren;
extern NSString *const NKAccountTypeTqq;

@interface NKMAccount : NKMUser{
    
    // password, should We store the password here
    NSString *account; // Do not use it here now
    NSString *password;
    
    NSNumber *shouldSavePassword;
    NSNumber *shouldAutoLogin;
    
    NSString *oauthID;
    NSString *accessToken;
    
    NSString *accountType;
}
@property (nonatomic, retain) NSString *account;
@property (nonatomic, retain) NSString *password;

@property (nonatomic, retain) NSNumber *shouldSavePassword;
@property (nonatomic, retain) NSNumber *shouldAutoLogin;

@property (nonatomic, retain) NSString *oauthID;
@property (nonatomic, retain) NSString *accessToken;

@property (nonatomic, retain) NSString *accountType;
@property (nonatomic, retain) NSMutableDictionary *oauth;

+(id)accountFromLocalDic:(NSDictionary*)dic;
+(id)accountWithAccount:(NSString*)aloginName password:(NSString*)apassword andShouldAutoLogin:(NSNumber*)autoLogin;

-(NSDictionary*)persistentDic;


+(id)registerAccount;
+(id)cleanRegisterAccout;

@end
