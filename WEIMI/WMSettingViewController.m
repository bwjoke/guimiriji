//
//  WMSettingViewController.m
//  WEIMI
//
//  Created by King on 11/14/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//

#import "WMSettingViewController.h"
#import "NKAccountManager.h"
#import "WMSettingCell.h"
#import "WMPersonalSettingViewController.h"
#import "WMHoneyListViewController.h"
#import "WMAboutViewController.h"
#import "FeedbackViewController.h"
#import "WMHoneyView.h"
#import "WMAppWallViewController.h"

#import "WMAppDelegate.h"
#import "WMTopicService.h"
#import "WMMTopic.h"
#import <ShareSDK/ShareSDK.h>
#import "WMErrorGenderViewController.h"
#import "WMConfig.h"
#import "WMAppDelegate.h"

@interface WMSettingViewController () <TencentLoginDelegate>
{
    int notificationCount;
    TencentOAuth *_tencentOAuth;
}

@property (nonatomic, retain) UITableView *settingTableView;

// 返回当前账号绑定的社交账号数组
- (NSMutableDictionary *)oauth;

@end

#define SHARETITLE @"薇蜜-女生闺蜜必备手机APP"
#define WEIXINTEXT @"闺蜜姐妹专属私密分享，八卦爆料社区。匿名点评男友男同学男上司男明星…想知道他们有没有小三小四，曾经谈过多少个女朋友吗？"
#define WEIBOTEXT @"#女生闺蜜专属APP# 我在薇蜜，姐妹们在哪里~ 薇蜜手机APP下载：http://www.weimi.com/app?from=weibo"
#define SMSTEXT @"#女生闺蜜专属APP# 我在薇蜜，姐妹们在哪里~ 薇蜜手机APP下载：http://www.weimi.com/app?from=sms"
#define QQZONETEXT @"#女生闺蜜专属APP# 我在薇蜜，姐妹们在哪里~ 薇蜜手机APP下载：http://www.weimi.com/app?from=qzone"
#define TENCENTTEXT @"#女生闺蜜专属APP# 我在薇蜜，姐妹们在哪里~薇蜜手机APP下载：http://www.weimi.com/app?from=tqq"
#define RENRENTEXT @"#女生闺蜜专属APP# 我在薇蜜，姐妹们在哪里~ 薇蜜手机APP下载：http://www.weimi.com/app?from=renren"


@implementation WMSettingViewController

- (void)dealloc {
    _umFeedback.delegate = nil;
    [_settingTableView release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindAccountsDidUpdate) name:WMBindAccountDidUpdateNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.headBar setHidden:YES];
    
    [self.showTableView removeFromSuperview];
    self.showTableView = nil;
    
    self.settingTableView = [[[UITableView alloc] initWithFrame:CGRectMake(15, 15, 290, SCREEN_HEIGHT - 85) style:UITableViewStyleGrouped] autorelease];
    self.settingTableView.backgroundView = nil;
    self.settingTableView.backgroundColor = [UIColor clearColor];
    self.settingTableView.dataSource = self;
    self.settingTableView.delegate = self;
    self.settingTableView.scrollEnabled = YES;
    [self.contentView addSubview:self.settingTableView];
    
    notificationCount = 0;
    
    // Get the latest bind accounts
    WMAppDelegate *delegate = (WMAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate refreshBindAccounts];
    
    if ([[[WMAppDelegate shareAppDelegate] totalBadge3] isHidden]) {
        [self checkUmengFeedback];
    }
    
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
        if (lastFeedbackCount == 0) {
            [[[WMAppDelegate shareAppDelegate] totalBadge3] setHidden:YES];
            return;
        }
        if ([mFeedbackDatas count]>0 && [mFeedbackDatas count]>lastFeedbackCount) {
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",[mFeedbackDatas count]] forKey:@"umengFeedbackCount"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[[WMAppDelegate shareAppDelegate] totalBadge3] setHidden:NO];
            [MPNotificationView notifyWithText:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
                                        detail:@"你的反馈有新回复"
                                         image:[UIImage imageNamed:@"set_logo"]
                                   andDuration:3.0];
        }else {
            [[[WMAppDelegate shareAppDelegate] totalBadge3] setHidden:YES];
        }
    }
}

- (void)bindAccountsDidUpdate {
    [self.settingTableView reloadData];
}

-(int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}


-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 3; // If open QQ binding, return 3
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 4;
            break;
        case 4:
            return 1;
            break;
        default:
            return 1;
            break;
    }
    
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeader = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)] autorelease];
    UIImageView *iconView = [[[UIImageView alloc] initWithFrame:CGRectMake(20, 14, 15, 15)] autorelease];
    [sectionHeader addSubview:iconView];
    UILabel *tLabel = [[[UILabel alloc] initWithFrame:CGRectMake(40, 13, 100, 15)] autorelease];
    tLabel.backgroundColor = [UIColor clearColor];
    tLabel.font = [UIFont systemFontOfSize:14];
    tLabel.textColor = [UIColor colorWithHexString:@"#A6937C"];
    [sectionHeader addSubview:tLabel];
    
    switch (section) {
        case 0:{
            iconView.image = [UIImage imageNamed:@"icon_setting"];
            tLabel.text = @"设置";
            return sectionHeader;
            break;
        }
            
        default:
            break;
    }
    
    return sectionHeader;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"WMSettingCellIdentifier";
    static NSString * CellIdentifierForBind = @"WMSettingCellIdentifierForBind";
    
    NSString *cellId = nil;
    
    if (indexPath.section == 2) {
        cellId = CellIdentifierForBind;
    } else {
        cellId = CellIdentifier;
    }
    
    WMSettingCell *cell = (WMSettingCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[WMSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
    }
    [cell showIndexPath:indexPath dataSource:self.dataSource hasNotification:notificationCount];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.dataSource count] > 0) {
        if (section == 0 || section == 2) {
            return 39;
        }
    }else if(section == 0) {
        return 39;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case -1:{
            WMCoupleTestViewController *coupleTestViewController = [[WMCoupleTestViewController alloc] initWithNibName:nil bundle:nil];
//            coupleTestViewController.goBackAction = ^(){
//                [self.settingTableView reloadData];
//            };
            [NKNC pushViewController:coupleTestViewController animated:YES];
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"showCoupleTest"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[[WMAppDelegate shareAppDelegate] totalBadge2] setHidden:YES];
            break;
        }
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    WMPersonalSettingViewController *personSettingViewController = [[[WMPersonalSettingViewController alloc] initWithNibName:nil bundle:nil] autorelease];
                    [NKNC pushViewController:personSettingViewController animated:YES];
                    break;
                }
                case 1:{
                    WMHoneyListViewController *honeyListViewController = [[[WMHoneyListViewController alloc] initWithNibName:nil bundle:nil] autorelease];
                    [NKNC pushViewController:honeyListViewController animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:{
            switch (indexPath.row) {
                case 0:{
                    
                    if (self.oauth[@"weibo"]) {
                        if ([self.oauth[@"weibo"] boolValue]) { // Expired
                            [self loginWithWeibo];
                        } else {
                            [self enterBindDetail:@"weibo"];
                        }
                    } else {
                        [self loginWithWeibo];
                    }
                }
                    break;
                case 1:{
                    if (self.oauth[@"renren"]) {
                        if ([self.oauth[@"renren"] boolValue]) { // Expired
                            [self loginWithRenren];
                        } else {
                            [self enterBindDetail:@"renren"];
                        }
                    } else {
                        [self loginWithRenren];
                    }
                }
                    break;
                case 2:{
                    if (self.oauth[@"qq"]) {
                        if ([self.oauth[@"qq"] boolValue]) { // Expired
                            [self loginWithQQ];
                        } else {
                            [self enterBindDetail:@"qq"];
                        }
                    } else {
                        [self loginWithQQ];
                    }
                }
                    break;
                default:
                    break;
            }
            break;
        }
        case 2:{
            //分享
            //[self initShare];
            [self shareAllButtonClickHandler:nil];
            break;
        }
        case 3:{
            switch (indexPath.row) {
                case 0:{
                    //关于
                    WMAboutViewController *aboutViewController = [[[WMAboutViewController alloc] initWithNibName:nil bundle:nil] autorelease];
                    [NKNC pushViewController:aboutViewController animated:YES];
                    break;
                }
                case 1:{
                    [self upgrage:self];
                    break;
                }
                case 2:
                    //好评
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_URL]];
                    break;
                case 3:{
                    //建议反馈
                    if (![[[WMAppDelegate shareAppDelegate] totalBadge3] isHidden]) {
                        [[[WMAppDelegate shareAppDelegate] totalBadge3] setHidden:YES];
                    }
                    [self.settingTableView reloadData];
                    //                    _umFeedback = [UMFeedback sharedInstance];
                    //                    [_umFeedback setAppkey:UMENG_APPKEY delegate:self];
                    FeedbackViewController *feedbackViewController = [[FeedbackViewController alloc] initWithNibName:@"FeedbackViewController" bundle:nil];
                    UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:feedbackViewController] autorelease];
                    [NKNC presentModalViewController:navigationController animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 4:{
            //应用推荐
            WMAppWallViewController *appWallViewController = [[[WMAppWallViewController alloc] init] autorelease];
            [NKNC pushViewController:appWallViewController animated:YES];
            break;
        }
        default:
            break;
    }
}

// 绑定微博

-(void)loginWithWeibo
{
    WMAppDelegate *appDelegate = [WMAppDelegate shareAppDelegate];
    appDelegate.isLogin = YES;
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(loginWithWeiboOK:) andFailedSelector:@selector(loginWithWeiboFailed:)];
    [[NKSocial social] loginWithSinaWeiboWithRequestDelegate:rd];
}

-(void)loginWithWeiboOK:(NKRequest*)request {
    NSString *uid = [[[NKSocial social] sinaWeibo] userID];
    NSString *token = [[[NKSocial social] sinaWeibo] accessToken];
    
    Progress(@"正在绑定");
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(weiboBindOK) andFailedSelector:@selector(weiboBindFailed:)];
    [[NKUserService sharedNKUserService] socialBindWithType:@"weibo" uid:uid token:token andRequestDelegate:rd];
}

-(void)loginWithWeiboFailed:(NKRequest*)request{
    // TODO
}

- (void)weiboBindOK {
    [self.oauth setObject:@NO forKey:@"weibo"];
    [self.settingTableView reloadData];
    ProgressSuccess(@"绑定成功");
}

- (void)weiboBindFailed:(NKRequest *)request {
    [self removeWeiboAccessToken];
    ProgressErrorDefault;
}

- (void)removeWeiboAccessToken {
    [[[NKSocial social] sinaWeibo] setAccessToken:nil];
}

// 绑定人人

-(void)loginWithRenren {
    [RennClient loginWithDelegate:self];
}

-(void)loginWithQQ {
    [[self tencentOAuth] authorize:@[@"get_user_info"] inSafari:NO];
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

#pragma mark - Renren request delegate

- (void)rennService:(RennService *)service requestSuccessWithResponse:(id)response {
    Progress(@"正在绑定");
    
    NSString *uid = response[@"id"];
    NSString *token = [RennClient accessToken].accessToken;
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(bindRenrenOK) andFailedSelector:@selector(renrenBindFailed:)];
    [[NKUserService sharedNKUserService] socialBindWithType:@"renren" uid:uid token:token andRequestDelegate:rd];
}

- (void)rennService:(RennService *)service requestFailWithError:(NSError*)error {
    // TODO
}

#pragma mark - QQ request delegate

- (void)tencentDidLogin {
    NSString *uid = [self tencentOAuth].openId;
    NSString *token = [self tencentOAuth].accessToken;
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(bindQQOK) andFailedSelector:@selector(bindQQFailed:)];
    
    progressView = [NKProgressView progressViewForView:self.view];
    progressView.labelText = @"正在绑定";
    
    [[NKUserService sharedNKUserService] socialBindWithType:@"qq" uid:uid token:token andRequestDelegate:rd];
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    ProgressFailedWith(@"绑定失败，请重新绑定");
}

- (void)tencentDidNotNetWork {
    ProgressFailedWith(@"绑定失败，请重新绑定");
}

#pragma mark -

- (void)bindQQOK {
    [self.oauth setObject:@NO forKey:@"qq"];
    [self.settingTableView reloadData];
    ProgressSuccess(@"绑定成功");
}

- (void)bindQQFailed:(NKRequest *)request {
    ProgressErrorDefault;
}

#pragma mark -

- (void)bindRenrenOK {
    [self.oauth setObject:@NO forKey:@"renren"];
    [self.settingTableView reloadData];
    ProgressSuccess(@"绑定成功");
}

- (void)renrenBindFailed:(NKRequest *)request {
    [self removeRenRenAccessToken];
    ProgressErrorDefault;
}

// 进入绑定的详情页
- (void)enterBindDetail:(NSString *)type {
    WMBindDetailViewController *vc = [[WMBindDetailViewController alloc] init];
    vc.type = type;
    vc.delegate = self;
    [NKNC pushViewController:vc animated:YES];
    [vc release];
}

#pragma mark - WMBindDetailViewDelegate
- (void)unbindDidSuccess:(NSString *)type {
    [NKNC popViewControllerAnimated:YES];
    [self.oauth removeObjectForKey:type];
    [self.settingTableView reloadData];
}

- (void)removeRenRenAccessToken {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"access_Token"];
}

- (void)shareAllButtonClickHandler:(UIButton *)sender
{
    WMAppDelegate *appDelegate = [WMAppDelegate shareAppDelegate];
    appDelegate.isLogin = NO;
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"shareIcon" ofType:@"png"];
    NSString *bigImagePath = [[NSBundle mainBundle] pathForResource:@"weibo_share" ofType:@"jpg"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:WEIBOTEXT
                                       defaultContent:@""
                                                image:[ShareSDK imageWithPath:bigImagePath]
                                                title:@"薇蜜"
                                                  url:@"http://www.weimi.com/app?from=weibo"
                                          description:@"薇蜜"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    ///////////////////////
    //以下信息为特定平台需要定义分享内容，如果不需要可省略下面的添加方法
    
    //定制人人网信息
    [publishContent addRenRenUnitWithName:SHARETITLE
                              description:@"让天下没有难懂的男人。女生匿名对男友前男友、男明星、男同学、男同事男上司点评打分、八卦爆料的社交应用，这里有让@留几手都无法直视的气场。"
                                      url:@"http://www.weimi.com/?from=renren"
                                  message:RENRENTEXT
                                    image:[ShareSDK imageWithPath:bigImagePath]
                                  caption:@"(⊙ˍ⊙) 可以点评男友的手机APP"];
    //定制QQ空间信息
    [publishContent addQQSpaceUnitWithTitle:SHARETITLE
                                        url:@"http://www.weimi.com/app?from=qzone"
                                       site:@"薇蜜-男友点评"
                                    fromUrl:@"http://www.weimi.com"
                                    comment:QQZONETEXT
                                    summary:@"让天下没有难懂的男人。女生匿名对男友前男友、男明星、男同学、男同事男上司点评打分、八卦爆料的社交应用，这里有让@留几手都无法直视的气场。"
                                      image:INHERIT_VALUE
                                       type:[NSNumber numberWithInt:4]
                                    playUrl:nil
                                       nswb:[NSNumber numberWithInt:0]];
    
    //定制微信好友信息
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:WEIXINTEXT
                                           title:@"薇蜜 - 闺蜜必备手机APP"
                                             url:@"http://www.weimi.com/app?from=weixinmsg"
                                           image:[ShareSDK imageWithPath:imagePath]
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    //定制微信朋友圈信息
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                          content:@"闺蜜姐妹专属私密分享，匿名点评八卦爆料社区。一个可以点评男盆友的闺蜜应用……"
                                            title:@"薇蜜 - 闺蜜必备手机APP"
                                              url:[NSString stringWithFormat:@"http://www.weimi.com/app?ref=wxmoment_%@", [[WMMUser me] mid]]
                                            image:[ShareSDK imageWithPath:imagePath]
                                     musicFileUrl:@""
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    
    [publishContent addQQUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                              content:@"闺蜜姐妹专属私密分享，匿名点评八卦爆料社区。男友前男友男同学男同事男上司男明星……想知道他们有没有小三小四，曾经谈过多少个女朋友吗？天下再也没有看不透的男人！！"
                                title:@"薇蜜-男友点评"
                                  url:@"http://www.weimi.com/app?from=qzone"
                                image:[ShareSDK imageWithPath:imagePath]];
    
    [publishContent addSMSUnitWithContent:SMSTEXT];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    
    
    //    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"薇蜜分享"
    //                                                              oneKeyShareList:[ShareSDK getShareListWithType:ShareTypeSinaWeibo,ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeQQ,ShareTypeTencentWeibo,ShareTypeQQSpace,ShareTypeRenren,ShareTypeSMS, nil]
    //                                                               qqButtonHidden:YES
    //                                                        wxSessionButtonHidden:YES
    //                                                       wxTimelineButtonHidden:YES
    //                                                         showKeyboardOnAppear:NO
    //                                                            shareViewDelegate:nil
    //                                                          friendsViewDelegate:nil
    //                                                        picViewerViewDelegate:nil];
    
    id<ISSShareOptions> shareOptions =[ShareSDK simpleShareOptionsWithTitle:@"薇蜜分享" shareViewDelegate:nil];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:[ShareSDK getShareListWithType:ShareTypeSinaWeibo,ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeQQ,ShareTypeTencentWeibo,ShareTypeQQSpace,ShareTypeRenren,ShareTypeSMS, nil]
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:shareOptions
                            result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
    
    
}

-(void)upgrage:(id)sender{
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
                UIAlertView *updateView = [[UIAlertView alloc] initWithTitle:@"不需要更新"
                                                                     message:@"已经是最新版本了"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil, nil];
                [updateView show];
                [updateView release];
                
                [[NKConfig sharedConfig] setShowVersion:versionString];
            }
            
        });
    });
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 20130530 && buttonIndex!=alertView.cancelButtonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NKConfig sharedConfig] storeURL]]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableDictionary *)oauth {
    return [[[[[NKConfig sharedConfig] accountManagerClass] sharedAccountsManager] currentAccount] oauth];
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
