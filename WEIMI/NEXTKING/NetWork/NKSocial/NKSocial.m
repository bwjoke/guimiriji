//
//  NKSocial.m
//  ZUO
//
//  Created by King on 12/29/12.
//  Copyright (c) 2012 King. All rights reserved.
//

#import "NKSocial.h"
#import "ROUserResponseItem.h"
#import "RennSDK/RennSDK.h"


NSString *const NKSocialServiceTypeSinaWeibo = @"SinaWeibo";
NSString *const NKSocialServiceTypeTqq = @"Tqq";
NSString *const NKSocialServiceTypeRenren = @"Renren";

@implementation NKSocial

@synthesize sinaWeibo;
@synthesize loginRD;


-(void)dealloc{
    
    [sinaWeibo release];
    
    [_socialType release];
    _socialType = nil;
    
    [_tqq release];
    _tqq = nil;
    
    [_renren release];
    
    [_renren_id release];
    [_renren_name release];
    [_renren_headurl release];
    [_renren_sex release];
    
    
    [super dealloc];
}


static NKSocial *_sharedSocial = nil;

+(id)social{
    
    if (!_sharedSocial) {
        _sharedSocial = [[self alloc] init];
    }
    return _sharedSocial;
}


-(SinaWeibo*)startSinaWeiboWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecrect
              appRedirectURI:(NSString *)appRedirectURI
                 andDelegate:(id<SinaWeiboDelegate>)delegate{
    
    self.sinaWeibo = [[[SinaWeibo alloc] initWithAppKey:appKey appSecret:appSecrect appRedirectURI:appRedirectURI andDelegate:delegate] autorelease];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        sinaWeibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        sinaWeibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        sinaWeibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }
    
    sinaWeibo.delegate = self;
    
    return self.sinaWeibo;
    
}

-(TencentOAuth*)startTqqWithAppKey:(NSString *)appKey
                    appRedirectURI:(NSString *)appRedirectURI
                       andDelegate:(id<TencentSessionDelegate>)delegate {
    // QQ delegate must not be nil at init
    //self.tqq = [[[TencentOAuth alloc] initWithAppId:appKey andDelegate:delegate] autorelease];
    self.tqq = [[[TencentOAuth alloc] initWithAppId:appKey andDelegate:self] autorelease];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *tqqInfo = [defaults objectForKey:@"TqqAuthData"];
    if ([tqqInfo objectForKey:@"AccessTokenKey"] && [tqqInfo objectForKey:@"ExpirationDateKey"] && [tqqInfo objectForKey:@"OpenId"])
    {
        self.tqq.accessToken = [tqqInfo objectForKey:@"AccessTokenKey"];
        self.tqq.expirationDate = [tqqInfo objectForKey:@"ExpirationDateKey"];
        self.tqq.openId = [tqqInfo objectForKey:@"OpenId"];
    }
    
    //self.tqq.sessionDelegate = self;
    
    return self.tqq;
}

#pragma mark Aouth

-(void)loginWithSinaWeiboWithRequestDelegate:(NKRequestDelegate*)rd{
    self.socialType = NKSocialServiceTypeSinaWeibo;
    self.loginRD = rd;
    [self.sinaWeibo logIn];
    
}

-(void)loginWithTqqWithRequestDelegate:(NKRequestDelegate*)rd {
    self.socialType = NKSocialServiceTypeTqq;
    self.loginRD = rd;
    
    NSArray *authorizeList = @[kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, kOPEN_PERMISSION_ADD_SHARE, kOPEN_PERMISSION_ADD_PIC_T,
                               kOPEN_PERMISSION_CHECK_PAGE_FANS, kOPEN_PERMISSION_ADD_TOPIC, kOPEN_PERMISSION_LIST_ALBUM];
    [self.tqq authorize:authorizeList
             localAppId:self.tqq.localAppId
               inSafari:NO];
}

-(void)loginWithRenrenWithRequestDelegate:(NKRequestDelegate *)rd {
    self.socialType = NKSocialServiceTypeRenren;
    self.loginRD = rd;
    NSArray *permissions = [NSArray arrayWithObjects:@"read_user_album",@"status_update",@"photo_upload",@"publish_feed",@"create_album",@"operate_like",nil];
    if(![[Renren sharedRenren] isSessionValid]){//未登录的情况,进行授权登录
        [[Renren sharedRenren] authorizationInNavigationWithPermisson:permissions andDelegate:self];
    } else {//已登录的情况，退出登录
//        [[Renren sharedRenren] logout:self];
        ROUserInfoRequestParam *requestParam = [[[ROUserInfoRequestParam alloc] init]
                                                autorelease];
        requestParam.fields = @"uid,name,sex,headurl";
        [[Renren sharedRenren] getUsersInfo:requestParam andDelegate:self];
    }
}

- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse*)response;
{
    if ([response.rootObject isKindOfClass:[NSArray class]]) {
        self.renren_id = [[response.rootObject lastObject] userId];
        self.renren_headurl = [[response.rootObject lastObject] headUrl];
        self.renren_name = [[response.rootObject lastObject] name];
        self.renren_sex = [[response.rootObject lastObject] sex];
        [loginRD delegateFinishWithRequest:nil];
        self.loginRD = nil;
    }else {
    }
}

-(void)showAlert:(NSString*)message{
	UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Widget Dialog"
                                                   message:message delegate:nil
                                         cancelButtonTitle:@"ok" otherButtonTitles:nil];
	[alert show];
    [alert release];
}

-(void)kNotificationDidGetLoggedInUserId
{
    
}

- (void)renrenDidLogin:(Renren *)renren {
    
    ROUserInfoRequestParam *requestParam = [[[ROUserInfoRequestParam alloc] init]
                                           autorelease];
    requestParam.fields = @"uid,name,sex,headurl";
    [renren getUsersInfo:requestParam andDelegate:self];
//    [loginRD delegateFinishWithRequest:nil];
//    self.loginRD = nil;
}

-(void)resetButtons{
    
}

-(void)getUserInfo{
    
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"users/show.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
}

- (SinaWeibo *)sinaweibo
{
    return sinaWeibo;
}

- (void)removeWeiboAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)storeWeiboAuthData
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeTqqAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"TqqAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)storeTqqAuthData
{
    NSDictionary *authData = @{@"AccessTokenKey" : self.tqq.accessToken,
                               @"ExpirationDateKey" : self.tqq.expirationDate,
                               @"OpenId" : self.tqq.openId};
    
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"TqqAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - SinaWeibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    //NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    
    [self resetButtons];
    [self storeWeiboAuthData];
    
//    WMWeiboRegisterViewController *weibo = [[WMWeiboRegisterViewController alloc] init];
//    [self.navigationController pushViewController:weibo animated:YES];
//    [weibo release];
    
    [loginRD delegateFinishWithRequest:nil];
    self.loginRD = nil;
    
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    //NSLog(@"sinaweiboDidLogOut");
    [self removeWeiboAuthData];
    [self resetButtons];
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    //NSLog(@"sinaweiboLogInDidCancel");
    [loginRD delegateFailedWithRequest:nil];
    self.loginRD = nil;
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    //NSLog(@"sinaweibo logInDidFailWithError %@", error);
    
    NKRequest *request = [[[NKRequest alloc] init] autorelease];
    request.error = error;
    [loginRD delegateFailedWithRequest:request];
    self.loginRD = nil;
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    //NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
    [self removeWeiboAuthData];
    [self resetButtons];
}

#pragma mark - Tqq Delegate

- (void)tencentDidLogin {
    [self storeTqqAuthData];
    [self.loginRD delegateFinishWithRequest:nil];
    self.loginRD = nil;
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    [loginRD delegateFailedWithRequest:nil];
    self.loginRD = nil;
}

- (void)tencentDidNotNetWork {
    [loginRD delegateFailedWithRequest:nil];
    self.loginRD = nil;
}

- (void)tencentDidLogout {
    [self removeTqqAuthData];
}

- (void)getUserInfoResponse:(APIResponse*) response {
    NSDictionary *responseContent = response.jsonResponse;
    NSNumber *ret = responseContent[@"ret"];
    
    if (ret.integerValue == URLREQUEST_SUCCEED) {
        NKRequest *request = [[[NKRequest alloc] init] autorelease];
        request.originDic = responseContent;
        
        [self.loginRD delegateFinishWithRequest:request];
        self.loginRD = nil;
    }
    else {
        [self.loginRD delegateFailedWithRequest:nil];
        self.loginRD = nil;
    }
}

#pragma mark - SinaWeiboRequest Delegate

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error{
    
    //NSLog(@"%@", error);
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
    
    //NSLog(@"%@", result);
    
    [self resetButtons];
}



-(NKWeiboRequest*)sinaRequestWithURL:(NSString *)url
                      httpMethod:(NSString *)httpMethod
                          params:(NSDictionary *)params
                 requestDelegate:(NKRequestDelegate*)rd{
    
    
    
    
    if (params == nil)
    {
        params = [NSMutableDictionary dictionary];
    }
    
    if ([sinaWeibo isAuthValid])
    {
        [params setValue:sinaWeibo.accessToken forKey:@"access_token"];
        NSString *fullURL = [kSinaWeiboSDKAPIDomain stringByAppendingString:url];
        NSLog(@"full url is:%@",fullURL);
        NKWeiboRequest *_request = [NKWeiboRequest requestWithURL:fullURL httpMethod:httpMethod params:params requestDelegate:rd];
        _request.sinaweibo = self.sinaWeibo;
        [sinaWeibo.requests addObject:_request];
        [_request connect];
        return _request;
    }
    else
    {
        //notify token expired in next runloop
        [sinaWeibo performSelectorOnMainThread:@selector(notifyTokenExpired:)
                               withObject:nil
                            waitUntilDone:NO];
        
        return nil;
    }
    
    
    
    
    
    
    
}

- (BOOL)handleAppDelegateOpenURL:(NSURL *)url {
    BOOL ret = NO;
    
    if ([self.socialType isEqualToString:NKSocialServiceTypeSinaWeibo]) {
        ret = [self.sinaWeibo handleOpenURL:url];
    }
    else if ([self.socialType isEqualToString:NKSocialServiceTypeTqq]) {
        ret = [TencentOAuth HandleOpenURL:url];
    }
    else {
        ret = NO;
    }
    
    return ret;
}

- (void)getTqqUserInfoWithDelegate:(NKRequestDelegate *)rd {
    self.loginRD = rd;
    [self.tqq getUserInfo];
}



-(void)removeSocial{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [self.sinaWeibo logOut];
    
    [self.tqq logout:nil];
    
    [[Renren sharedRenren] logout:nil];
    
    // Logout from Renren API 2.0 SDK 0.9.3
    [RennClient logoutWithDelegate:self];
}



@end
