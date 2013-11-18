//
//  WMMojingViewController.m
//  WEIMI
//
//  Created by SteveMa on 13-10-25.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMMojingViewController.h"
#import "WMCoupleTestViewController.h"
#import "WMMojingCell.h"
#import "WMMirror.h"
#import "WMAppDelegate.h"
#import "WMMojingDetailViewViewController.h"

#import "WMMTopic.h"
#import "WMCoverViewController.h"

@interface WMMojingViewController ()
{
    int notificationCount;
    WMCoverViewController *coverViewController;
    NSMutableArray *cards;
}
@end

@implementation WMMojingViewController

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
	// Do any additional setup after loading the view.
    [self.headBar setHidden:YES];
    cards = [[NSMutableArray alloc] init];
    UIView *tableViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
    //showTableView.tableHeaderView = tableViewHeader;
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
    bgView.image = [UIImage imageNamed:@"wiki_top_bg"];
    [tableViewHeader addSubview:bgView];
    [self.view addSubview:tableViewHeader];
    
    UILabel *topTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 320, 22)];
    topTitleLabel.backgroundColor = [UIColor clearColor];
    topTitleLabel.font = [UIFont boldSystemFontOfSize:20];
    topTitleLabel.text = @"魔镜";
    topTitleLabel.textAlignment = NSTextAlignmentCenter;
    topTitleLabel.textColor = [UIColor colorWithHexString:@"#7E6B5A"];
    [tableViewHeader addSubview:topTitleLabel];
    
    [self.showTableView removeFromSuperview];
    self.showTableView = nil;
    mojingTableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 45, 290, SCREEN_HEIGHT - 115) style:UITableViewStyleGrouped];
    mojingTableView.backgroundView = nil;
    mojingTableView.backgroundColor = [UIColor clearColor];
    mojingTableView.dataSource = self;
    mojingTableView.delegate = self;
    mojingTableView.scrollEnabled = YES;
    [self.contentView addSubview:mojingTableView];
    
    notificationCount = 0;
    [self refreshData];
    
//    cards = [[NKDataStore sharedDataStore] cachedArrayOf:WMCacheCards andClass:[WMMTopicPicad class]];
//    
//    [self addHeaderView];
//    [self getData];
}

-(void)getData
{
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(getTopicCardOK:) andFailedSelector:@selector(getTopicCardFailed:)];
    [[WMTopicService sharedWMTopicService] getTopicPicads:rd];
}

-(void)getTopicCardOK:(NKRequest *)request
{
    ProgressHide;
    if (!cards) {
        cards = [NSMutableArray array];
    }
    [cards removeAllObjects];
    if ([request.results count]>0) {
        for (int i=0; i<[request.results count]; i++) {
            [cards addObject:[request.results objectAtIndex:i]];
        }
        [self addHeaderView];
    }else {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
        self.showTableView.tableHeaderView = headerView;
    }
    [[NKDataStore sharedDataStore] cacheArray:cards forCacheKey:WMCacheCards];
    //[self refreshData];
}

-(void)getTopicCardFailed:(NKRequest *)request
{
    ProgressErrorDefault;
    //[self refreshData];
}

-(void)addHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 304, 170)];
    mojingTableView.tableHeaderView = headerView;
    coverViewController = [[WMCoverViewController alloc] init];
    coverViewController.dataSource = cards;
    coverViewController.kNumberOfPages = [cards count];
    coverViewController.view.frame = CGRectMake(0, 10, 320, 160);
    //coverViewController.view.backgroundColor = [UIColor grayColor];
    
    [headerView addSubview:coverViewController.view];
    
}

-(void)refreshData
{
    ProgressLoading;
    NKRequestDelegate *rd = [NKRequestDelegate refreshRequestDelegateWithTarget:self];
    [[WMSystemService sharedWMSystemService] getMirrorList:rd];
}

-(void)refreshDataOK:(NKRequest *)request
{
    [super refreshDataOK:request];
    [mojingTableView reloadData];
    ProgressHide;
}

-(void)refreshDataFailed:(NKRequest *)request
{
    ProgressHide;
}

-(int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource count]+1;
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section>0) {
        return 1;
    }
    return 11;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"WMMojingCellIdentifier";
    //static NSString * CellIdentifierForBind = @"WMMojingCellIdentifierForBind";
    
    
    WMMojingCell *cell = (WMMojingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[WMMojingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell showIndexPath:indexPath dataSource:self.dataSource hasNotification:notificationCount];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0: {
                    WMCoupleTestViewController *coupleTestViewController = [[WMCoupleTestViewController alloc] initWithNibName:nil bundle:nil];
                    [NKNC pushViewController:coupleTestViewController animated:YES];
                    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"showCoupleTest"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [[[WMAppDelegate shareAppDelegate] totalBadge2] setHidden:YES];
                    break;
                }
                default:{
                    
                    break;
                }
                    
            }
            break;
        }
        default:{
            WMMirror *mirror = [self.dataSource objectAtIndex:indexPath.section-1];
            WMMojingDetailViewViewController *vc = [[WMMojingDetailViewViewController alloc] init];
            vc.titleName = mirror.title;
            vc.url = [NSString stringWithFormat:@"%@?user_id=%@",mirror.url,[[WMMUser me] mid]];
            [NKNC pushViewController:vc animated:YES];
            break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
