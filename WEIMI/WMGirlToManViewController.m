//
//  WMGirlToManViewController.m
//  WEIMI
//
//  Created by King on 3/25/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMGirlToManViewController.h"
#import "WMFeedDetailViewController.h"
#import "WMManUserCell.h"
#import "WMFeedCell.h"


@interface WMGirlToManViewController ()

@end

@implementation WMGirlToManViewController

-(void)dealloc{
    
    [_man release];
    [_manUser release];
    
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
    
    [self addBackButton];
    
    [self.headBar insertSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_head_back"]] autorelease] atIndex:0];
    [self addHeadShadow];
    
    showTableView.backgroundColor = [UIColor whiteColor];
    showTableView.frame = CGRectMake(0, 44, 320, NKMainHeight-44);
    
    self.titleLabel.text = self.man.name;
    
    UIView *header = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [WMManUserCell cellHeightForObject:nil])] autorelease];
    
    WMManUserCell *muc = [[[WMManUserCell alloc] initWithFrame:CGRectMake(0, 0, 320, [WMManUserCell cellHeightForObject:nil])] autorelease];
    [header addSubview:muc];
    [muc.bottomLine removeFromSuperview];
    [muc showForObject:self.manUser];
    muc.accessoryView = nil;
    self.showTableView.tableHeaderView = header;
    
    UIImageView *shadow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_tableviewheader_shadow"]] autorelease];
    [header addSubview:shadow];
    CGRect shadowFrame = shadow.frame;
    shadowFrame.origin.y = header.frame.size.height;
    shadow.frame = shadowFrame;
    
    [self refreshData];
    ProgressLoading;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshData{
    
    NKRequestDelegate *rd = [NKRequestDelegate refreshRequestDelegateWithTarget:self];
    [[WMManService sharedWMManService] getFeedsOfGirlToManWithUID:self.manUser.user.mid manID:self.man.mid isAnonymous:self.manUser.isAnonymous offset:0 size:DefaultOneRequestSize andRequestDelegate:rd];
    
}

-(void)refreshDataOK:(NKRequest *)request{
    
    [super refreshDataOK:request];
    
    
}



#pragma mark TableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return [WMFeedCell cellHeightForObject:[self.dataSource objectAtIndex:indexPath.row]];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"WMFeedCellIdentifier";
    
    WMFeedCell *cell = (WMFeedCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[WMFeedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    WMMFeed *feed = [self.dataSource objectAtIndex:indexPath.row];
    [cell showForObject:feed];
    
    
    BOOL shoulShowDay = YES;
    
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"dd"];
    
    NSString *day = [dateFormatter stringFromDate:feed.createTime];
    
    
    if (indexPath.row == 0) {
        shoulShowDay = YES;
    }
    else{
        
        WMMFeed *preFeed = [self.dataSource objectAtIndex:indexPath.row-1];
        NSString *preDay = [dateFormatter stringFromDate:preFeed.createTime];
        
        shoulShowDay = ![preDay isEqualToString:day];
        
    }
    
    [cell showDate:shoulShowDay dateFormatter:dateFormatter];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WMMFeed *feed = [self.dataSource objectAtIndex:indexPath.row];
    
    WMBaoliaoXiangqingViewController *baoliaoXiangqing = [[[WMBaoliaoXiangqingViewController alloc] init] autorelease];
    baoliaoXiangqing.man = self.man;
    baoliaoXiangqing.feed = feed;
    baoliaoXiangqing.manUser = self.manUser;
    baoliaoXiangqing.delegate = self;
    [NKNC pushViewController:baoliaoXiangqing animated:YES];

}

-(void)deleteFeed
{
    [self refreshData];
}


@end
