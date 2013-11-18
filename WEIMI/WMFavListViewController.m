//
//  WMFavListViewController.m
//  WEIMI
//
//  Created by steve on 13-6-8.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMFavListViewController.h"
#import "WMMenCell.h"

@interface WMFavListViewController ()

@end

@implementation WMFavListViewController

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
    
    UIImageView *headView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)] autorelease];
    headView.userInteractionEnabled = YES;
    headView.image = [UIImage imageNamed:@"wiki_top_bg"];
    [self.contentView addSubview:headView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundColor:[UIColor redColor]];
    [backButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back_icon_click"] forState:UIControlStateHighlighted];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(10, 20, 10, 20)];
    backButton.frame = CGRectMake(0, 0, 60, 55);
    [backButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    //[headView addSubview:backButton];
    self.titleLabel.text = @"我和姐妹们的关注";
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#7E6B5A"];
    
    NSArray *pngArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"back_icon"],[UIImage imageNamed:@"back_icon_click"], nil];
    [self addbackButtonWithImages:pngArray];
    
    CGRect frame = self.showTableView.frame;
    frame.size.height = SCREEN_HEIGHT-66;
    self.showTableView.frame = frame;
    [self refreshData];
    
    self.loadingMoreView = [NKLoadingMoreView loadingMoreViewWithStyle:NKLoadingMoreViewStyleZUO];
    loadingMoreView.target = self;
    loadingMoreView.action = @selector(getMoreData);
    [self showFooter:NO];
    
    CGRect loadingMoreViewFrame = self.loadingMoreView.infoLabel.frame;
    //loadingMoreViewFrame.origin.x -= 25;
    self.loadingMoreView.infoLabel.frame = loadingMoreViewFrame;
}

-(void)refreshData
{
    ProgressLoading;
    NKRequestDelegate *rd = [NKRequestDelegate refreshRequestDelegateWithTarget:self];
    
    [[WMManService sharedWMManService] getMenFriendsAllFollowed:0 size:DefaultOneRequestSize andRequestDelegate:rd];
}


-(void)getMoreData{
    
    ProgressLoading;
    [self showFooter:YES];
    gettingMoreData = YES;
    
    NKRequestDelegate *rd = [NKRequestDelegate getMoreRequestDelegateWithTarget:self];
    [[WMManService sharedWMManService] getMenFriendsAllFollowed:self.dataSource.count size:DefaultOneRequestSize andRequestDelegate:rd];
    
}

-(void)getMoreDataOK:(NKRequest *)request{

    ProgressHide;
    [self showFooter:NO];
    gettingMoreData = NO;
    
    currentPage ++;
    
    if ([request.results count]) {
        [self.dataSource addObjectsFromArray:request.results];
        
        // 提升体验
        //[self.showTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
        
        [self.showTableView reloadData];
        [self setPullBackFrame];
    }
    else{
        [loadingMoreView showNoMoreContent];
        
    }
    
    if (![request.hasMore boolValue]) {
        self.showTableView.tableFooterView = nil;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return [WMMenCell cellHeightForObject:[self.dataSource objectAtIndex:indexPath.row]];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"WMFeedCellIdentifier";
    
    WMMenCell *cell = (WMMenCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[WMMenCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.shouldShowBadge = YES;
    WMMMan *man = [self.dataSource objectAtIndex:indexPath.row];
    [cell showForObject:man];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WMMMan *man = [self.dataSource objectAtIndex:indexPath.row];
    if (man.mid) {
        WMManDetailViewController *manDetailViewController = [[[WMManDetailViewController alloc] init] autorelease];
        manDetailViewController.delegate = self;
        manDetailViewController.man = man;
        manDetailViewController.shouldGetNotification = YES;
        [NKNC pushViewController:manDetailViewController animated:YES];
        //[WMManDetailViewController manDetailWithMan:man];
    }

}

-(void)shouldReload
{
    [self refreshData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
