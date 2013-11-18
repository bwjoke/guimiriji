//
//  WMDiscussViewController.m
//  WEIMI
//
//  Created by steve on 13-6-26.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//
#import "WMDataService.h"
#import "WMDiscussViewController.h"
#import "WMDiscussNotificationViewController.h"
#import "WMMTopic.h"
#import "WMCoverViewController.h"
#import "WMNotificationCenter.h"
#import "WMMyTopicViewController.h"
#import "WMMyCommentViewController.h"
#import "WMMyTopicFavViewController.h"

@interface WMDiscussViewController ()
{
    WMCoverViewController *coverViewController;
    NSMutableArray *cards;
    NKBadgeView *topicBadge;
}
@end

@implementation WMDiscussViewController

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
    UIView *tableViewHeader = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)] autorelease];
    //showTableView.tableHeaderView = tableViewHeader;
    UIImageView *bgView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)] autorelease];
    bgView.image = [UIImage imageNamed:@"wiki_top_bg"];
    [tableViewHeader addSubview:bgView];
    [self.view addSubview:tableViewHeader];
    
    CGRect frame = self.showTableView.frame;
    //frame.origin.y += 10;
    frame.size.height += 10;
    self.showTableView.frame = frame;
    
    
    UILabel *topTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 15, 320, 22)] autorelease];
    topTitleLabel.backgroundColor = [UIColor clearColor];
    topTitleLabel.font = [UIFont boldSystemFontOfSize:20];
    topTitleLabel.text = @"话题";
    topTitleLabel.textAlignment = NSTextAlignmentCenter;
    topTitleLabel.textColor = [UIColor colorWithHexString:@"#7E6B5A"];
    [tableViewHeader addSubview:topTitleLabel];
    
    UIButton *notiButton = [[[UIButton alloc] initWithFrame:CGRectMake(268, 0, 42, 46)] autorelease];
    //notiButton.backgroundColor = [UIColor grayColor];
    [notiButton setImage:[UIImage imageNamed:@"icon_notification"] forState:UIControlStateNormal];
    [notiButton setImageEdgeInsets:UIEdgeInsetsMake(14, 12, 14, 12)];
    [notiButton addTarget:self action:@selector(goToNotification:) forControlEvents:UIControlEventTouchUpInside];
    [tableViewHeader addSubview:notiButton];
    
    cards = [[NSMutableArray alloc] init];
    
    topicBadge = [[NKBadgeView alloc] initWithFrame:CGRectMake(24, 10, 14, 14)];
    topicBadge.numberLabel.hidden = YES;
    topicBadge.placeHolderImage = [[UIImage imageNamed:@"xiaohongdian"] resizeImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    topicBadge.highlightedImage = [[UIImage imageNamed:@"xiaohongdian"] resizeImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [topicBadge bindValueOfModel:[WMNotificationCenter sharedNKNotificationCenter] forKeyPath:@"hasNotification"];
    [notiButton addSubview:topicBadge];
    [topicBadge release];
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 304, 170)] autorelease];
    self.showTableView.tableHeaderView = headerView;

}

-(void)viewWillAppear:(BOOL)animated
{
    cards = [[NKDataStore sharedDataStore] cachedArrayOf:WMCacheCards andClass:[WMMTopicPicad class]];
    [self addHeaderView];
    self.dataSource = [[NKDataStore sharedDataStore] cachedArrayOf:WMCacheTopicList andClass:[WMMTopicBoard class]];
    [self.dataSource addObject:[NSNull null]];
    [self refreshData];
    ProgressLoading;
    [self getData];
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
        UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)] autorelease];
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
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 304, 170)] autorelease];
    self.showTableView.tableHeaderView = headerView;
    coverViewController = [[[WMCoverViewController alloc] init] autorelease];
    coverViewController.dataSource = cards;
    coverViewController.kNumberOfPages = [cards count];
    coverViewController.view.frame = CGRectMake(0, 10, 320, 160);
    //coverViewController.view.backgroundColor = [UIColor grayColor];
    
    [headerView addSubview:coverViewController.view];
    
}


-(void)refreshData
{
    NKRequestDelegate *rd = [NKRequestDelegate refreshRequestDelegateWithTarget:self];
    [[WMTopicService sharedWMTopicService] getTopicBoards:rd];
}

-(void)refreshDataOK:(NKRequest *)request
{
    [super refreshDataOK:request];
    
    
    // There is one more cell at last
    // "my topic" and "my comment"
    // So, append a NSNull at last of datasource
    [[NKDataStore sharedDataStore] cacheArray:self.dataSource forCacheKey:WMCacheTopicList];
    [self.dataSource addObject:[NSNull null]];
    [self.showTableView reloadData];
    //WMCacheTopicList
    
    //[self getData];
    ProgressHide;
}

-(void)refreshDataFailed:(NKRequest *)request
{
    ProgressErrorDefault;
}

#pragma mark TableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < self.dataSource.count) {
        return 90;
    } else {
        return 55;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"WMMTopicCellIdentifier";
    
    UITableViewCell *cell = nil;
    
    WMMTopicBoard *topic = self.dataSource[indexPath.row];
    
    if ([topic isKindOfClass:[WMMTopicBoard class]]) {
        WMDiscussBoardsCell *boardCell = (WMDiscussBoardsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (boardCell == nil) {
            boardCell = [[[WMDiscussBoardsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        }
        
        WMMTopicBoard *topic = [self.dataSource objectAtIndex:indexPath.row];
        [boardCell showForObject:topic];
        
        cell = boardCell;
    } else { // NSNull class
        cell = [[NSBundle mainBundle] loadNibNamed:@"UIMyTopicViewCell" owner:self options:nil][0];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WMMTopicBoard *topicBoard = [self.dataSource objectAtIndex:indexPath.row];
    if (topicBoard.doorClose) {
        ProgressFailedWith(topicBoard.doorCloseMsg);
        return;
    }
    WMDiscussListViewController *listVC = [[[WMDiscussListViewController alloc] init] autorelease];
    listVC.topicboard = topicBoard;
    [NKNC pushViewController:listVC animated:YES];
}


-(void)goToNotification:(id)sender
{
    //topicBadge.hidden = YES;
    [[WMNotificationCenter sharedNKNotificationCenter] setHasNotification:@(NO)];
    WMDiscussNotificationViewController *vc = [[WMDiscussNotificationViewController alloc] init];
    [NKNC pushViewController:vc animated:YES];
    [vc release];
}

#pragma mark - Cell outlet

- (IBAction)lookMyTopic:(id)sender {
    WMMyTopicViewController *vc = [[WMMyTopicViewController alloc] init];
    [NKNC pushViewController:vc animated:YES];
    [vc release];
}


- (IBAction)lookMyComment:(id)sender {
    WMMyCommentViewController *vc = [[WMMyCommentViewController alloc] init];
    [NKNC pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)lookMyFav:(id)sender {
    WMMyTopicFavViewController *vc = [[WMMyTopicFavViewController alloc] init];
    [NKNC pushViewController:vc animated:YES];
    [vc release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
