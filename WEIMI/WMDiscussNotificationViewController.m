//
//  WMDiscussNotificationViewController.m
//  WEIMI
//
//  Created by ZUO on 6/27/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMDiscussNotificationViewController.h"
#import "WMTopicService.h"
#import "WMTopicNotificationCell.h"
#import "WMDiscussDetailViewController.h"
#import "WMNotificationCenter.h"

@interface WMDiscussNotificationViewController ()

@end

@implementation WMDiscussNotificationViewController

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
    //[[WMNotificationCenter sharedNKNotificationCenter] getNotificationsCount];
    self.titleLabel.text = @"通知";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#cd6050"];
    
    [self.headBar insertSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-shit"]] autorelease] atIndex:0];
    [self addBackButton];
    
    self.showTableView.backgroundColor = [UIColor whiteColor];
    self.showTableView.frame = CGRectMake(0, 44, 320, NKMainHeight-44);
    
    self.loadingMoreView = [NKLoadingMoreView loadingMoreViewWithStyle:NKLoadingMoreViewStyleZUO];
    loadingMoreView.target = self;
    loadingMoreView.action = @selector(getMoreData);
    
    [self refreshData];
}

- (void)refreshData {
    ProgressLoading;
    
    NKRequestDelegate *rd = [NKRequestDelegate refreshRequestDelegateWithTarget:self];
    
    [[WMTopicService sharedWMTopicService] getTopicNotificationList:rd offset:0 size:DefaultOneRequestSize];
}

- (void)refreshDataOK:(NKRequest *)request {
    [super refreshDataOK:request];
    
    if (self.dataSource.count == 0) {
        [self addFooterView];
    } else {
        if ([request.hasMore boolValue]) {
            [self showFooter:NO];
        } else {
            self.showTableView.tableFooterView = nil;
        }
    }
    ProgressHide
}

- (void)getMoreData {
    [self showFooter:YES];
    
    NKRequestDelegate *rd = [NKRequestDelegate getMoreRequestDelegateWithTarget:self];
    
    [[WMTopicService sharedWMTopicService] getTopicNotificationList:rd offset:[self.dataSource count] size:DefaultOneRequestSize];
}

- (void)addFooterView {
    UIView *footerView = [[[UIView alloc] initWithFrame:CGRectMake(7, 0, 305, 108)] autorelease];
    
    UIImageView *notiIcon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_notification_big"]] autorelease];
    notiIcon.center = footerView.center;
    [footerView addSubview:notiIcon];
    CGRect rect = notiIcon.frame;
    rect.origin.y -= 10.0f;
    notiIcon.frame = rect;
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10.0f, 83.0f, 300.0f, 20.0f)] autorelease];
    label.textColor = [UIColor colorWithHexString:@"#a6937c"];
    label.font = [UIFont systemFontOfSize:13.0f];
    label.textAlignment = UITextAlignmentCenter;
    label.text = @"暂时还没有任何通知";
    [footerView addSubview:label];
    
    label = [[[UILabel alloc] initWithFrame:CGRectMake(10.0f, 103.0f, 300.0f, 20.0f)] autorelease];
    label.textColor = [UIColor colorWithHexString:@"#a6937c"];
    label.font = [UIFont systemFontOfSize:13.0f];
    label.textAlignment = UITextAlignmentCenter;
    label.text = @"当有人在讨论区回复你，将会在此通知你";
    [footerView addSubview:label];
    
    self.showTableView.tableFooterView = footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self.dataSource objectAtIndex:indexPath.row];
    return [WMTopicNotificationCell cellHeightForObject:object];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"WMDiscussNotificationViewControllerCell";
    
    id showedObject = [self.dataSource objectAtIndex:indexPath.row];
    
    WMTopicNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[WMTopicNotificationCell alloc] init];
    }
    
    [cell showForObject:showedObject];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WMMTopicNotification *notification = [self.dataSource objectAtIndex:indexPath.row];
    
    WMDiscussDetailViewController *vc = [[WMDiscussDetailViewController alloc] init];
    vc.topic_id = notification.topicID;

    [NKNC pushViewController:vc animated:YES];
    [vc release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
