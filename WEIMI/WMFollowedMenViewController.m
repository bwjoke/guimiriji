//
//  WMFollowedMenViewController.m
//  WEIMI
//
//  Created by King on 3/14/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMFollowedMenViewController.h"
#import "WMMenCell.h"
#import "WMNoContentView.h"

@interface WMFollowedMenViewController ()
{
    WMNoContentView *noContentView;
}
@end

@implementation WMFollowedMenViewController


-(void)dealloc{
    
    [_user release];
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
    self.headBar.hidden = YES;
    [self refreshData];
    if (!_hideProgress) {
        ProgressLoading;
    }
    
    
    [self.refreshHeaderView changeStyle:EGORefreshTableHeaderStyleZUO];
    
    CGRect refreshHeaderFrame = self.refreshHeaderView.frame;
    refreshHeaderFrame.origin.x -=30;
    //refreshHeaderFrame.origin.y += 30;
    refreshHeaderFrame.size.width += 320;
    self.refreshHeaderView.frame = refreshHeaderFrame;
    
    

    UIImageView *topShadow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow_top"]] autorelease];
    [self.contentView addSubview:topShadow];
    CGRect topShadowFrame = topShadow.frame;
    topShadowFrame.origin.y = 13+54;
    topShadow.frame = topShadowFrame;
    
    UIImageView *bShadow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow_bottom"]] autorelease];
    [self.contentView addSubview:bShadow];
    CGRect shadowFrame = bShadow.frame;
    shadowFrame.origin.y = NKContentHeight - 75 - shadowFrame.size.height+54;
    bShadow.frame = shadowFrame;
    
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(27, 45, 300, 14)] autorelease];
    label.font = [UIFont boldSystemFontOfSize:12];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithHexString:@"#A6937C"];

    if ([_user.mid isEqualToString:[[WMMUser me] mid]]) {
        label.text = @"我的关注";
    }else {
        label.text = [NSString stringWithFormat:@"%@的关注",_user.name];
    }
    
    [self.contentView addSubview:label];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)refreshData{
    
    NKRequestDelegate *rd = [NKRequestDelegate refreshRequestDelegateWithTarget:self];
    
    [[WMManService sharedWMManService] getFollowedMenWithUID:self.user.mid offset:0 size:DefaultOneRequestSize andRequestDelegate:rd];
    
}


-(void)refreshDataOK:(NKRequest *)request
{
    [super refreshDataOK:request];
    if (!noContentView) {
        noContentView = [[[WMNoContentView alloc] init] autorelease];
        [self.contentView insertSubview:noContentView atIndex:0];
    }
    
    if ([self.dataSource count]==0) {
        noContentView.frame = CGRectMake(0, 130, 320, 120);
        [noContentView setText: [NSString stringWithFormat:@"%@还没有关注任何点评",self.user.name]];
        
    }else {
        if (noContentView) {
            [noContentView removeFromSuperview];
            noContentView = nil;
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WMMMan *man = [self.dataSource objectAtIndex:indexPath.row];
    return [WMMenCell cellHeightForObject:man];
    
}


//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 14)] autorelease];
//    headerView.backgroundColor = [UIColor clearColor];
//    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 14)] autorelease];
//    label.font = [UIFont systemFontOfSize:12];
//    label.backgroundColor = [UIColor clearColor];
//    label.textColor = [UIColor colorWithHexString:@"#A6937C"];
//    if ([self.dataSource count]==0) {
//        return nil;
//    }
//    if ([_user.mid isEqualToString:[[WMMUser me] mid]]) {
//        label.text = @"我的关注";
//    }else {
//        label.text = [NSString stringWithFormat:@"%@的关注",_user.name];
//    }
//    
//    [headerView addSubview:label];
//    return headerView;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"WMFeedCellIdentifier";
    
    WMMenCell *cell = (WMMenCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[WMMenCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.shouldShowBadge = YES;
    }
    WMMMan *man = [self.dataSource objectAtIndex:indexPath.row];
    cell.user_id = _user.mid;
    [cell showForObject:man];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WMManDetailViewController *manDetailViewController = [[[WMManDetailViewController alloc] init] autorelease];
    WMMMan *man = [self.dataSource objectAtIndex:indexPath.row];
    manDetailViewController.man = man;
    manDetailViewController.shouldGetNotification = YES;
    manDetailViewController.delegate = self;
    [NKNC pushViewController:manDetailViewController animated:YES];
    //[WMManDetailViewController manDetailWithMan:man];
    
}

-(void)shouldReload
{
    [self refreshData];
}

@end
