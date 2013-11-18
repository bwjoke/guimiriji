//
//  KRShare.h
//  KRShareKit
//
//  Created by 519968211 on 13-1-9.
//  Copyright (c) 2013年 519968211. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KRShareAuthorizeView.h"
#import "KRShareRequest.h"

#define kSinaWeiboAppKey             @"596106848"
#define kSinaWeiboAppSecret          @"e4d68eee62327a4cb236233fb698fca6"
#define kSinaWeiboAppRedirectURI     @"http://www.weimi.com"

#define kTencentWeiboAppKey             nil
#define kTencentWeiboAppSecret          nil
#define kTencentWeiboAppRedirectURI     nil

#define kDoubanBroadAppKey             nil
#define kDoubanBroadAppSecret          nil
#define kDoubanBroadAppRedirectURI     nil

//#define kRenrenBroadAPPID              @"223954"
#define kRenrenBroadAppKey             @"321eebb062324cf1b73d7e7508d5298d"
#define kRenrenBroadAppSecret          @"f7fe5cfbcf3e4f679bb9fad12d93c79c"
#define kRenrenBroadAppRedirectURI     @"http://www.weimi.com"


typedef NS_ENUM (NSInteger,KRShareTarget)
{
    KRShareTargetSinablog = 0,
    KRShareTargetTencentblog = 1,
    KRShareTargetDoubanblog = 2,
    KRShareTargetRenrenblog = 3
};


@protocol KRShareDelegate;

@interface KRShare : NSObject <KRShareAuthorizeViewDelegate, KRShareRequestDelegate>
{
    KRShareTarget shareTarget;
    KRShare *instance;
    
    
    NSString *userID;
    NSString *accessToken;
    NSDate *expirationDate;
    id<KRShareDelegate> delegate;
    
    NSString *appKey;
    NSString *appSecret;
    NSString *appRedirectURI;
    NSString *ssoCallbackScheme;
    
    KRShareRequest *request;
    NSMutableSet *requests;
    BOOL ssoLoggingIn;
}

@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSString *accessToken;
@property (nonatomic, retain) NSDate *expirationDate;
@property (nonatomic, retain) NSString *refreshToken;
@property (nonatomic, retain) NSString *ssoCallbackScheme;
@property (nonatomic, assign) id<KRShareDelegate> delegate;
@property (nonatomic) KRShareTarget shareTarget;
@property (nonatomic, retain) NSString *appKey;
@property (nonatomic, retain) NSString *appSecret;
@property (nonatomic, retain) NSString *appRedirectURI;


+ (id)sharedInstanceWithTarget:(KRShareTarget)target;

- (id)initWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecrect
      appRedirectURI:(NSString *)appRedirectURI
         andDelegate:(id<KRShareDelegate>)delegate;

- (id)initWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecrect
      appRedirectURI:(NSString *)appRedirectURI
   ssoCallbackScheme:(NSString *)ssoCallbackScheme
         andDelegate:(id<KRShareDelegate>)delegate;


- (void)applicationDidBecomeActive;
- (BOOL)handleOpenURL:(NSURL *)url;

- (void)getAuthorData;
- (void)removeAuthData;

// Log in using OAuth Web authorization.
// If succeed, sinaweiboDidLogIn will be called.
- (void)logIn;

// Log out.
// If succeed, sinaweiboDidLogOut will be called.
- (void)logOut;

// Check if user has logged in, or the authorization is expired.
- (BOOL)isLoggedIn;
- (BOOL)isAuthorizeExpired;


// isLoggedIn && isAuthorizeExpired
- (BOOL)isAuthValid;

- (KRShareRequest*)requestWithURL:(NSString *)url
                             params:(NSMutableDictionary *)params
                         httpMethod:(NSString *)httpMethod
                           delegate:(id<KRShareRequestDelegate>)delegate;

@end


@protocol KRShareDelegate <NSObject>

@optional

- (void)KRShareDidLogIn:(KRShare *)sinaweibo;
- (void)KRShareDidLogOut:(KRShare *)sinaweibo;
- (void)KRShareLogInDidCancel:(KRShare *)sinaweibo;
- (void)KRShareWillBeginRequest:(KRShareRequest *)request;
- (void)krShare:(KRShare *)krShare logInDidFailWithError:(NSError *)error;
- (void)krShare:(KRShare *)krShare accessTokenInvalidOrExpired:(NSError *)error;

@end

extern BOOL KRShareIsDeviceIPad();
