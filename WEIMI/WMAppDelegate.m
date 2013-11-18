//
//  WMAppDelegate.m
//  WEIMI
//
//  Created by King on 10/24/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//

#import "WMAppDelegate.h"
#import "NKUI.h"
#import "WMHomeViewController.h"
#import "WMWelcomeViewController.h"
#import "WMMenWikiViewController.h"
#import "WMSettingViewController.h"

#import "MobClick.h"
#import "WMAccountManager.h"
#import "WMTopicViewController.h"
#import "WMDiscussViewController.h"
#import "WMMenWikiFristViewController.h"
#import "WMMiyuViewController.h"
#import "WMFeedDetailViewController.h"
#import "WMBaoliaoXiangqingViewController.h"
#import "WMConverstionViewController.h"
#import "WMMojingViewController.h"

#import "WMNotificationCenter.h"

#import <ShareSDK/ShareSDK.h>
#import<TencentOpenAPI/TencentOAuth.h>
#import<TencentOpenAPI/QQApi.h>
#import<TencentOpenAPI/QQApiInterface.h>

#import "WXApi.h"
#import "WBApi.h"

#import "WMMUser.h"

#import "MPNotificationView.h"
#import "WMConfig.h"

#import "WMManDetailViewController.h"
#import "RennSDK/RennSDK.h"

#import "KGStatusBar.h"


NSString *const ZUOVersionRC = @"http://www.zuo.com/system/version/weimi_rc/version.plist";
NSString *const ZUOVersionProduct = @"http://www.zuo.com/system/version/weimi/version.plist";

@implementation WMAppDelegate

#define MobClickChannelId nil

//#define MobClickChannelId @"91"
//#define MobClickChannelId @"PP"
//#define MobClickChannelId @"TB"
//#define MobClickChannelId @"WEIMI"

+(WMAppDelegate *)shareAppDelegate
{
    return (WMAppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (void)dealloc
{
    
    [_sysFunctionRaw release];
    [_OauthArray release];
    [_window release];
    [super dealloc];
}

-(void)configSomething{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL customize = [defaults boolForKey:@"switch"];
    
    if (customize) {
        //NSLog(@"%@", [defaults objectForKey:@"textfield"]);
        
        [[NKConfig sharedConfig] setDomainURL:[defaults objectForKey:@"textfield"]];
        [[NKConfig sharedConfig] setSuccessReturnValue:10000];
    }
    else{
        
        [[NKConfig sharedConfig] setDomainURL:[defaults objectForKey:@"server"]];
        [[NKConfig sharedConfig] setSuccessReturnValue:10000];
        
    }
    
    if (![[NKConfig sharedConfig] domainURL]) {
        [[NKConfig sharedConfig] setDomainURL:@"http://www.weimi.com/ios/v1"];
        [[NKConfig sharedConfig] setSuccessReturnValue:10000];
    }
    
    
    
    //    [ZUOLocationService sharedZUOLocationService];
    [WMNotificationCenter sharedNKNotificationCenter];
    
    [[NKConfig sharedConfig] setNavigatorHeight:60];
    
    //    [[NKConfig sharedConfig] setErrorTarget:self];
    //    [[NKConfig sharedConfig] setErrorMethod:@selector(errorString:)];
    
    [[NKConfig sharedConfig] setApnTarget:[WMSystemService sharedWMSystemService]];
    [[NKConfig sharedConfig] setApnMethod:@selector(bindDeviceWithUDID:andRequestDelegate:)];
    
    [[NKConfig sharedConfig] setEmojoPlist:@"emojoweimi"];
    [[NKConfig sharedConfig] setEmojoPad:@"emojoPadWM"];
    
    [[NKConfig sharedConfig] setParseStatusKey:@"error"];
    [[NKConfig sharedConfig] setAccountManagerClass:[WMAccountManager class]];
    
    [[NKConfig sharedConfig] setNeedLocation:YES];
    [[NKLocationService sharedNKLocationService] findLocation];
    
}

-(void)getSysytemForbid
{
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"sysFunction"]) {
        NSMutableDictionary *sysFunction = [NSMutableDictionary dictionaryWithDictionary:@{@"baoliao": @1, @"tab": @0, @"privacy": @0, @"purview": @1, @"scorebtn": @1, @"miyureport": @1}];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:sysFunction forKey:@"sysFunction"];
        [defaults synchronize];
    }
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"sysFunction"]);
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self
                                                          finishSelector:@selector(getFunctionOK:)
                                                       andFailedSelector:@selector(getFunctionFailed:)];
    [[WMSystemService sharedWMSystemService] getFunction:rd];
}

- (void)getFunctionOK:(NKRequest *)request {
    self.sysFunctionRaw = [request.originDic objectForKey:@"data"];
    [self saveSystemFunctionToUserDefalts];
}

- (void)getFunctionFailed:(NKRequest *)request {
    // TODO
}

-(void)saveSystemFunction
{
    NSDictionary *sysFunctionRaw = self.sysFunctionRaw;
    if (!self.sysFunctionRaw) {
        if (![[NSUserDefaults standardUserDefaults] valueForKey:@"sysFunction"] && !MobClickChannelId) {
            NSMutableDictionary *sysFunction = [NSMutableDictionary dictionaryWithDictionary:@{@"baoliao": @1, @"tab": @0, @"privacy": @0, @"purview": @1, @"scorebtn": @1, @"miyureport": @1}];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:sysFunction forKey:@"sysFunction"];
            [defaults synchronize];
        }else if (MobClickChannelId) {
            NSMutableDictionary *sysFunction = [NSMutableDictionary dictionaryWithDictionary:@{@"baoliao": @1, @"tab": @1, @"privacy": @1, @"purview": @1, @"scorebtn": @1, @"miyureport": @0}];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:sysFunction forKey:@"sysFunction"];
            [defaults synchronize];
        }
    }else {
        NSMutableDictionary *sysFunction;
        if (MobClickChannelId) {
            sysFunction = [NSMutableDictionary dictionaryWithDictionary:@{@"baoliao": @1, @"tab": @1, @"privacy": @1, @"purview": @1, @"scorebtn": @1, @"miyureport": @0}];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if ([sysFunctionRaw isKindOfClass:[NSDictionary class]]) {
                for (NSString *key in sysFunctionRaw) {
                    if ([key isEqualToString:@"scoretag"]) {
                        sysFunction[@"scoretag"] = sysFunctionRaw[key];
                    }
                }
            }
            
            [defaults setObject:sysFunction forKey:@"sysFunction"];
            [defaults synchronize];
            
        }else {
            sysFunction = [NSMutableDictionary dictionaryWithDictionary:@{@"baoliao": @1, @"tab": @0, @"privacy": @0, @"purview": @1, @"scorebtn": @1, @"miyureport": @1}];
            if ([sysFunctionRaw isKindOfClass:[NSDictionary class]]) {
                for (NSString *key in sysFunctionRaw) {
                    if ([key isEqualToString:@"scoretag"]) {
                        sysFunction[@"scoretag"] = sysFunctionRaw[key];
                    } else if ([key isEqualToString:@"censor"] || [key isEqualToString:@"miyureport"]) {
                        NSString *toggle = sysFunctionRaw[key][@"toggle"];
                        NSString *realKey = key;
                        
                        // Convert the key for "censor" {{{
                        if ([key isEqualToString:@"censor"]) {
                            realKey = @"tab";
                        }
                        // }}}
                        
                        if ([toggle isEqualToString:@"user"]) {
                            BOOL isIn = NO;
                            
                            NSArray *uids = sysFunctionRaw[key][@"uids"];
                            
                            if ([uids isKindOfClass:[NSArray class]]) {
                                NSString *mid = [[[WMMUser me] mid] description];
                                
                                for (NSNumber *uid in uids) {
                                    if ([[uid description] isEqualToString:mid]) {
                                        isIn = YES;
                                        break;
                                    }
                                }
                            }
                            if ([key isEqualToString:@"miyureport"]) {
                                sysFunction[realKey] = @(isIn);
                            }else {
                                sysFunction[realKey] = @(!isIn);
                            }
                            
                        } else if ([toggle isEqualToString:@"on"]) {
                            sysFunction[realKey] = @1;
                        } else {
                            sysFunction[realKey] = @0;
                        }
                    }
                }
            }
            
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:sysFunction forKey:@"sysFunction"];
            [defaults synchronize];
        }
    }
    
    
    
}

- (void)saveSystemFunctionToUserDefalts {
    NSDictionary *sysFunctionRaw = self.sysFunctionRaw;
    NSMutableDictionary *sysFunction;
    if (MobClickChannelId) {
        sysFunction = [NSMutableDictionary dictionaryWithDictionary:@{@"baoliao": @1, @"tab": @1, @"privacy": @1, @"purview": @1, @"scorebtn": @1, @"miyureport": @0}];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([sysFunctionRaw isKindOfClass:[NSDictionary class]]) {
            for (NSString *key in sysFunctionRaw) {
                if ([key isEqualToString:@"scoretag"]) {
                    sysFunction[@"scoretag"] = sysFunctionRaw[key];
                }
            }
        }
        
        [defaults setObject:sysFunction forKey:@"sysFunction"];
        [defaults synchronize];
        
    }else {
        sysFunction = [NSMutableDictionary dictionaryWithDictionary:@{@"baoliao": @1, @"tab": @0, @"privacy": @0, @"purview": @1, @"scorebtn": @1, @"miyureport": @1}];
        if ([sysFunctionRaw isKindOfClass:[NSDictionary class]]) {
            for (NSString *key in sysFunctionRaw) {
                if ([key isEqualToString:@"scoretag"]) {
                    sysFunction[@"scoretag"] = sysFunctionRaw[key];
                } else if(!MobClickChannelId) {
                    if ([key isEqualToString:@"censor"] || [key isEqualToString:@"miyureport"]) {
                        NSString *toggle = sysFunctionRaw[key][@"toggle"];
                        NSString *realKey = key;
                        
                        // Convert the key for "censor" {{{
                        if ([key isEqualToString:@"censor"]) {
                            realKey = @"tab";
                        }
                        // }}}
                        
                        if ([toggle isEqualToString:@"user"]) {
                            BOOL isIn = NO;
                            
                            NSArray *uids = sysFunctionRaw[key][@"uids"];
                            
                            if ([uids isKindOfClass:[NSArray class]]) {
                                NSString *mid = [[[WMMUser me] mid] description];
                                
                                for (NSNumber *uid in uids) {
                                    if ([[uid description] isEqualToString:mid]) {
                                        isIn = YES;
                                        break;
                                    }
                                }
                            }
                            if ([key isEqualToString:@"miyureport"]) {
                                sysFunction[realKey] = @(isIn);
                            }else {
                                sysFunction[realKey] = @(!isIn);
                            }
                            
                        } else if ([toggle isEqualToString:@"on"]) {
                            sysFunction[realKey] = @1;
                        } else {
                            sysFunction[realKey] = @0;
                        }
                    }
                }
                
            }
        }
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:sysFunction forKey:@"sysFunction"];
        [defaults synchronize];
    }
    
}

- (void)umengTrack {
    [MobClick setCrashReportEnabled:YES]; // 如果不需要捕捉异常，注释掉此行
    //[MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy)SEND_ON_EXIT channelId:MobClickChannelId];
    
    [MobClick updateOnlineConfig];  //在线参数配置
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
    //NSLog(@"online config has fininshed and note = %@", note.userInfo);
}

- (void)initializePlat {
    //添加新浪微博应用
    [ShareSDK connectSinaWeiboWithAppKey:@"596106848"
                               appSecret:@"e4d68eee62327a4cb236233fb698fca6" redirectUri:@"http://www.weimi.com"];
    //添加腾讯微博应用
    [ShareSDK connectTencentWeiboWithAppKey:@"801339578"
                                  appSecret:@"042d819774caf3654326e6bcd8dd8f1a" redirectUri:@"http://www.weimi.com"
                                   wbApiCls:[WBApi class]];
    
    [ShareSDK connectQQWithAppId:@"QQ05FD7717" qqApiCls:[QQApi class]];
    //添加QQ空间应用
    [ShareSDK connectQZoneWithAppKey:@"100416233" appSecret:@"60c30cd4e60d3165868fd0e56f862cbe"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    //添加人人
    [ShareSDK connectRenRenWithAppKey:@"321eebb062324cf1b73d7e7508d5298d" appSecret:@"f7fe5cfbcf3e4f679bb9fad12d93c79c"];
    
    //微信
    [ShareSDK connectWeChatWithAppId:@"wxc06686884e067c10"
                           wechatCls:[WXApi class]];
    
    // Renren login service, API 2.0
    [RennClient initWithAppId:@"228074" apiKey:@"321eebb062324cf1b73d7e7508d5298d" secretKey:@"f7fe5cfbcf3e4f679bb9fad12d93c79c"];
}

-(void)rateThisApp
{
    int hasRate = [[[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"has_rate_%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]] integerValue];
    NSString *launch_num = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"launch_num_%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];
    if (hasRate == 0) {
        if ([launch_num integerValue]== 4) {
            UIAlertView *rateView = [[UIAlertView alloc] initWithTitle:@"给薇蜜评价" message:@"薇蜜好用咩？" delegate:self cancelButtonTitle:@"不再显示" otherButtonTitles:@"乖~赏你个5星好评！❤",@"用得不爽，我要告状…", nil];
            rateView.tag = 333;
            [rateView show];
        }
        int new_num = [launch_num integerValue]+1;
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",new_num] forKey:[NSString stringWithFormat:@"launch_num_%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}

- (void) letUserRate
{
    int hasRate = [[[NSUserDefaults standardUserDefaults] valueForKey:@"has_rate"] integerValue];
    
    if (hasRate == 0) {
        NSString *launch_num = [[NSUserDefaults standardUserDefaults] valueForKey:@"launch_num"];
        int three = [[[NSUserDefaults standardUserDefaults] valueForKey:@"three"] integerValue];
        if (three == 0 && [launch_num integerValue]== 2) {
            UIAlertView *rateView = [[UIAlertView alloc] initWithTitle:@"给薇蜜评价" message:@"薇蜜好用咩？" delegate:self cancelButtonTitle:@"不再显示" otherButtonTitles:@"乖~赏你个5星好评！❤",@"用得不爽，我要告状…", nil];
            rateView.tag = 333;
            [rateView show];
            int new_num = [launch_num integerValue]+1;
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"three"];
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",new_num] forKey:@"launch_num"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else if ([launch_num integerValue]== 19) {
            UIAlertView *rateView = [[UIAlertView alloc] initWithTitle:@"给薇蜜评价" message:@"感谢使用薇蜜，请给薇蜜个评价吧~" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"发表评价", nil];
            rateView.tag = 333;
            [rateView show];
            [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"launch_num"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else if (!launch_num) {
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"launch_num"];
        }else {
            int new_num = [launch_num integerValue]+1;
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",new_num] forKey:@"launch_num"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 333 && (buttonIndex == 1 || buttonIndex == 2)) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_URL]];
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:[NSString stringWithFormat:@"has_rate_%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else if (alertView.tag == 333 && buttonIndex == alertView.cancelButtonIndex) {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:[NSString stringWithFormat:@"has_rate_%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if (alertView.tag == 20130530 && buttonIndex!=alertView.cancelButtonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NKConfig sharedConfig] storeURL]]];
    }
}

- (void)getUserOauthsOK:(NKRequest *)request {
    NSArray *oauths = [request.originDic valueForKeyPath:@"data.values"];
    _OauthArray = [oauths copy];
    if (oauths && [oauths isKindOfClass:[NSArray class]]) {
        NSMutableDictionary *accountOauth = [[NSMutableDictionary alloc] init];
        for (NSDictionary *oauth in oauths) {
            [accountOauth setObject:oauth[@"expired"] forKey:oauth[@"type"]];
        }
        [[[[[NKConfig sharedConfig] accountManagerClass] sharedAccountsManager] currentAccount] setOauth:accountOauth];
        [accountOauth release];
        [[NSNotificationCenter defaultCenter] postNotificationName:WMBindAccountDidUpdateNotification object:nil];
    }
}

- (void)getUserOauthsFailed:(NKRequest *)request {
    // TODO
}

- (void)refreshBindAccounts {
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(getUserOauthsOK:) andFailedSelector:@selector(getUserOauthsFailed:)];
    [[WMUserService sharedWMUserService] getUserOauthsWithRequestDelegate:rd];
}

- (void)loginDidFinish {
    [self refreshBindAccounts];
}

- (void)doInitialize {
    // 观察用户登录成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginDidFinish) name:NKLoginFinishNotificationKey object:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [ShareSDK registerApp:@"300529a480c"];
    [WXApi registerApp:@"wxc06686884e067c10"];
    [self initializePlat];
    _tabIndex = 0;
    [self umengTrack];
    [self doInitialize];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    [self configSomething];
    
    [self getSysytemForbid];
    //    if (!MobClickChannelId) {
    //
    //    }else {
    //        NSMutableDictionary *sysFunction = [NSMutableDictionary dictionaryWithDictionary:@{@"baoliao": @1, @"tab": @1, @"privacy": @0, @"purview": @1, @"scorebtn": @1, @"miyureport": @0}];
    //        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //        [defaults setObject:sysFunction forKey:@"sysFunction"];
    //        [defaults synchronize];
    //    }
    
    //[self letUserRate];
    [self rateThisApp];
    
    [self setupManUI];
    
    [self versionCheck:nil];
    [self startSocial];
    [self showSlides];
    
    [self checkUmengFeedback];
    
    //    NSDictionary *dic = [NSDictionary dictionaryWithObject:@"880" forKey:@"id"];
    //    WMMFeed *feed = [WMMFeed modelFromDic:dic];
    //    NKUI *ui = [NKUI sharedNKUI];
    //    [ui.navigator.tabs selectSegment:0 shouldTellDelegate:NO];
    //    [WMBaoliaoXiangqingViewController feedDetailWithFeed:feed];
    //    NSDictionary *dic = [NSDictionary dictionaryWithObject:@"1643405" forKey:@"id"];
    //    WMMUser *user = [WMMUser modelFromDic:dic];
    //    NKUI *ui = [NKUI sharedNKUI];
    //    [ui.navigator.tabs selectSegment:2 shouldTellDelegate:YES];
    //    WMHoneyView *honeyView = [WMHoneyView shareHoneyView:CGRectZero];
    //    honeyView.shouldReloadUserPage = YES;
    //    [honeyView relaodData:user];
    //    NKUI *ui = [NKUI sharedNKUI];
    //    [ui.navigator.tabs selectSegment:1 shouldTellDelegate:YES];
    //    WMDiscussViewController *vc = (WMDiscussViewController *)[ui showViewControllerWithClass:[WMDiscussViewController class]];
    //    [vc goToNotification:nil];
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7 && DEBUG) {
//            self.window.frame =  CGRectMake(0,20,self.window.frame.size.width,self.window.frame.size.height-20);
//        }
    return YES;
}

-(void)checkUmengFeedback
{
    UMFeedback *feedbackClient = [UMFeedback sharedInstance];
    [feedbackClient setAppkey:UMENG_APPKEY delegate:(id<UMFeedbackDataDelegate>)self];
    [feedbackClient get];
    //    从缓存取topicAndReplies
    //mFeedbackDatas = feedbackClient.topicAndReplies;
    
    
    
}


- (void)getFinishedWithError:(NSError *)error
{
    if (!error)
    {
        UMFeedback *feedbackClient = [UMFeedback sharedInstance];
        mFeedbackDatas = feedbackClient.topicAndReplies;
        int lastFeedbackCount = [[[NSUserDefaults standardUserDefaults] valueForKey:@"umengFeedbackCount"] integerValue];
        if (lastFeedbackCount==0) {
            return;
        }
        if ( [mFeedbackDatas count]>0 && [mFeedbackDatas count]>lastFeedbackCount) {
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",[mFeedbackDatas count]] forKey:@"umengFeedbackCount"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            _totalBadge3.hidden = NO;
            [MPNotificationView notifyWithText:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
                                        detail:@"你的反馈有新回复"
                                         image:[UIImage imageNamed:@"set_logo"]
                                   andDuration:3.0];
        }
    }
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        if (resp.errCode == 0) {
            if (_isShareWeixinToAddWeimi) {
                //为增加薇蜜个数而分享到微信成功
                [[NSNotificationCenter defaultCenter] postNotificationName:WMShareToWeixiTimelineDidSuccessNotification object:nil];
                _isShareWeixinToAddWeimi = NO;
            }
            [KGStatusBar showSuccessWithStatus:@"分享成功"];
        }else {
            [KGStatusBar showSuccessWithStatus:@"分享失败"];
        }
        
    }
    
}

-(void)setupManUI
{
    _shouldHideNoti = NO;
    NKUI *ui = [NKUI sharedNKUI];
    ui.needLogin = YES;
    ui.needStoreViewControllers = NO;
    ui.homeClass = [WMMiyuViewController class];
    ui.welcomeCalss = [WMWelcomeViewController class];
    
    [ui addTabs:[NSArray arrayWithObjects:[NSArray arrayWithObjects:
                                           [NKSegment segmentWithNormalBack:[UIImage imageNamed:@"tab_miyu_normal"] selectedBack:[UIImage imageNamed:@"tab_miyu_click"]],
                                           [NKSegment segmentWithNormalBack:[UIImage imageNamed:@"tab_mojing_normal"] selectedBack:[UIImage imageNamed:@"tab_mojing_click"]],
                                           [NKSegment segmentWithNormalBack:[UIImage imageNamed:@"tab_more_normal"] selectedBack:[UIImage imageNamed:@"tab_more_click"]],
                                           
                                           nil],
                 [NSArray arrayWithObjects:[WMMiyuViewController class],[WMMojingViewController class], [WMSettingViewController class], nil],
                 nil]];
    
    NKNavigationController *navi = [[[NKNavigationController alloc] initWithRootViewController:ui] autorelease];
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
    
    //UIButton *topicButton_t = [ui.navigator.tabs.segments objectAtIndex:1];
    UIButton *homeButton_t = [ui.navigator.tabs.segments objectAtIndex:0];

    UIButton *mojingButton_t = [ui.navigator.tabs.segments objectAtIndex:1];
    UIButton *noticeButton_t = [ui.navigator.tabs.segments objectAtIndex:2];
    
//    NKBadgeView *topicBadge = [[NKBadgeView alloc] initWithFrame:CGRectMake(50, 12, 14, 14)];
//    topicBadge.numberLabel.hidden = YES;
//    topicBadge.placeHolderImage = [[UIImage imageNamed:@"xiaohongdian"] resizeImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
//    topicBadge.highlightedImage = [[UIImage imageNamed:@"xiaohongdian"] resizeImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
//    [topicBadge bindValueOfModel:[WMNotificationCenter sharedNKNotificationCenter] forKeyPath:@"hasNotification"];
//    [topicButton_t addSubview:topicBadge];
//    [topicBadge release];
    
    NKBadgeView *feedBadge = [[NKBadgeView alloc] initWithFrame:CGRectMake(50, 12, 14, 14)];
    feedBadge.numberLabel.hidden = YES;
    feedBadge.placeHolderImage = [[UIImage imageNamed:@"xiaohongdian"] resizeImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    feedBadge.highlightedImage = [[UIImage imageNamed:@"xiaohongdian"] resizeImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [feedBadge bindValueOfModel:[WMNotificationCenter sharedNKNotificationCenter] forKeyPath:@"hasNewFeed"];
    [homeButton_t addSubview:feedBadge];
    [feedBadge release];
    
    NKBadgeView *feedBadge2 = [[NKBadgeView alloc] initWithFrame:CGRectMake(50, 12, 14, 14)];
    feedBadge2.numberLabel.hidden = YES;
    feedBadge2.placeHolderImage = [[UIImage imageNamed:@"xiaohongdian"] resizeImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    feedBadge2.highlightedImage = [[UIImage imageNamed:@"xiaohongdian"] resizeImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [feedBadge2 bindValueOfModel:[WMNotificationCenter sharedNKNotificationCenter] forKeyPath:@"hasNewMessage"];
    [homeButton_t addSubview:feedBadge2];
    [feedBadge2 release];
    
    
    NKBadgeView *totalBadge = [[NKBadgeView alloc] initWithFrame:CGRectMake(40, 12, 14, 14)];
    
    // Remove the number label
    [totalBadge.numberLabel removeFromSuperview];
    totalBadge.numberLabel = nil;
    
    totalBadge.placeHolderImage = [[UIImage imageNamed:@"xiaohongdian"] resizeImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    totalBadge.highlightedImage = [[UIImage imageNamed:@"xiaohongdian"] resizeImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [totalBadge bindValueOfModel:[WMNotificationCenter sharedNKNotificationCenter] forKeyPath:@"hasRequest"];
    [noticeButton_t addSubview:totalBadge];
    [totalBadge release];
    
    
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"showCoupleTest"] boolValue]) {
        _totalBadge2 = [[NKBadgeView alloc] initWithFrame:CGRectMake(40, 12, 14, 14)];
        
        // Remove the number label
        [_totalBadge2.numberLabel removeFromSuperview];
        _totalBadge2.numberLabel = nil;
        
        _totalBadge2.placeHolderImage = [[UIImage imageNamed:@"xiaohongdian"] resizeImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        _totalBadge2.highlightedImage = [[UIImage imageNamed:@"xiaohongdian"] resizeImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [mojingButton_t addSubview:_totalBadge2];
        [_totalBadge2 release];
    }
    
    _totalBadge3 = [[NKBadgeView alloc] initWithFrame:CGRectMake(40, 12, 14, 14)];
    
    // Remove the number label
    [_totalBadge3.numberLabel removeFromSuperview];
    _totalBadge3.numberLabel = nil;
    
    _totalBadge3.placeHolderImage = [[UIImage imageNamed:@"xiaohongdian"] resizeImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    _totalBadge3.highlightedImage = [[UIImage imageNamed:@"xiaohongdian"] resizeImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [noticeButton_t addSubview:_totalBadge3];
    _totalBadge3.hidden = YES;
    [_totalBadge3 release];
    
    
    
    
}



-(void)startSocial{
    
    [[NKSocial social] startSinaWeiboWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:nil];
    
}

-(void)showSlides{
    
    if ( ![NKSystemInfo currentVersionString] || [[NKSystemInfo currentVersionString] versionStringCompare:[NKSystemInfo versionString]] == NSOrderedAscending) {
        [NKSystemInfo updateVersion];
        
        [[WMSystemService sharedWMSystemService] showSlide];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NKLocationService sharedNKLocationService] findLocation];
    if ([[KKPasscodeLock sharedLock] isPasscodeRequired]) {
        KKPasscodeViewController *vc = [[KKPasscodeViewController alloc] initWithNibName:nil bundle:nil];
        vc.mode = KKPasscodeModeEnter;
        vc.delegate = self;
        
        dispatch_async(dispatch_get_main_queue(),^ {
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            nav.navigationBarHidden = YES;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                nav.modalPresentationStyle = UIModalPresentationFormSheet;
                nav.navigationBar.barStyle = UIBarStyleBlack;
                nav.navigationBar.opaque = NO;
            } else {
                nav.navigationBar.tintColor = NKNC.navigationBar.tintColor;
                nav.navigationBar.translucent = NKNC.navigationBar.translucent;
                nav.navigationBar.opaque = NKNC.navigationBar.opaque;
                nav.navigationBar.barStyle = NKNC.navigationBar.barStyle;
            }
            
            [NKNC presentModalViewController:nav animated:YES];
        });
        
    }
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
	// post the token to server
    NSLog(@"%@",deviceToken);
    [[WMNotificationCenter sharedNKNotificationCenter] postDeviceToken:deviceToken];
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [[NSUserDefaults standardUserDefaults] setValue:userInfo forKey:@"pushUserInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:NKRemoteNotificationKey object:userInfo];
    
    [[WMNotificationCenter sharedNKNotificationCenter] getNotificationsCount];
    if (application.applicationState != UIApplicationStateActive) {
        // Do some Jump
        [self jumpWithApn:[userInfo objectOrNilForKey:@"acme"]];
    }
    BOOL shouldHideNotiView = _shouldHideNoti;//= [[[NSUserDefaults standardUserDefaults] valueForKey:@"notiHide"] boolValue];
    if (application.applicationState == UIApplicationStateActive && !shouldHideNotiView)
        
    {
        [MPNotificationView notifyWithText:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
                                    detail:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
                                     image:[UIImage imageNamed:@"set_logo"]
                               andDuration:3.0];
    }
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
	NSLog(@"APNError%@", error);
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    // Renren SDK
    if ([[url description] rangeOfString:@"rm228074"].location != NSNotFound) {
        return [RennClient handleOpenURL:url];
    }
    
    if ([[url description] rangeOfString:@"tencent100416233"].location != NSNotFound) {
        return [TencentOAuth HandleOpenURL:url];
    }
    
    if ([[url description] rangeOfString:@"tencent100497175"].location != NSNotFound) {
        return [TencentOAuth HandleOpenURL:url];
    }
    
    if (_isLogin) {
        return [[NKSocial social] handleAppDelegateOpenURL:url];
    }
    
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // Renren SDK
    if ([[url description] rangeOfString:@"rm228074"].location != NSNotFound) {
        return [RennClient handleOpenURL:url];
    }
    
    if ([[url description] rangeOfString:@"tencent100416233"].location != NSNotFound) {
        return [TencentOAuth HandleOpenURL:url];
    }
    
    if ([[url description] rangeOfString:@"tencent100497175"].location != NSNotFound) {
        return [TencentOAuth HandleOpenURL:url];
    }
    
    if ([[url description] rangeOfString:@"wxc06686884e067c10"].location != NSNotFound) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    if (_isLogin) {
        return [[NKSocial social] handleAppDelegateOpenURL:url];
    }
    
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
}

-(void)jumpWithApn:(NSDictionary*)apnDic{
    [[NSUserDefaults standardUserDefaults] setValue:apnDic forKey:@"apnDic"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [UIView animateWithDuration:1.0 animations:^{
        ;
    } completion:^(BOOL finished) {
        if (![WMMUser me]) {
            return;
        }
        
        [NKNC popToRootViewControllerAnimated:NO];
        
        NSString *apnType = [apnDic objectOrNilForKey:@"type"];
        
        if ([apnType isEqualToString:@"miyu"]) {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:[apnDic objectOrNilForKey:@"id"] forKey:@"id"];
            WMMFeed *feed = [WMMFeed modelFromDic:dic];
            NKUI *ui = [NKUI sharedNKUI];
            [ui.navigator.tabs selectSegment:2 shouldTellDelegate:YES];
            [WMFeedDetailViewController feedDetailWithFeed:feed];
            
        }
        else if ([apnType isEqualToString:@"feed"]) {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:[apnDic objectOrNilForKey:@"id"] forKey:@"id"];
            WMMFeed *feed = [WMMFeed modelFromDic:dic];
            NKUI *ui = [NKUI sharedNKUI];
            [ui.navigator.tabs selectSegment:0 shouldTellDelegate:YES];
            [WMBaoliaoXiangqingViewController feedDetailWithFeed:feed];
            
        }
        else if ([apnType isEqualToString:@"user"]) {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:[apnDic objectOrNilForKey:@"id"] forKey:@"id"];
            WMMUser *user = [WMMUser modelFromDic:dic];
            NKUI *ui = [NKUI sharedNKUI];
            [ui.navigator.tabs selectSegment:2 shouldTellDelegate:YES];
            WMHoneyView *honeyView = [WMHoneyView shareHoneyView:CGRectZero];
            honeyView.shouldReloadUserPage = YES;
            [honeyView relaodData:user];
        }else if ([apnType isEqualToString:@"topic"]) {
            NKUI *ui = [NKUI sharedNKUI];
            [ui.navigator.tabs selectSegment:1 shouldTellDelegate:YES];
            WMDiscussViewController *vc = (WMDiscussViewController *)[ui showViewControllerWithClass:[WMDiscussViewController class]];
            [vc goToNotification:nil];
            
        }else if ([apnType isEqualToString:@"topic_show"]) {
            NKUI *ui = [NKUI sharedNKUI];
            [ui.navigator.tabs selectSegment:1 shouldTellDelegate:YES];
            [WMDiscussDetailViewController topicDetailWithTopicid:[apnDic objectOrNilForKey:@"id"]];
        }else if ([apnType isEqualToString:@"man"]) {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:[apnDic objectOrNilForKey:@"id"] forKey:@"id"];
            WMMMan *man = [WMMMan modelFromDic:dic];
            [WMManDetailViewController manDetailWithMan:man];
        }else if ([apnType isEqualToString:@"near"]) {
            NKUI *ui = [NKUI sharedNKUI];
            WMMenWikiFristViewController *menWikiViewController = (WMMenWikiFristViewController *)[ui showViewControllerWithClass:[WMMenWikiFristViewController class]];
            [menWikiViewController showNearView];
        }else if ([apnType isEqualToString:@"im"]) {
            NSDictionary *dic = @{@"id":[apnDic objectOrNilForKey:@"id"]};
            WMMUser *user = [WMMUser modelFromDic:dic];
            NKUI *ui = [NKUI sharedNKUI];
            [ui.navigator.tabs selectSegment:2 shouldTellDelegate:YES];
            WMHoneyView *honeyView = [WMHoneyView shareHoneyView:CGRectZero];
            honeyView.shouldReloadUserPage = YES;
            [honeyView relaodData:user];
            [WMConverstionViewController conversationViewControllerForUser:user];
        }
        
    }];
    
    
    
    
}

#pragma mark Version


-(void)versionCheck:(id)sender{
    
    dispatch_queue_t concurrentQueue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        
        NSString *versionString = [NKSystemInfo versionString];
        NSString *server = ZUOVersionProduct;
        
        if ([versionString rangeOfString:@"rc"].length) {
            server = ZUOVersionRC;
        }
        
        __block NSDictionary *versionDic = nil;
        dispatch_sync(concurrentQueue, ^{
            versionDic = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:server]];
            
        });
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"store url: %@",[versionDic objectOrNilForKey:@"appURL"]);
            [[NKConfig sharedConfig] setStoreURL:[versionDic objectOrNilForKey:@"appURL"]];
            
            if ([versionString versionStringCompare:[versionDic objectOrNilForKey:@"version"]] == NSOrderedAscending) {
                
                [[NKConfig sharedConfig] setShowVersion:[NSString stringWithFormat:@"%@/%@", versionString, [versionDic objectOrNilForKey:@"version"]]];
                
                if ([[versionDic objectOrNilForKey:@"needAlert"] boolValue]) {
                    UIAlertView *updateView = [[UIAlertView alloc] initWithTitle:[versionDic objectOrNilForKey:@"title"]
                                                                         message:[versionDic objectOrNilForKey:@"description"]
                                                                        delegate:self
                                                               cancelButtonTitle:@"稍后提醒"
                                                               otherButtonTitles:@"现在更新", nil];
                    updateView.tag = 20130530;
                    [updateView show];
                    [updateView release];
                }
            }
            
            else{
                
                
                [[NKConfig sharedConfig] setShowVersion:versionString];
            }
            
        });
    });
    
    
    
    
}





@end
