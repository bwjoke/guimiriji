//
//  WMInviteFriendsViewController.m
//  WEIMI
//
//  Created by steve on 13-5-24.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMInviteFriendsViewController.h"

@interface WMInviteFriendsViewController ()
{
    int page;
    NSMutableArray *inviteList;
}
@end

@implementation WMInviteFriendsViewController

-(void)dealloc
{
    [inviteList release];
    [_man release];
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
    [self.headBar insertSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_head_back"]] autorelease] atIndex:0];
    [self addHeadShadow];
    
    page = 1;
    
    inviteList = [[NSMutableArray alloc] init];
    
    self.titleLabel.text = [NSString stringWithFormat:@"匿名邀请(已选0/10)"];
    [self addRightButtonWithTitle:@"完成"];
    [self addBackButton];
    
    showTableView.frame = CGRectMake(0, 44, 320, NKMainHeight-44);
    showTableView.delegate = self;
    showTableView.dataSource = self;
    showTableView.backgroundColor = [UIColor whiteColor];
    
    [self refreshData];
    ProgressLoading;
    
    [self.refreshHeaderView removeFromSuperview];
    self.refreshHeaderView = nil;
    
    self.loadingMoreView = [NKLoadingMoreView loadingMoreViewWithStyle:NKLoadingMoreViewStyleZUO];
    loadingMoreView.target = self;
    loadingMoreView.action = @selector(getMoreData);
    [self showFooter:NO];
    
    //self.showTableView.backgroundColor = [UIColor colorWithHexString:@"#e1d7c8"];
    [self addTableHeaderView];
}

-(void)refreshData
{
    page = 1;
    NKRequestDelegate *rd = [NKRequestDelegate refreshRequestDelegateWithTarget:self];
    
    [[WMManService sharedWMManService] getManWeiboFansWithMID:self.man.mid type:nil page:1 size:DefaultOneRequestSize andRequestDelegate:rd];
}

-(void)refreshDataOK:(NKRequest *)request
{
    [super refreshDataOK:request];
    //NSLog(@"----------------: %@",request.responseString);
}

-(void)getMoreData
{
    [self showFooter:YES];
    gettingMoreData = YES;
    
    NKRequestDelegate *rd = [NKRequestDelegate getMoreRequestDelegateWithTarget:self];
    
    [[WMManService sharedWMManService] getManWeiboFansWithMID:self.man.mid type:nil page:++page size:DefaultOneRequestSize andRequestDelegate:rd];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"WMWeiboFansCellIdentifier";
    
    WMWeiboUserCell *cell = (WMWeiboUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[WMWeiboUserCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier index:indexPath.row] autorelease];
        cell.delegate = self;
    }
    WMWeiboUser *user = [self.dataSource objectAtIndex:indexPath.row];
    cell.index = indexPath.row;
    [cell showForObject:user];
    
    
    return cell;
}

-(void)inviteButtonClicked:(int)index
{
    WMWeiboUser *user = [self.dataSource objectAtIndex:index];
    
    if (user.hasInvited) {
        return;
    }
    
    if ([inviteList count] == 10) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"一次最多邀请10位哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
    [dic setValue:user.weiboId forKey:@"weiboid"];
    [dic setValue:user.name forKey:@"weiboname"];
    
    if (user.localHasInvited) {
        for (int i=0; i<[inviteList count]; i++) {
            NSDictionary *tmp = (NSDictionary *)[inviteList objectAtIndex:i];
            if ([[tmp valueForKey:@"weiboid"] longLongValue] == [user.weiboId longLongValue]) {
                [inviteList removeObjectAtIndex:i];
            }
        }
    }else {
        [inviteList addObject:dic];
    }
    
    user.localHasInvited = !user.localHasInvited;
    
    self.titleLabel.text = [NSString stringWithFormat:@"匿名邀请(已选%d/10)",[inviteList count]];
    [self.dataSource replaceObjectAtIndex:index withObject:user];
    [self.showTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self inviteButtonClicked:indexPath.row];
}

-(void)rightButtonClick:(id)sender
{
    if (inviteList.count == 0) {
        return;
    }
    
    ProgressLoading;
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(inviteOK:) andFailedSelector:@selector(inviteFailed:)];
    
    [[WMManService sharedWMManService] inviteManFansWithMID:self.man.mid weibos:inviteList andRequestDelegate:rd];
}

-(void)inviteOK:(NKRequest *)request
{
    ProgressSuccess(@"邀请成功");
    [self performSelector:@selector(goBack:) withObject:nil afterDelay:1.0];
    //[self goBack:nil];
}

-(void)inviteFailed:(NKRequest *)request
{
    ProgressErrorDefault;
}

-(void)addTableHeaderView
{
    NSString *str = [NSString stringWithFormat:@"匿名委托 @薇蜜传话筒 发一条微博「艾特」并邀请 %@ 的微博粉丝好友一起来点评他(没有人会知道是你发起的o(∩_∩)o)",self.man.name];
    
    CGFloat height = 145;
    UIView *headerView = [[[UIView alloc] init] autorelease];
    CGFloat labelHeight = [str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(320-32, 200) lineBreakMode:NSLineBreakByCharWrapping].height;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 19, 320-32, labelHeight)];
    label.backgroundColor = [UIColor clearColor];
    label.text = str;
    label.textColor = [UIColor colorWithHexString:@"#A6937C"];
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines = 0;
    [headerView addSubview:label];
    [label release];
    height = 19+labelHeight+20;
    
    headerView.frame = CGRectMake(0, 0, 320, height);
    headerView.backgroundColor = [UIColor colorWithHexString:@"#F1ECE4"];
    UIImageView *shadow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_tableviewheader_shadow"]] autorelease];
    [headerView addSubview:shadow];
    CGRect shadowFrame = shadow.frame;
    shadowFrame.origin.y = height;
    shadow.frame = shadowFrame;
    self.showTableView.tableHeaderView = headerView;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
