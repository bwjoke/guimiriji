//
//  WMOauthViewController.m
//  WEIMI
//
//  Created by steve on 13-9-23.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//
#import "WMAppDelegate.h"
#import "WMOauthViewController.h"
#import "WMConfig.h"

@interface WMOauthViewController ()
{
    UITableView *oauthTableView;
    TencentOAuth *_tencentOAuth;
}
@end

@implementation WMOauthViewController

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
	// Do any additional setup after loading the view.
    self.titleLabel.text = @"绑定账号";
    [self.showTableView removeFromSuperview];
    self.showTableView = nil;
    oauthTableView = [[UITableView alloc] initWithFrame:oauthTableView.frame style:UITableViewStyleGrouped];
    oauthTableView.delegate = self;
    oauthTableView.dataSource = self;
    oauthTableView.backgroundView = nil;
    oauthTableView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:oauthTableView];
    [self.headBar insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_head_back"]] atIndex:0];
    [self addHeadShadow];
    [self addBackButton];
    oauthTableView.frame = CGRectMake(0, 44, 320, SCREEN_HEIGHT-66);
    oauthTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [[WMAppDelegate shareAppDelegate] refreshBindAccounts];

}

- (void)bindAccountsDidUpdate {
    [oauthTableView reloadData];
}

-(void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"OauthCellIdentifier";
    WMOauthCell *cell = (WMOauthCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[WMOauthCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if ([[self oauth] valueForKey:@"weibo"]|| [[self oauth] valueForKey:@"renren"] || [[self oauth] valueForKey:@"qq"]) {
        [cell showIndex:indexPath.row shouldShowLoad:NO];
    }else {
        [cell showIndex:indexPath.row shouldShowLoad:YES];
    }
    
    return cell;
}

- (NSMutableDictionary *)oauth {
    return [[[[[NKConfig sharedConfig] accountManagerClass] sharedAccountsManager] currentAccount] oauth];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: {
            if (self.oauth[@"weibo"]) {
                if ([self.oauth[@"weibo"] boolValue]) { // Expired
                    [self loginWithWeibo];
                } else {
                    [self enterBindDetail:@"weibo"];
                }
            } else {
                [self loginWithWeibo];
            }
            break;
        }
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
            break;
        }
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
    [oauthTableView reloadData];
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

-(void)loginWithRenren
{
    [RennClient loginWithDelegate:self];
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

#pragma mark -

- (void)bindRenrenOK {
    [self.oauth setObject:@NO forKey:@"renren"];
    [oauthTableView reloadData];
    ProgressSuccess(@"绑定成功");
}

- (void)renrenBindFailed:(NKRequest *)request {
    [self removeRenRenAccessToken];
    ProgressErrorDefault;
}

//绑定QQ
-(void)loginWithQQ {
    [[self tencentOAuth] authorize:@[@"get_user_info"] inSafari:NO];
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
    [oauthTableView reloadData];
    ProgressSuccess(@"绑定成功");
}

- (void)bindQQFailed:(NKRequest *)request {
    ProgressErrorDefault;
}

#pragma mark - Lazy loading

- (TencentOAuth *)tencentOAuth {
    if (_tencentOAuth) {
        return _tencentOAuth;
    }
    
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"100497175" andDelegate:self];
    
    return _tencentOAuth;
}

// 进入绑定的详情页
- (void)enterBindDetail:(NSString *)type {
    WMBindDetailViewController *vc = [[WMBindDetailViewController alloc] init];
    vc.type = type;
    vc.delegate = self;
    [NKNC pushViewController:vc animated:YES];
}

- (void)removeRenRenAccessToken {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"access_Token"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack:(id)sender {
    [super goBack:sender];
    
    if (self.goBackAction) {
        self.goBackAction();
    }
}

@end
