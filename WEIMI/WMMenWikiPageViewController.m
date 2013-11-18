//
//  WMMenWikiPageViewController.m
//  WEIMI
//
//  Created by steve on 13-7-19.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMMenWikiPageViewController.h"
#import "WMNotificationCenter.h"
#import "WMHelpView.h"
#import "WMAppDelegate.h"
#import "WMCustomLabel.h"
#import "WMUniversity.h"
#import "WMUniversityService.h"
#import "WMUniversityMenCell.h"

@interface WMMenWikiPageViewController ()
{
    WMCustomLabel *gpsLabel;
}

@property (nonatomic, unsafe_unretained) UIButton *provinceButton;
@property (nonatomic, unsafe_unretained) UIButton *universityButton;

@end

@implementation WMMenWikiPageViewController

#define SHARE_TAG 112320
#define SHOW_REPORT_SHEET 13062401
#define REPORT_SHEET 13062402
#define HEAD_TAG 13072301
#define DISTANCE_SHEET 13090201
#define TYPE_SHEET 13090202

#define NOGPS @"需要在手机设置->隐私->开启定位服务\n以看到附近的八卦点评"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithPageNumber:(int)page
{
    if (self = [super initWithNibName:nil bundle:nil])
    {
        pageNumber = page;
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([_category isEqualToString:@"xiaoyuan"]) {
        if ([[[WMMUser me] universityName] length] && [[[WMMUser me] universityProvinceName] length]) {
            [self showCampus];
        } else {
            [self getUserInfo];
        }
        
    }
    
}

-(void)reloadPage
{
    if ([_category isEqualToString:@"xiaoyuan"]) {
        if ([[[WMMUser me] universityName] length] && [[[WMMUser me] universityProvinceName] length]) {
            [self showCampus];
        } else {
            [self getUserInfo];
        }
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPage) name:@"createManSuccess" object:nil];
    
    [self.refreshHeaderView changeStyle:EGORefreshTableHeaderStyleZUO];
    if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"sysFunction"] valueForKey:@"tab"] boolValue]) {
        self.showTableView.frame = CGRectMake(0, 45, 320, SCREEN_HEIGHT-56-60-33);
        //self.showTableView.clipsToBounds = YES;
    }else {
        self.showTableView.frame = CGRectMake(0, 45, 320, SCREEN_HEIGHT-56-60);
    }
    
    CGRect refreshHeaderFrame = self.refreshHeaderView.frame;
    //refreshHeaderFrame.origin.x -=22;
    self.refreshHeaderView.frame = refreshHeaderFrame;
    
    UIImageView *topShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow_top"]];
    //[self.view addSubview:topShadow];
    CGRect topShadowFrame = topShadow.frame;
    topShadowFrame.origin.y = showTableView.frame.origin.y-2;
    topShadow.frame = topShadowFrame;
    
    self.loadingMoreView = [NKLoadingMoreView loadingMoreViewWithStyle:NKLoadingMoreViewStyleZUO];
    loadingMoreView.target = self;
    loadingMoreView.action = @selector(getMoreData);
    //[self.showTableView.tableFooterView addSubview:self.loadingMoreView];
    self.showTableView.tableFooterView = self.loadingMoreView;
    
    if ([_category isEqualToString:@"dianping"]) {
        self.showTableView.tableFooterView = [self addToolView];
        self.dataSource = [[NKDataStore sharedDataStore] cachedArrayOf:WMCachePathDianpingMen andClass:[WMMMan class]];
        [self showDianping];
        
    }else if ([_category isEqualToString:@"new"]) {
        
        [self showNew];
    }else if ([_category isEqualToString:@"nearby"]) {
        BOOL resu = [CLLocationManager locationServicesEnabled];
        if (!resu) {
            [self refreshData];
            return;
        }
        CLLocation *location = [[NKLocationService sharedNKLocationService] currentLocation];
        if (location) {
            [self showNearBy];
        }else {
            ProgressLoading;
            if ([CLLocationManager locationServicesEnabled]){
                if (!self.locationManager) {
                    self.locationManager = [[CLLocationManager alloc] init];
                    self.locationManager.delegate = self;
                    self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;
                    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                }
                // Start updating location changes.
            }
            [self.locationManager startUpdatingLocation];
        }
    }else if ([_category isEqualToString:@"hot"]) {
        [self showHot];
        //[self showCampus];
    }else if ([_category isEqualToString:@"bangdan"]) {
        [self showBangdan];
    }
    
    
}

-(void)hideKeybord
{
    [_searchFiled resignFirstResponder];
}

- (void)getUserInfo {
    ProgressLoading;
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(getUserInfoOK:) andFailedSelector:@selector(getUserInfoFiald:)];
    [[WMUserService sharedWMUserService] getUserInfoWithRequestDelegate:rd];
}

- (void)getUserInfoOK:(NKRequest *)request {
    ProgressHide;
    
    [WMMUser modelFromCache:[request.originDic valueForKey:@"data"]];
    
    [self showCampus];
}

- (void)getUserInfoFiald:(NKRequest *)request {
    ProgressErrorDefault;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	//NSLog(@"didFailWithError: %@", error);
//    gpsLabel = [[WMCustomLabel alloc] initWithFrame:CGRectMake(10, 20, 300, 40) font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithHexString:@"#A6937C"]];
//    gpsLabel.text = NOGPS;
//    gpsLabel.numberOfLines = 0;
//    gpsLabel.textAlignment = NSTextAlignmentCenter;
//    [self.showTableView.tableHeaderView addSubview:gpsLabel];
    [self refreshData];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"需要在手机设置开启定位服务以看到附近的八卦点评" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//    [alert show];
    ProgressHide;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (gpsLabel) {
        [gpsLabel removeFromSuperview];
    }
    [[NKLocationService sharedNKLocationService] setCurrentLocation:newLocation];
    [self.locationManager stopUpdatingLocation];
    
    [self showNearBy];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [super scrollViewDidScroll:scrollView];
    if ([self.category isEqualToString:@"dianping"] && !scrollView.decelerating && [self.searchFiled isFirstResponder]) {
        [_searchFiled resignFirstResponder];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    [self searchWithText:text];
    return YES;
    
}

-(void)showDianping
{
    [self.loadingMoreView showLoading:NO];
    [self searchWithText:@""];
}

-(void)showNew
{
    [self refreshData];
}

-(void)showDisstanceSelector:(id)sender
{
    UIActionSheet *distanceSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"500米内",@"1000米内",@"2000米内",@"5公里内",@"10公里内",@"50公里内",@"不限距离", nil];
    distanceSheet.tag = DISTANCE_SHEET;
    [distanceSheet showInView:NKNC.view];
}

-(void)showTypeSelector:(id)sender
{
    UIActionSheet *typeSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"所有八卦 (爆料+评分) ",@"只看爆料",@"只看评分", nil];
    typeSheet.tag = TYPE_SHEET;
    [typeSheet showInView:NKNC.view];
}

-(void)showNearBy
{
    if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"sysFunction"] valueForKey:@"tab"] boolValue]) {
        UIView *campusHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 40)];
        
        campusHeaderView.backgroundColor = [UIColor colorWithHexString:@"#f2e9dc"];
        
        distanceButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
        [distanceButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [distanceButton setTitleColor:[UIColor colorWithHexString:@"#A6937C"] forState:UIControlStateNormal];
        [distanceButton addTarget:self action:@selector(showDisstanceSelector:) forControlEvents:UIControlEventTouchUpInside];
        
        [campusHeaderView addSubview:distanceButton];
        
        distanceButton.contentEdgeInsets = UIEdgeInsetsMake(0, 8.0f, 0, 30.0f);
        
        UIImageView *downArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_arrow"]];
        downArrow.center = CGPointMake(145.0f, 20.0f);
        [distanceButton addSubview:downArrow];
        
        self.provinceButton = distanceButton;
        
        typeButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 160, 40)];
        [typeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [typeButton setTitleColor:[UIColor colorWithHexString:@"#A6937C"] forState:UIControlStateNormal];
        [typeButton addTarget:self action:@selector(showTypeSelector:) forControlEvents:UIControlEventTouchUpInside];
        
        [campusHeaderView addSubview:typeButton];
        
        typeButton.contentEdgeInsets = UIEdgeInsetsMake(0, 8.0f, 0, 30.0f);
        
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"nearType"]) {
            nearType = [[[NSUserDefaults standardUserDefaults] valueForKey:@"nearType"] intValue];
            if (nearType == 2) {
                [typeButton setTitle:@"只看爆料" forState:UIControlStateNormal];
            }else if (nearType == 1) {
                [typeButton setTitle:@"只看评分" forState:UIControlStateNormal];
            }else {
                [typeButton setTitle:@"全部八卦" forState:UIControlStateNormal];
            }
            
        }else {
            nearType = 2;
            [typeButton setTitle:@"只看爆料" forState:UIControlStateNormal];
        }
        
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"distance"]) {
            distance = [[[NSUserDefaults standardUserDefaults] valueForKey:@"distance"] intValue];
            switch (distance) {
                case 500:
                    [distanceButton setTitle:@"500米内" forState:UIControlStateNormal];
                    break;
                case 1000:
                    [distanceButton setTitle:@"1000米内" forState:UIControlStateNormal];
                    break;
                case 2000:
                    [distanceButton setTitle:@"2000米内" forState:UIControlStateNormal];
                    break;
                case 5000:
                    [distanceButton setTitle:@"5公里内" forState:UIControlStateNormal];
                    break;
                case 10000:
                    [distanceButton setTitle:@"10公里内" forState:UIControlStateNormal];
                    break;
                case 500000:
                    [distanceButton setTitle:@"50公里内" forState:UIControlStateNormal];
                    break;
                default:
                    [distanceButton setTitle:@"不限距离" forState:UIControlStateNormal];
                    break;
            }
        }else {
            distance = 0;
            [distanceButton setTitle:@"不限距离" forState:UIControlStateNormal];
        }
        
        downArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_arrow"]];
        downArrow.center = CGPointMake(145.0f, 20.0f);
        [typeButton addSubview:downArrow];
        
        self.universityButton = typeButton;
        
        UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(distanceButton.frame.size.width - 1, 0.0f, 1.0f, distanceButton.frame.size.height)];
        verticalLine.backgroundColor = [UIColor colorWithHexString:@"#eae0d1"];
        [distanceButton addSubview:verticalLine];
        
        UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, campusHeaderView.frame.size.height, campusHeaderView.frame.size.width, 1.0f)];
        horizontalLine.backgroundColor = [UIColor colorWithHexString:@"#eae0d1"];
        [campusHeaderView addSubview:horizontalLine];
        
        [self.view addSubview:campusHeaderView];
        
        // Change the frame of showTableView {{{
        
        CGRect frame = self.showTableView.frame;
        frame.origin.y = 85.0f;
        frame.size.height = SCREEN_HEIGHT-116-40-33;
        self.showTableView.frame = frame;
    }

    [self refreshData];
}

-(void)showHot
{
    [self refreshData];
}

-(void)showBangdan
{
    [self refreshData];
}

-(void)showCampus
{
    UIView *campusHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 40)];
    
    campusHeaderView.backgroundColor = [UIColor colorWithHexString:@"#f2e9dc"];
    
    UIButton *provinceButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 115, 40)];
    [provinceButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [provinceButton setTitleColor:[UIColor colorWithHexString:@"#A6937C"] forState:UIControlStateNormal];
    [provinceButton addTarget:self action:@selector(showCitySelector:) forControlEvents:UIControlEventTouchUpInside];
    [provinceButton setTitle:[[WMMUser me] universityProvinceName] forState:UIControlStateNormal];
    [campusHeaderView addSubview:provinceButton];
    
    provinceButton.contentEdgeInsets = UIEdgeInsetsMake(0, 8.0f, 0, 30.0f);
    
    UIImageView *downArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_arrow"]];
    downArrow.center = CGPointMake(95.0f, 20.0f);
    [provinceButton addSubview:downArrow];
    
    self.provinceButton = provinceButton;
    
    UIButton *universityButton = [[UIButton alloc] initWithFrame:CGRectMake(115, 0, 205, 40)];
    [universityButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [universityButton setTitleColor:[UIColor colorWithHexString:@"#A6937C"] forState:UIControlStateNormal];
    [universityButton addTarget:self action:@selector(showUniversitySelector:) forControlEvents:UIControlEventTouchUpInside];
    [universityButton setTitle:[[WMMUser me] universityName] forState:UIControlStateNormal];
    [campusHeaderView addSubview:universityButton];
    
    universityButton.contentEdgeInsets = UIEdgeInsetsMake(0, 8.0f, 0, 30.0f);
    
    downArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_arrow"]];
    downArrow.center = CGPointMake(185.0f, 20.0f);
    [universityButton addSubview:downArrow];
    
    self.universityButton = universityButton;
    
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(provinceButton.frame.size.width - 1, 0.0f, 1.0f, provinceButton.frame.size.height)];
    verticalLine.backgroundColor = [UIColor colorWithHexString:@"#eae0d1"];
    [provinceButton addSubview:verticalLine];
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, campusHeaderView.frame.size.height, campusHeaderView.frame.size.width, 1.0f)];
    horizontalLine.backgroundColor = [UIColor colorWithHexString:@"#eae0d1"];
    [campusHeaderView addSubview:horizontalLine];
    
    [self.view addSubview:campusHeaderView];
    
    // Change the frame of showTableView {{{
    
    CGRect frame = self.showTableView.frame;
    frame.origin.y = 85.0f;
    frame.size.height = SCREEN_HEIGHT-116-40-33;
    self.showTableView.frame = frame;
    
    // }}}
    
    self.category = @"xiaoyuan";
    [self refreshData];
}

-(void)showCitySelector:(id)sender
{
    WMChooseSchoolViewController *vc = [[WMChooseSchoolViewController alloc] init];
    vc.delegate = self;
    [NKNC pushViewController:vc animated:YES];
}

-(void)showUniversitySelector:(id)sender
{
    NSString *province = [[WMMUser me] universityProvinceName];
    
    WMChooseSchoolViewController *vc = [[WMChooseSchoolViewController alloc] init];
    vc.delegate = self;
    vc.initialProvince = province;
    [NKNC pushViewController:vc animated:YES];
}

#pragma mark - WMChooseSchoolViewDelegate

- (void)schoolDidSelect:(NSDictionary *)university {
    [NKNC popToRootViewControllerAnimated:YES];
    
    [self updateUserUniversity:university];
}

- (void)updateUserUniversity:(NSDictionary *)university {
    ProgressLoading;
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(updateUniversityOK:) andFailedSelector:@selector(updateUniversityFaild:)];
    [[WMUserService sharedWMUserService] updateUnivWithRequestDelegate:rd univ_id:university[@"id"]];
}

- (void)updateUniversityOK:(NKRequest *)request {
    ProgressHide;
    
    if (request.originDic) {
        [WMMUser modelFromCache:request.originDic[@"data"]];
        [self updateProvinceAndUniversity];
    }
    
    [self refreshData];
}

- (void)updateProvinceAndUniversity {
    [self.provinceButton setTitle:[[WMMUser me] universityProvinceName] forState:UIControlStateNormal];
    [self.universityButton setTitle:[[WMMUser me] universityName] forState:UIControlStateNormal];
}

- (void)updateUniversityFaild:(NKRequest *)request {
    ProgressErrorDefault;
}

-(void)searchWithText:(NSString*)searchString{
    ProgressLoading;
    isSearch = YES;
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(searchOK:) andFailedSelector:@selector(searchFailed:)];
    [[WMManService sharedWMManService] searchManWithString:searchString offset:0 size:DefaultOneRequestSize andRequestDelegate:rd];
    
}

-(void)searchOK:(NKRequest*)request{
    isSearch = NO;
    [self doneLoadingTableViewData];
    currentPage = 1;
    self.totalCount = request.totalCount;
    ProgressHide;
    self.searchResults = (NSMutableArray*)request.results;
    self.showDataSource = self.searchResults;
    
    self.hasMore = [request.hasMore boolValue];
    if (!self.hasMore) {
        self.showTableView.tableFooterView = nil;
        self.showTableView.tableFooterView = [self addToolView];
    }else {
        self.showTableView.tableFooterView = self.loadingMoreView;
    }
    [[NKDataStore sharedDataStore] cacheArray:self.dataSource forCacheKey:WMCachePathDianpingMen];
    //[self.showDataSource removeAllObjects];
    [self.showTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [showTableView reloadData];
    [self setPullBackFrame];
    
    
}


-(void)searchFailed:(NKRequest*)request{
    
    isSearch = NO;
    [super refreshDataFailed:request];
    if ([request.errorCode integerValue] == 12011) {
        ProgressHide;
        [self.showDataSource removeAllObjects];
        [self.showTableView reloadData];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 40, 320, 120)];
        [btn setTitleColor:[UIColor colorWithHexString:@"#B2A18D"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitle:@"更新一下微博或人人账号才能点评好友哦" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        self.showTableView.tableFooterView =btn;
    }else {
        //ProgressErrorDefault;
        ProgressHide;
    }
    
    
}

-(void)bindOauth:(id)sender
{
    WMOauthViewController *oauthViewController = [[WMOauthViewController alloc] init];
    
    oauthViewController.goBackAction = ^{
        self.showTableView.tableFooterView = [self addToolView];
    };
    
    [NKNC pushViewController:oauthViewController animated:YES];
}

-(UIView *)addToolView
{
    CGFloat cellHeight = [WMMenCell cellHeightForObject:nil];
    
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, cellHeight)];
    
    UIButton *createBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.showTableView.frame.size.width, [WMMenCell cellHeightForObject:nil])];
    createBtn.tag = HEAD_TAG;
    [createBtn addTarget:self action:@selector(goCreateMan:) forControlEvents:UIControlEventTouchUpInside];
    [createBtn setImage:[UIImage imageNamed:@"createMan_normal"] forState:UIControlStateNormal];
    [createBtn setImage:[UIImage imageNamed:@"createMan_click"] forState:UIControlStateHighlighted];
    UIImageView *headSep = [[UIImageView alloc] initWithFrame:CGRectMake(0, createBtn.frame.size.height, 320, 1)];
    headSep.backgroundColor = [UIColor colorWithHexString:@"#EAE0D1"];
    [createBtn addSubview:headSep];
    [toolView addSubview:createBtn];
    
    if (![[WMMUser me] isAllOauthBined]) {
        UIButton *oautnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, [WMMenCell cellHeightForObject:nil], 320, [WMMenCell cellHeightForObject:nil])];
        [oautnBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateHighlighted];
        [oautnBtn setTitle:@"绑定微博或人人网账号才能查看好友的八卦" forState:UIControlStateNormal];
        [oautnBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [oautnBtn setTitleColor:[UIColor colorWithHexString:@"#7E6B5A"] forState:UIControlStateNormal];
        [oautnBtn addTarget:self action:@selector(bindOauth:) forControlEvents:UIControlEventTouchUpInside];
        [toolView addSubview:oautnBtn];
        UIImageView *oauthSep = [[UIImageView alloc] initWithFrame:CGRectMake(0, oautnBtn.frame.size.height, 320, 1)];
        oauthSep.backgroundColor = [UIColor colorWithHexString:@"#EAE0D1"];
        [oautnBtn addSubview:oauthSep];
        
        toolView.frame = CGRectMake(0, 0, 320, cellHeight * 2);
    }
    
    return toolView;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.feedBadge.hidden = YES;
    [_actionButton setBackgroundImage:[UIImage imageNamed:@"man_search_normal"] forState:UIControlStateNormal];
    [_actionButton setBackgroundImage:[UIImage imageNamed:@"man_search_click"] forState:UIControlStateHighlighted];
    [_actionButton removeTarget:self action:@selector(goToFav:) forControlEvents:UIControlEventTouchUpInside];
    
    [_actionButton addTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_actionButton setTitleColor:[UIColor colorWithHexString:@"#A6937C"] forState:UIControlStateNormal];
    _actionButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_actionButton setTitle:@"取消" forState:UIControlStateNormal];
    //    if (head) {
    //        [head removeFromSuperview];
    //    }
    
    head = [[UIButton alloc] initWithFrame:CGRectMake(0, 40, self.showTableView.frame.size.width, [WMMenCell cellHeightForObject:nil])];
    head.tag = HEAD_TAG;
    [head addTarget:self action:@selector(goCreateMan:) forControlEvents:UIControlEventTouchUpInside];
    [head setImage:[UIImage imageNamed:@"createMan_normal"] forState:UIControlStateNormal];
    [head setImage:[UIImage imageNamed:@"createMan_click"] forState:UIControlStateHighlighted];
    UIImageView *headSep = [[UIImageView alloc] initWithFrame:CGRectMake(0, head.frame.size.height-4, 320, 1)];
    headSep.backgroundColor = [UIColor colorWithHexString:@"#EAE0D1"];
    [head addSubview:headSep];
    [headerView addSubview:head];
    //self.showTableView.tableHeaderView = head;
    
    CGRect frame = headerView.frame;
    if (frame.size.height<50) {
        frame.size.height += 80;
    }
    headerView.frame = frame;
    self.showTableView.tableHeaderView = headerView;
    ProgressLoading;
    self.showDataSource = nil;
    [showTableView reloadData];
    
    [self searchWithText:textField.text];
    
    return YES;
}

-(void)goToFav:(id)sender
{
    int manDicCount = 0;
    NSDictionary *manDic = [[WMNotificationCenter sharedNKNotificationCenter] manDic];
    if ([manDic isKindOfClass:[NSDictionary class]] && ![manDic isKindOfClass:[NSNull class]]) {
        for (NSDictionary *dic in [manDic allValues]) {
            if (![dic isKindOfClass:[NSNull class]]) {
                for (NSNumber *number in [dic allValues]) {
                    //NSLog(@"*&&&&&&&&&&*： :%@",number);
                    if ([number boolValue]) {
                        manDicCount +=1;
                    }
                }
            }
            
        }
    }
    int badgeNum = [[UIApplication sharedApplication] applicationIconBadgeNumber];
    if (badgeNum>=manDicCount) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:(badgeNum-manDicCount)];
    }else {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
    
    self.feedBadge.hidden = YES;
    WMFavListViewController *favList = [[WMFavListViewController alloc] init];
    self.feedBadge.hidden = YES;
    [NKNC pushViewController:favList animated:YES];
}

-(void)refreshData{
    if (gpsLabel) {
        [gpsLabel removeFromSuperview];
    }
    if ([self.category isEqualToString:@"dianping"]){
        [[WMNotificationCenter sharedNKNotificationCenter] getNotificationsCount];
        [self searchWithText:_searchFiled.text];
        //self.feedBadge.hidden = ![[WMNotificationCenter sharedNKNotificationCenter] hasNewMan];
        
    }else if ([self.category isEqualToString:@"nearby"]){
        ProgressLoading;
        NKRequestDelegate *rd = [NKRequestDelegate refreshRequestDelegateWithTarget:self];
        
        if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"sysFunction"] valueForKey:@"tab"] boolValue]) {
            [[WMFeedService sharedWMFeedService] getFeedsNearWithType:nearType distance:distance offset:0 size:DefaultOneRequestSize andRequestDelegate:rd];
        }else {
            [[WMFeedService sharedWMFeedService] getFeedsNear:0 size:DefaultOneRequestSize andRequestDelegate:rd];
        }
    }else if ([self.category isEqualToString:@"xiaoyuan"]) {
        ProgressLoading;
        NKRequestDelegate *rd = [NKRequestDelegate refreshRequestDelegateWithTarget:self];
        
        [[WMUniversityService sharedWMUniversityService] getMyUniversityList:rd];
    }else if ([self.category isEqualToString:@"bangdan"]) {
        ProgressLoading;
        NKRequestDelegate *rd = [NKRequestDelegate refreshRequestDelegateWithTarget:self];
        
        [[WMManService sharedWMManService] getManLists:rd];
    }else{
        NKRequestDelegate *rd = [NKRequestDelegate refreshRequestDelegateWithTarget:self];
        
        [[WMManService sharedWMManService] getMenWithCategory:self.category offset:0 size:DefaultOneRequestSize andRequestDelegate:rd];
        
        
    }
    
}

-(IBAction)logout:(id)sender{
    
    [[[[NKConfig sharedConfig] accountManagerClass] sharedAccountsManager] logOut];
    
}

-(void)getMoreData{
    [self showFooter:YES];
    gettingMoreData = YES;
    
    NKRequestDelegate *rd = [NKRequestDelegate getMoreRequestDelegateWithTarget:self];
    if (![self.category isEqualToString:@"dianping"] && ![self.category isEqualToString:@"nearby"]) {
        [[WMManService sharedWMManService] getMenWithCategory:self.category offset:self.dataSource.count size:DefaultOneRequestSize andRequestDelegate:rd];
    }else if ([self.category isEqualToString:@"nearby"]) {
        ProgressLoading;
        if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"sysFunction"] valueForKey:@"tab"] boolValue]) {
            [[WMFeedService sharedWMFeedService] getFeedsNearWithType:nearType distance:distance offset:[self.showDataSource count] size:DefaultOneRequestSize andRequestDelegate:rd];
        }else {
            [[WMFeedService sharedWMFeedService] getFeedsNear:[self.showDataSource count] size:DefaultOneRequestSize andRequestDelegate:rd];
        }
        
    }else if ([self.category isEqualToString:@"dianping"]) {
        isSearch = YES;
        NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(searchMoreOK:) andFailedSelector:@selector(searchMoreFailed:)];
        [[WMManService sharedWMManService] searchManWithString:self.searchFiled.text offset:[self.showDataSource count] size:DefaultOneRequestSize andRequestDelegate:rd];
    }
    
}

-(void)searchMoreOK:(NKRequest *)request
{
    isSearch = NO;
    [self doneLoadingTableViewData];
    [self showFooter:NO];
    //currentPage = 1;
    //self.totalCount = [NSNumber numberWithInteger:request.totalCount+[self.showDataSource count]];
    ProgressHide;
    self.searchResults = (NSMutableArray*)request.results;
    [self.showDataSource addObjectsFromArray:self.searchResults];
    
    self.hasMore = [request.hasMore boolValue];
    if (!self.hasMore) {
        self.showTableView.tableFooterView = nil;
    }
    
    [showTableView reloadData];
    [self setPullBackFrame];
}

-(void)searchMoreFailed:(NKRequest *)request
{
    
}

-(void)getMoreDataOK:(NKRequest *)request{
    ProgressHide;
    //[super getMoreDataOK:request];
    [self showFooter:NO];
    gettingMoreData = NO;
    
    currentPage ++;
    
    if ([request.results count] && ![self.category isEqualToString:@"nearby"]) {
        
        if (isSearch) {
            
            [self.searchResults addObjectsFromArray:request.results];
        }
        else{
            
            [self.dataSource addObjectsFromArray:request.results];
            
        }
        // 提升体验
        //[self.showTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
        
        [self.showTableView reloadData];
        [self setPullBackFrame];
    }else if ([request.results count] && [self.category isEqualToString:@"nearby"]) {
        [self.dataSource addObjectsFromArray:request.results];
        [self.showTableView reloadData];
    }
    else{
        
        
        [loadingMoreView showNoMoreContent];
        
    }
    
    if (![request.hasMore boolValue]) {
        self.showTableView.tableFooterView = nil;
    }
    
}


-(void)refreshDataOK:(NKRequest *)request{
    ProgressHide;
    
    [super refreshDataOK:request];
    [self.showTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    self.showDataSource = self.dataSource;
    
    if ([self.category isEqualToString:@"nearby"]) {
        [self.showTableView reloadData];
        CLLocation *location = [[NKLocationService sharedNKLocationService] currentLocation];
        if (!location) {
            gpsLabel = [[WMCustomLabel alloc] initWithFrame:CGRectMake(10, 20, 300, 60) font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithHexString:@"#A6937C"]];
            gpsLabel.text = NOGPS;
            gpsLabel.numberOfLines = 0;
            gpsLabel.textAlignment = NSTextAlignmentCenter;
            self.showTableView.tableHeaderView = gpsLabel;
        }else {
            self.showTableView.tableHeaderView = nil;
        }
    }else {
        
    }
    //[self.dataSource removeAllObjects];
    
    
    if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"sysFunction"] valueForKey:@"tab"] boolValue]) {
        if (currentPage==0) {
            [[NKDataStore sharedDataStore] cacheArray:self.dataSource forCacheKey:WMCachePathDianpingMen];
        }
    }else {
        if (currentPage == 4) {
            [[NKDataStore sharedDataStore] cacheArray:self.dataSource forCacheKey:WMCachePathNearByMen];
        }
    }
    
    if (![request.hasMore boolValue]) {
        self.showTableView.tableFooterView = nil;
    }
    [self.showTableView reloadData];
    
}

-(void)refreshDataFailed:(NKRequest *)request
{
    
    //[super refreshDataFailed:request];
    if ([request.errorCode integerValue] == 99999 && [self.category isEqualToString:@"nearby"]) {
        [self.showDataSource removeAllObjects];
        [self.showTableView reloadData];
        [gpsLabel removeFromSuperview];
        gpsLabel = [[WMCustomLabel alloc] initWithFrame:CGRectMake(10, 20, 300, 40) font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithHexString:@"#A6937C"]];
        gpsLabel.text = NOGPS;
        gpsLabel.numberOfLines = 0;
        gpsLabel.textAlignment = NSTextAlignmentCenter;
        [self.showTableView.tableFooterView addSubview:gpsLabel];
        [self doneLoadingTableViewData];
        ProgressHide;
        getNearCount = 1;
        return;
    }else {
        getNearCount = 0;
        //ProgressErrorDefault;
    }
    ProgressErrorDefault;
    
    
}

-(void)setPullBackFrame{
    
}

#pragma mark TableView


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.category isEqualToString:@"nearby"] && [self.showDataSource count]>0) {
        return [WMManFeedCell cellHeightForObject:[self.showDataSource objectAtIndex:indexPath.row]];
    }else if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"sysFunction"] valueForKey:@"tab"] boolValue]) {
        //return [WMManFeedCell cellHeightForObject:[self.showDataSource objectAtIndex:indexPath.row]];
    }else if ([self.category isEqualToString:@"xiaoyuan"] || [self.category isEqualToString:@"bangdan"]) {
        return 85;
    }
    return [WMMenCell cellHeightForObject:[self.showDataSource objectAtIndex:indexPath.row]];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.category isEqualToString:@"nearby"]) {
        
    }
    return [self.showDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = nil;
    Class klass = nil;
    id data = [self.showDataSource objectAtIndex:indexPath.row];
    if ([self.category isEqualToString:@"nearby"]) {
        CellIdentifier = @"WMNearByCellIdentifier";
        klass = [WMManFeedCell class];
    }else if ([self.category isEqualToString:@"xiaoyuan"]) {
        CellIdentifier = @"WMXiaoyuanCellIdentifier";
        klass = [WMUniversityMenCell class];
    }else if ([self.category isEqualToString:@"bangdan"]) {
        CellIdentifier = @"WMBangdanCellIdentifier";
        klass = [WMUniversityMenCell class];
    }else {
        CellIdentifier = @"WMFeedCellIdentifier";
        klass = [WMMenCell class];
        
    }
    
    id cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[klass alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    
    if ([self.category isEqualToString:@"nearby"]) {
        [cell setDelegate:self];
    }else if ([self.category isEqualToString:@"xiaoyuan"] || [self.category isEqualToString:@"bangdan"]) {
    
    }else{
        [cell setShouldShowBadge:NO];
        
    }
    
    
    
    [cell showForObject:data];
    
    return cell;
}
-(void)setRate:(int)index feed:(WMMFeed *)feed
{
    [self.dataSource replaceObjectAtIndex:index withObject:feed];
}

-(void)showMoreView:(WMMFeed *)feed
{
    reportFeed = feed;
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报" otherButtonTitles:@"分享到微信/QQ", nil];
    sheet.tag = SHOW_REPORT_SHEET;
    [sheet showInView:[self.view.subviews lastObject]];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == SHOW_REPORT_SHEET) {
        if (buttonIndex == 0) {
            [self showReportActionSheet];
        } else if (buttonIndex == 1) {
            [self share];
        }
    }else if (actionSheet.tag == REPORT_SHEET) {
        NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(reportOK:) andFailedSelector:@selector(reportFailed:)];
        
        NSString *reportType = nil;
        
        switch (buttonIndex) {
            case 0: {
                reportType = @"广告";
            }
                break;
                
            case 1: {
                reportType = @"色情";
            }
                break;
                
            case 2: {
                reportType = @"政治";
            }
                break;
                
            case 3: {
                reportType = @"反感";
            }
                break;
                
            default:
                return;
        }
        
        ProgressWith(@"举报中");
        
        [[WMFeedService sharedWMFeedService] reportFeedWithFID:reportFeed.mid andContent:reportType andRequestDelegate:rd];
    }else if (actionSheet.tag == DISTANCE_SHEET) {
        switch (buttonIndex) {
            case 0:
                distance = 500;
                [distanceButton setTitle:@"500米内" forState:UIControlStateNormal];
                [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",distance] forKey:@"distance"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                break;
            case 1:
                distance = 1000;
                [distanceButton setTitle:@"1000米内" forState:UIControlStateNormal];
                [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",distance] forKey:@"distance"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                break;
            case 2:
                distance = 2000;
                [distanceButton setTitle:@"2000米内" forState:UIControlStateNormal];
                [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",distance] forKey:@"distance"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                break;
            case 3:
                distance = 5000;
                [distanceButton setTitle:@"5000米内" forState:UIControlStateNormal];
                [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",distance] forKey:@"distance"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                break;
            case 4:
                distance = 10000;
                [distanceButton setTitle:@"10公里内" forState:UIControlStateNormal];
                [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",distance] forKey:@"distance"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                break;
            case 5:
                distance = 50000;
                [distanceButton setTitle:@"50公里内" forState:UIControlStateNormal];
                [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",distance] forKey:@"distance"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                break;
            case 6:
                distance = nil;
                [distanceButton setTitle:@"不限距离" forState:UIControlStateNormal];
                [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",distance] forKey:@"distance"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                break;
                
            default:
                break;
        }
        
        [self refreshData];
    }else if (actionSheet.tag == TYPE_SHEET) {
        switch (buttonIndex) {
            case 0:
                nearType = nil;
                [typeButton setTitle:@"所有八卦" forState:UIControlStateNormal];
                [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",nearType] forKey:@"nearType"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                break;
            case 1:
                [typeButton setTitle:@"只看爆料" forState:UIControlStateNormal];
                nearType = 2;
                [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",nearType] forKey:@"nearType"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                break;
            case 2:
                [typeButton setTitle:@"只看评分" forState:UIControlStateNormal];
                nearType = 1;
                [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",nearType] forKey:@"nearType"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                break;
            default:
                break;
        }
        
        [self refreshData];
    }
}

- (void)reportOK:(NKRequest *)request {
    ProgressSuccess(@"举报成功");
}

- (void)reportFailed:(NKRequest *)request {
    
}

-(void)showReportActionSheet
{
    UIActionSheet *sheet = [[UIActionSheet alloc]
                            initWithTitle:nil
                            delegate:self
                            cancelButtonTitle:@"取消"
                            destructiveButtonTitle:nil
                            otherButtonTitles:@"广告", @"色情", @"政治", @"反感", nil];
    sheet.tag = REPORT_SHEET;
    [sheet showInView:[self.view.subviews lastObject]];
}

- (void)share {
    NSString *titleString = [NSString stringWithFormat:@"关于 %@…", reportFeed.man.name];
    NSString *descString = nil;
    
    if ([reportFeed.type isEqualToString:WMFeedTypeDafen]) {
        NSMutableArray *scoreArr = [NSMutableArray array];
        
        for (id obj in reportFeed.score[@"scores"]) {
            [scoreArr addObject:[NSString stringWithFormat:@"%@%@分", obj[@"name"], obj[@"score"]]];
        }
        
        NSString *scoreString = [scoreArr componentsJoinedByString:@"，"];
        
        descString = [NSString stringWithFormat:@"%@ 给 %@ %@...", reportFeed.sender.name, reportFeed.man.name, scoreString];
    } else {
        descString = [NSString stringWithFormat:@"%@说：%@", reportFeed.sender.name, reportFeed.content];
    }
    
    descString = [descString stringByAppendingString:@" | 点击可匿名评论"];
    
    NSData *imageData = nil;
    NSString *imageURL = reportFeed.man.avatarBigPath;
    
    WMMAttachment *attach = [reportFeed.attachments lastObject];
    
    if (attach != nil) {
        if (attach.picture != nil) {
            imageData = UIImageJPEGRepresentation(attach.picture, 1.0f);
        } else {
            imageURL = attach.pictureURL;
        }
    }
    
    if (imageData == nil) {
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    }
    
    id<ISSContent> publishContent = [ShareSDK content:descString
                                       defaultContent:@""
                                                image:[ShareSDK imageWithData:imageData fileName:@"avatar.jpg" mimeType:@"image/jpeg"]
                                                title:@"薇蜜"
                                                  url:@"http://www.weimi.com/app?from=weibo"
                                          description:@"薇蜜"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //定制微信好友信息
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:descString
                                           title:titleString
                                             url:[NSString stringWithFormat:@"http://www.weimi.com/man/%@/review/%@?from=weixinmsg",reportFeed.man.mid, reportFeed.mid]
                                           image:[ShareSDK imageWithData:imageData fileName:@"avatar.jpg" mimeType:@"image/jpeg"]
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    //定制微信朋友圈信息
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                          content:descString
                                            title:titleString
                                              url:[NSString stringWithFormat:@"http://www.weimi.com/man/%@/review/%@?from=moment",reportFeed.man.mid, reportFeed.mid]
                                            image:[ShareSDK imageWithData:imageData fileName:@"avatar.jpg" mimeType:@"image/jpeg"]
                                     musicFileUrl:@""
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    //定制QQ信息
    [publishContent addQQUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                              content:descString
                                title:titleString
                                  url:[NSString stringWithFormat:@"http://www.weimi.com/man/%@/review/%@?from=qq",reportFeed.man.mid, reportFeed.mid]
                                image:[ShareSDK imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:reportFeed.man.avatarBigPath]] fileName:@"avatar.jpg" mimeType:@"image/jpeg"]];
    
    [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"姑娘们对 %@ 的点评打分，八卦>>>http://http://www.weimi.com/man/%@?from=sms 【薇蜜】",reportFeed.man.name,reportFeed.man.mid]];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPhoneContainerWithViewController:self];
    
    
    
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"薇蜜分享"
                                                              oneKeyShareList:[ShareSDK getShareListWithType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeQQ, nil]
                                                               qqButtonHidden:YES
                                                        wxSessionButtonHidden:YES
                                                       wxTimelineButtonHidden:YES
                                                         showKeyboardOnAppear:NO
                                                            shareViewDelegate:nil
                                                          friendsViewDelegate:nil
                                                        picViewerViewDelegate:nil];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:[ShareSDK getShareListWithType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeQQ, nil]
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

-(void)commentFinished
{
    //self.category = @"nearby";
    //[self.dataSource removeAllObjects];
    [self refreshData];
}

-(void)deleteFeed
{
    //self.category = @"nearby";
    //[self.dataSource removeAllObjects];
    [self refreshData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id man = [self.showDataSource objectAtIndex:indexPath.row];
    if ([self.category isEqualToString:@"nearby"]) {
        WMMFeed *feed = man;
        if ([feed.purview isEqualToString:@"open"] || [feed.sender.relation isEqualToString:@"自己"]) {
            WMBaoliaoXiangqingViewController *baoliaoXiangqing = [[WMBaoliaoXiangqingViewController alloc] init];
            baoliaoXiangqing.man = feed.man;
            baoliaoXiangqing.feed = feed;
            baoliaoXiangqing.delegate = self;
            [NKNC pushViewController:baoliaoXiangqing animated:YES];
        }else {
            ProgressFailedWith(@"只有她的姐妹闺蜜才能看哦~");
        }
    }else if ([self.category isEqualToString:@"xiaoyuan"]) {
        WMUniversityManListViewController *vc = [[WMUniversityManListViewController alloc] init];
        WMUniversityManList *manList = [self.showDataSource objectAtIndex:indexPath.row];
        vc.universityManList = manList;
        [NKNC pushViewController:vc animated:YES];
    }else if ([self.category isEqualToString:@"bangdan"]) {
        WMUniversityManListViewController *vc = [[WMUniversityManListViewController alloc] init];
        WMManList *manList = [self.showDataSource objectAtIndex:indexPath.row];
        vc.manList = manList;
        [NKNC pushViewController:vc animated:YES];
    }else {
        WMMMan *wman = man;
        if (wman.mid) {
            WMManDetailViewController *vc = [[WMManDetailViewController alloc] init];
            vc.delegate = self;
            vc.man = wman;
            [NKNC pushViewController:vc animated:YES];
            //[WMManDetailViewController manDetailWithMan:wman];
        }
        else{
            
            [self goCreateMan:man];
        }
    }
    
    
}

-(void)shouldReload
{
    [self refreshData];
}

-(void)rightButtonClick:(id)sender{
    
    [WMWikiViewController wikiViewControllerForViewController:NKNC animated:YES];
    
}

-(void)actionButtonClick:(id)sender{
    
    if ([[self.actionButton titleForState:UIControlStateNormal] length]) {
        [self.feedBadge bindValueOfModel:[WMNotificationCenter sharedNKNotificationCenter] forKeyPath:@"hasNewMan"];
        [_searchFiled resignFirstResponder];
        [_searchFiled setText:nil];
        [self searchWithText:@""];
        [_actionButton setBackgroundImage:[UIImage imageNamed:@"guanzhu_normal"] forState:UIControlStateNormal];
        [_actionButton setBackgroundImage:[UIImage imageNamed:@"guanzhu_click"] forState:UIControlStateHighlighted];
        //_actionButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
        _actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        //[_actionButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_actionButton setTitle:@"" forState:UIControlStateNormal];
        [_actionButton removeTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_actionButton addTarget:self action:@selector(goToFav:) forControlEvents:UIControlEventTouchUpInside];
        for (UIView *view in [headerView subviews]) {
            if (view.tag == HEAD_TAG) {
                [view removeFromSuperview];
            }
        }
        CGRect frame = headerView.frame;
        if (frame.size.height>50) {
            frame.size.height -= 80;
        }
        headerView.frame = frame;
        //self.showTableView.tableHeaderView = nil;
        self.showTableView.tableHeaderView = headerView;
        //self.showDataSource = nil;
        [showTableView reloadData];
    }
    else{
        self.feedBadge.hidden = YES;
        [_searchFiled becomeFirstResponder];
        
    }
}

-(void)goCreateMan:(WMMMan*)man{
    
    WMCreateManViewController *create = [[WMCreateManViewController alloc] init];
    if ([man isKindOfClass:[WMMMan class]]) {
        create.man = man;
        create.man.tags = [NSMutableArray array];
    }
    [NKNC pushViewController:create animated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
