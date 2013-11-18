//
//  NKSocial.h
//  ZUO
//
//  Created by King on 12/29/12.
//  Copyright (c) 2012 King. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>

#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
#import "SinaWeiboConstants.h"
#import "NKRequest.h"
#import "NKWeiboRequest.h"

#import "Renren.h"

extern NSString *const NKSocialServiceTypeSinaWeibo;
extern NSString *const NKSocialServiceTypeTqq;
extern NSString *const NKSocialServiceTypeRenren;

@interface NKSocial : NSObject <SinaWeiboDelegate,
                                SinaWeiboRequestDelegate,
                                TencentSessionDelegate,RenrenDelegate> {
    
    SinaWeibo *sinaWeibo;
    
    NKRequestDelegate *loginRD;
    
}

@property (nonatomic, retain) SinaWeibo *sinaWeibo;

@property (nonatomic, assign) NKRequestDelegate *loginRD;

@property (nonatomic, retain) NSString *socialType;

@property (nonatomic, retain) TencentOAuth *tqq;

@property (nonatomic, retain) NSString *renren_id;
@property (nonatomic, retain) NSString *renren_name;
@property (nonatomic, retain) NSString *renren_headurl;
@property (nonatomic, retain) NSString *renren_sex;

@property (nonatomic, retain) Renren *renren;

+(id)social;

-(SinaWeibo*)startSinaWeiboWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecrect
              appRedirectURI:(NSString *)appRedirectURI
                 andDelegate:(id<SinaWeiboDelegate>)delegate;

-(TencentOAuth*)startTqqWithAppKey:(NSString *)appKey
                    appRedirectURI:(NSString *)appRedirectURI
                       andDelegate:(id<TencentSessionDelegate>)delegate;

-(void)loginWithSinaWeiboWithRequestDelegate:(NKRequestDelegate*)rd;
-(void)loginWithTqqWithRequestDelegate:(NKRequestDelegate*)rd;

-(void)loginWithRenrenWithRequestDelegate:(NKRequestDelegate *)rd;

-(NKWeiboRequest*)sinaRequestWithURL:(NSString *)url
                      httpMethod:(NSString *)httpMethod
                          params:(NSDictionary *)params
                 requestDelegate:(NKRequestDelegate*)rd;


- (BOOL)handleAppDelegateOpenURL:(NSURL *)url;

- (void)getTqqUserInfoWithDelegate:(NKRequestDelegate *)rd;

-(void)removeSocial;


@end
