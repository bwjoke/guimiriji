//
//  WMWelcomeViewController.m
//  WEIMI
//
//  Created by King on 10/24/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//

#import "WMWelcomeViewController.h"
#import "WMLineLabel.h"
#import "WMRegisterViewController.h"
#import "WMMAcount.h"
#import "WMErrorGenderViewController.h"
#import "WMAppDelegate.h"
#import "WMAboutViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>

#import "WMCoupleTestViewController.h"

enum tWMWelcomeViewTag {
    kWMWelcomeViewTagQQLogin = 1
};

@interface WMWelcomeViewController () <TencentSessionDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) id renrenResponse;

#pragma mark - Lazy loading

- (TencentOAuth *)tencentOAuth;

@end

@implementation WMWelcomeViewController {
    TencentOAuth *_tencentOAuth;
}

- (void)dealloc {
    [_renrenResponse release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.showTableView removeFromSuperview];
    
    // Add info button
    UIButton *infoButton = [[UIButton alloc] initWithFrame:CGRectMake(280.0f, 15.0f, 23.0f, 23.0f)];
    [infoButton setImage:[UIImage imageNamed:@"info_button_normal"] forState:UIControlStateNormal];
    [infoButton setImage:[UIImage imageNamed:@"info_button_click"] forState:UIControlStateHighlighted];
    [infoButton addTarget:self action:@selector(showAboutPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:infoButton];
    [infoButton release];
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(98, 75, 125, 57)];
    logoView.image = [UIImage imageNamed:@"frist_logo"];
    
    [self.contentView addSubview:logoView];
    
    [logoView release];
    
    CGFloat startHeight;
    if (SCREEN_HEIGHT==480) {
        startHeight = 235;
    }else {
        startHeight = 250;
    }
    
    for (int i=0; i<3; i++) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 158+i*21, 320, 14)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.font = [UIFont boldSystemFontOfSize:12];
        textLabel.textAlignment = UITextAlignmentCenter;
        textLabel.textColor = [UIColor colorWithHexString:@"#8c7a67"];
        [self.contentView addSubview:textLabel];
        [textLabel release];
        
        UILabel *notiLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 388-250+startHeight+i*18, 320, 14)] autorelease];
        notiLabel.backgroundColor = [UIColor clearColor];
        notiLabel.font = [UIFont systemFontOfSize:10];
        notiLabel.textAlignment = UITextAlignmentCenter;
        notiLabel.textColor = [UIColor colorWithHexString:@"#8c7a67"];
        if (i<2) {
            [self.contentView addSubview:notiLabel];
        }
        
        
        
        
        switch (i) {
            case 0: {
                textLabel.text = @"女生闺蜜必备，私密心情空间";
                notiLabel.text = @"微博、人人登录后可查看好友的八卦";
                UIButton *weiboButton = [[UIButton alloc] initWithFrame:CGRectMake(47, 250-250+startHeight, 234, 54)];
                [weiboButton setBackgroundImage:[UIImage imageNamed:@"btn_sina"] forState:UIControlStateNormal];
                [weiboButton setBackgroundImage:[UIImage imageNamed:@"btn_sina_click"] forState:UIControlStateHighlighted];
                [weiboButton addTarget:self action:@selector(loginWithWeibo) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:weiboButton];
                [weiboButton release];
                break;
            }
            case 1: {
                textLabel.text = @"匿名八卦点评，情感话题讨论";
                notiLabel.text = @"绝对不会公开妳的身份";
                UIButton *renrenButton = [[UIButton alloc] initWithFrame:CGRectMake(47, 325-250+startHeight, 234, 54)];
                [renrenButton setBackgroundImage:[UIImage imageNamed:@"btn_renren"] forState:UIControlStateNormal];
                [renrenButton setBackgroundImage:[UIImage imageNamed:@"btn_renren_click"] forState:UIControlStateHighlighted];
                [renrenButton addTarget:self action:@selector(loginWithRenren) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:renrenButton];
                [renrenButton release];
                break;
            }
            case 2: {
                textLabel.text = @"让天下没有看不懂的男人";
                WMLineLabel *lineLebel = [[[WMLineLabel alloc] initWithFrame:CGRectMake(130, 376-250+startHeight, 320, 16) fontSize:12] autorelease];
                lineLebel.text = @"邮箱帐号登录";
                lineLebel.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginWithEmail)];
                [lineLebel addGestureRecognizer:tap];
                [tap release];
                break;
            }
            default:
                break;
        }
    }

    // Add QQ login button
    
    
    
    UIButton *qqLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 14.0f)];
    [qqLoginButton addTarget:self action:@selector(loginWithQQ) forControlEvents:UIControlEventTouchUpInside];

    qqLoginButton.center = CGPointMake(self.view.frame.size.width / 2.0f, SCREEN_HEIGHT==480?418:432);

    [qqLoginButton setTitle:@"通过QQ登录" forState:UIControlStateNormal];

    qqLoginButton.titleLabel.font = [UIFont systemFontOfSize:10];
    qqLoginButton.titleLabel.textAlignment = UITextAlignmentCenter;
    [qqLoginButton setTitleColor:[UIColor colorWithHexString:@"#8c7a67"] forState:UIControlStateNormal];

    [self.contentView addSubview:qqLoginButton];

    // Add under line button

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(2.0f, 13.0f, qqLoginButton.frame.size.width - 4, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#8c7a67"];
    [qqLoginButton addSubview:line];

    
    
    // NOTE: following code need REFACTOR!!! {{{
    
    UIButton *coupleButton = [[UIButton alloc] initWithFrame:CGRectMake(50, SCREEN_HEIGHT==480?440:470, 234, 30)];
    [coupleButton setBackgroundImage:[UIImage imageNamed:@"btn_couple_bg"] forState:UIControlStateNormal];
    //[coupleButton setImage:[UIImage imageNamed:@"btn_couple_bg"] forState:UIControlStateNormal];
    //[coupleButton setImageEdgeInsets:UIEdgeInsetsMake(2, 46, 3, 136)];
    [coupleButton setTitle:@"夫妻相大测试" forState:UIControlStateNormal];
    [coupleButton setTitleEdgeInsets:UIEdgeInsetsMake(7, 50, 7, 35)];
    [coupleButton setTitleColor:[UIColor colorWithHexString:@"#A6937C"] forState:UIControlStateNormal];
    [coupleButton setTitleColor:[UIColor colorWithHexString:@"#7a6d5d"] forState:UIControlStateHighlighted];
    coupleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [coupleButton addTarget:self action:@selector(coupleTest:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:coupleButton];
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(210, 7, 9, 15)];
    arrow.image = [UIImage imageNamed:@"arrow"];
    //[coupleButton addSubview:arrow];
    CGSize size = self.view.bounds.size;
    
    self.contentView.center = CGPointMake(size.width / 2.0f, size.height / 2.0f - 25.0f);
    
    // }}}

}

-(void)coupleTest:(id)sender
{
    WMCoupleTestViewController *coupleTestViewController = [[WMCoupleTestViewController alloc] initWithNibName:nil bundle:nil];
    [NKNC pushViewController:coupleTestViewController animated:YES];
}

- (void)showAboutPage {
    WMAboutViewController *aboutViewController = [[[WMAboutViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    [NKNC pushViewController:aboutViewController animated:YES];
}

-(void)loginWithWeibo
{
    WMAppDelegate *appDelegate = [WMAppDelegate shareAppDelegate];
    appDelegate.isLogin = YES;
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(loginWithWeiboOK:) andFailedSelector:@selector(loginWithWeiboFailed:)];
    [[NKSocial social] loginWithSinaWeiboWithRequestDelegate:rd];
}

-(void)loginWithRenren
{
    [RennClient loginWithDelegate:self];
}

- (void)loginWithQQ
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"QQ登录无法查看好友八卦，建议使用微博或人人登陆，确认使用QQ账号注册登录吗？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    
    alert.tag = kWMWelcomeViewTagQQLogin;
    
    [alert show];
}

#pragma mark - RennLoginDelegate

- (void)rennLoginSuccess {
    GetUserParam *param = [[GetUserParam alloc] init];
    param.userId = [RennClient uid];
    [RennClient sendAsynRequest:param delegate:self];
}

- (void)rennLoginDidFailWithError:(NSError *)error {
    // TODO
}

- (void)rennLoginCancelded {
    // TODO
}

- (void)rennLoginAccessTokenInvalidOrExpired:(NSError *)error {
    // TODO
}

#pragma mark - Tencent session delegate

- (void)tencentDidLogin {
    
    NSString *openId = [[self tencentOAuth] openId];
    NSString *accessToken = [[self tencentOAuth] accessToken];
    
    progressView = [NKProgressView progressViewForView:self.view];
    progressView.labelText = @"正在载入";
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(qqLoginOK:) andFailedSelector:@selector(qqLoginFailed:)];
    [[NKUserService sharedNKUserService] socialLoginWithType:NKAccountTypeTqq oauthID:openId token:accessToken uname:nil andRequestDelegate:rd];
    
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    // TODO
    ProgressFailedWith(@"登录失败，请重新登录");
}

- (void)tencentDidNotNetWork {
    // TODO
}

- (void)qqLoginOK:(NKRequest *)request {
    ProgressHide;
    
    NSDictionary *data = [request.originDic objectOrNilForKey:@"data"];
    
    NSString *name = data[@"name"];
    NSString *headeUrl = data[@"avatar"];
    NSString *accessToken = [self tencentOAuth].accessToken;
    NSString *openID = [self tencentOAuth].openId;
    NSString *uid = data[@"id"];
    
    if ([[data objectOrNilForKey:@"is_register"] integerValue]) {
        
        // Need Register
        
        WMMAcount *theAccount = [WMMAcount shareAcount];
        theAccount.name = name;
        theAccount.headeUrl = headeUrl;
        theAccount.accessToken = accessToken;
        theAccount.oauthId = openID;
        theAccount.socialID = uid;
        theAccount.type = NKAccountTypeTqq;
        
        WMRegitserInviteViewController *wmrvc = [[WMRegitserInviteViewController alloc] init];
        
        wmrvc.theAccount = theAccount;
        wmrvc.uid = uid;
        
        [NKNC pushViewController:wmrvc animated:YES];
        
        [wmrvc release];
    }
    
    else{
        
        // Login
        
        NKMAccount *theAccount = [[[NKMAccount alloc] init] autorelease];
        
        theAccount.accountType = NKAccountTypeTqq;
        theAccount.shouldAutoLogin = [NSNumber numberWithBool:YES];
        theAccount.oauthID = openID;
        theAccount.accessToken = accessToken;
        
        [[[[NKConfig sharedConfig] accountManagerClass] sharedAccountsManager] setCurrentAccount:theAccount];
        
        [[[[NKConfig sharedConfig] accountManagerClass] sharedAccountsManager] loginFinish:request];
        
        [[NKNavigator sharedNavigator] showLoginOKView];

    }
}

- (void)qqLoginFailed:(NKRequest *)request {
    if ([request.errorDescription isEqualToString:@"sex"]) {
        WMErrorGenderViewController *errorGenderViewController = [[[WMErrorGenderViewController alloc] init] autorelease];
        [self presentModalViewController:errorGenderViewController animated:YES];
        ProgressSuccess(nil);
    } else {
        ProgressErrorDefault;
    }
}

#pragma mark - Renren request delegate

- (void)rennService:(RennService *)service requestSuccessWithResponse:(id)response {
    NSDictionary *basicInformation = response[@"basicInformation"];
    
    if ([basicInformation[@"sex"] isEqualToString:@"MALE"]) {
        WMErrorGenderViewController *errorGenderViewController = [[[WMErrorGenderViewController alloc] init] autorelease];
        [self presentModalViewController:errorGenderViewController animated:YES];
        return;
    }
    
    Progress(@"正在登录");
    
    self.renrenResponse = response;
    
    NSString *oauthID = [RennClient uid];
    NSString *token = [RennClient accessToken].accessToken;
    NSString *uname = response[@"name"];
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(renrenLoginOK:) andFailedSelector:@selector(renrenLoginFailed:)];
    [[NKUserService sharedNKUserService] socialLoginWithType:NKAccountTypeRenren oauthID:oauthID token:token uname:uname andRequestDelegate:rd];
}

- (void)rennService:(RennService *)service requestFailWithError:(NSError*)error {
    // TODO
}

#pragma mark -

-(void)loginWithWeiboOK:(NKRequest*)request {
    Progress(@"正在登录");
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(sinaGetInfoOK:) andFailedSelector:@selector(sinaGetInfoFailed:)];
    
    [[NKSocial social] sinaRequestWithURL:@"users/show.json" httpMethod:@"GET" params:[NSMutableDictionary dictionaryWithObject:[[[NKSocial social] sinaWeibo] userID] forKey:@"uid"] requestDelegate:rd];
}

-(void)loginWithWeiboFailed:(NKRequest*)request{
    
    ProgressFailedWith(@"授权失败");
}


-(void)renrenLoginOK:(NKRequest*)request{
    
    ProgressHide;
    
    NSLog(@"%@", request.originDic);
    
    NSDictionary *data = [request.originDic objectOrNilForKey:@"data"];
    
    NSAssert(self.renrenResponse != nil, @"Renren did not logon");
    
    NSString *name = self.renrenResponse[@"name"];
    NSString *headeUrl = nil;
    
    for (NSDictionary *avatar in self.renrenResponse[@"avatar"]) {
        if ([avatar[@"size"] isEqualToString:@"HEAD"]) {
            headeUrl = avatar[@"url"];
        }
    }
    
    NSString *accessToken = [RennClient accessToken].accessToken;
    NSString *oauthID = [data objectOrNilForKey:@"oauth_id"];
    NSString *socialID = self.renrenResponse[@"id"];
    
    if ([[data objectOrNilForKey:@"is_register"] integerValue]) {
        
        // Need Register
        
        WMMAcount *theAccount = [WMMAcount shareAcount];
        theAccount.name = name;
        theAccount.headeUrl = headeUrl;
        theAccount.accessToken = accessToken;
        theAccount.oauthId = oauthID;
        theAccount.socialID = socialID;
        theAccount.type = NKAccountTypeRenren;
        WMRegitserInviteViewController *wmrvc = [[WMRegitserInviteViewController alloc] init];
        wmrvc.theAccount = theAccount;
        wmrvc.uid = [data objectOrNilForKey:@"id"];
        [NKNC pushViewController:wmrvc animated:YES];
        [wmrvc release];
        
    }
    
    else{
        
        // Login
        
        NKMAccount *theAccount = [[[NKMAccount alloc] init] autorelease];
        theAccount.accountType = NKAccountTypeRenren;
        theAccount.shouldAutoLogin = [NSNumber numberWithBool:YES];
        theAccount.oauthID = oauthID;
        theAccount.accessToken = accessToken;
        
        [[[[NKConfig sharedConfig] accountManagerClass] sharedAccountsManager] setCurrentAccount:theAccount];
        
        [[[[NKConfig sharedConfig] accountManagerClass] sharedAccountsManager] loginFinish:request];
        
        [[NKNavigator sharedNavigator] showLoginOKView];
        
    }
    
}

-(void)renrenLoginFailed:(NKRequest*)request{
    
    if ([request.errorCode intValue]==11015 || [request.errorCode intValue]==11001 || [request.errorCode intValue]==11005) {
        ProgressHide;
    }
    
    else{
        ProgressErrorDefault;
        [RennClient logoutWithDelegate:nil];
    }
    
    
}

-(void)socialLoginOK:(NKRequest*)request{
    
    ProgressHide;
    
    NSLog(@"%@", request.originDic);
    
    
    NSDictionary *data = [request.originDic objectOrNilForKey:@"data"];
    
    
    if ([[data objectOrNilForKey:@"is_register"] integerValue]) {
        
        // Need Register
        NSString *accessToken = [[[NKSocial social] sinaWeibo] accessToken];
        WMMAcount *theAccount = [WMMAcount shareAcount];
        theAccount.accessToken = accessToken;
        theAccount.oauthId = [data objectOrNilForKey:@"oauth_id"];
        theAccount.socialID = [[[NKSocial social] sinaWeibo] userID];
        WMRegitserInviteViewController *wmrvc = [[WMRegitserInviteViewController alloc] init];
        wmrvc.theAccount = theAccount;
        wmrvc.uid = [data objectOrNilForKey:@"id"];
        [NKNC pushViewController:wmrvc animated:YES];
        [wmrvc release];
        
    }
    
    else{
        
        // Login
        
        NKMAccount *theAccount = [[[NKMAccount alloc] init] autorelease];
        theAccount.accountType = NKAccountTypeWeibo;
        theAccount.shouldAutoLogin = [NSNumber numberWithBool:YES];
        theAccount.oauthID = [[[NKSocial social] sinaWeibo] userID];
        theAccount.accessToken = [[[NKSocial social] sinaWeibo] accessToken];
        
        [[[[NKConfig sharedConfig] accountManagerClass] sharedAccountsManager] setCurrentAccount:theAccount];
        
        //request.results = [NSArray arrayWithObject:[NKMUser modelFromDic:data]];
        
        [[[[NKConfig sharedConfig] accountManagerClass] sharedAccountsManager] loginFinish:request];
        
        [[NKNavigator sharedNavigator] showLoginOKView];
        
    }
    
    

}

-(void)socialLoginFailed:(NKRequest*)request{
    
    
    
    if ([request.errorCode intValue]==11015 || [request.errorCode intValue]==11001 || [request.errorCode intValue]==11005) {
        ProgressHide;
    }
    
    else{
        if ([request.errorDescription isEqualToString:@"sex"]) {
            WMErrorGenderViewController *errorGenderViewController = [[[WMErrorGenderViewController alloc] init] autorelease];
            [self presentModalViewController:errorGenderViewController animated:YES];
            ProgressSuccess(nil);
        }
        ProgressHide;
        [[[NKSocial social] sinaweibo] logOut];
        
    }
    
    
}


-(void)sinaGetInfoOK:(NKRequest*)request
{
    NSDictionary *sinaUser = [request.results lastObject];
    
    WMMAcount *theAccount = [WMMAcount shareAcount];
    theAccount.name = [sinaUser objectOrNilForKey:@"screen_name"];
    theAccount.headeUrl = [sinaUser objectOrNilForKey:@"avatar_large"];
    theAccount.type = NKAccountTypeWeibo;
   
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(socialLoginOK:) andFailedSelector:@selector(socialLoginFailed:)];
    
    [[NKUserService sharedNKUserService] socialLoginWithType:NKAccountTypeWeibo
                                                     oauthID:[[[NKSocial social] sinaWeibo] userID]
                                                       token:[[[NKSocial social] sinaWeibo] accessToken]
                                                       uname:nil
                                          andRequestDelegate:rd];
    
    Progress(@"正在登录");
    
    
    
    
}

-(void)sinaGetInfoFailed:(NKRequest*)request
{
    ProgressErrorDefault;
}

-(void)loginWithEmail
{
    NSLog(@"Email");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kWMWelcomeViewTagQQLogin) {
        if (buttonIndex == 1) {
            [[self tencentOAuth] authorize:@[@"get_user_info"] inSafari:NO];
        }
    }
}

#pragma mark - Lazy loading

- (TencentOAuth *)tencentOAuth {
    if (_tencentOAuth) {
        return _tencentOAuth;
    }
    
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"100497175" andDelegate:self];

    return _tencentOAuth;
}

@end
