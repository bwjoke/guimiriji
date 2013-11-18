//
//  WMHoneyListViewController.m
//  WEIMI
//
//  Created by steve on 13-4-9.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMHoneyListViewController.h"
#import "WMHoneyView.h"

@interface WMHoneyListViewController ()
{
    int indexRow;
}
@end

@implementation WMHoneyListViewController

-(void)dealloc
{
    //[honeyView release];
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
	// Do any additional setup after loading the view.
    [self.headBar insertSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-shit"]] autorelease] atIndex:0];
    [self addHeadShadow];
    
    self.titleLabel.text = @"闺蜜";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#cd6050"];
    
    [self addBackButton];
    
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    
    showTableView.frame = CGRectMake(15, 44, 290, self.view.frame.size.height-44);
    
    [self refreshData];
}

-(void)refreshData{
    
    NKRequestDelegate *rd = [NKRequestDelegate refreshRequestDelegateWithTarget:self];
    
    [[WMUserService sharedWMUserService] getRelatedUsersWithUID:[[WMMUser me] mid] andRequestDelegate:rd];
    
}

-(void)refreshDataOK:(NKRequest *)request{
    
    [super refreshDataOK:request];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"WMHoneyListCellIdentifier";
    WMHoneyListCell *cell = (WMHoneyListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[WMHoneyListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier indexPath:indexPath] autorelease];
        cell.delegate = self;
    }
    
    WMMUser *user = [self.dataSource objectAtIndex:indexPath.row];
    [cell showForObject:user];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}


-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WMMUser *user = [self.dataSource objectAtIndex:indexPath.row];
    if ([user.relation isEqualToString:NKRelationFollower] ) {
        WMHoneyRequestViewController *honeyRequestViewController = [[[WMHoneyRequestViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        honeyRequestViewController.delegate = self;
        honeyRequestViewController.user = [self.dataSource objectAtIndex:indexPath.row];
        [NKNC pushViewController:honeyRequestViewController animated:YES];
    }

}

-(void)didFollow
{
    [self refreshData];
}

-(void)didUnFollow
{
    [self refreshData];
}

-(void)unfollow:(NSIndexPath *)index
{
    indexRow = index;
    WMMUser *user = [self.dataSource objectAtIndex:index];
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(relationOK:) andFailedSelector:@selector(relationFailed:)];
    
    ProgressWith(@"正在解除");
    if ([user.virtual_user boolValue]) {
        [[WMUserService sharedWMUserService] cancelInviteUserWithAccount:user.email?user.email:user.mobile andRequestDelegate:rd];
    }else {
        [[WMUserService sharedWMUserService] unFollowUserWithUID:user.mid andRequestDelegate:rd];
    }
    
}

-(void)relationOK:(NKRequest*)request{
    
    ProgressSuccess(@"解除成功");
    [[WMHoneyView shareHoneyView:CGRectZero] setCurrentIndex:0];
    [self refreshData];
}

-(void)relationFailed:(NKRequest*)request{
    
    ProgressErrorDefault;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
