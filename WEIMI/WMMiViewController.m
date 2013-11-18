//
//  WMMiViewController.m
//  WEIMI
//
//  Created by King on 11/19/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//

#import "WMMiViewController.h"
#import "WMPostViewController.h"
#import "WMNoContentView.h"
#import "WMHoneyView.h"
#import "WMMUser.h"

#import "MPNotificationView.h"

@interface WMMiViewController ()
{
    WMNoContentView *noContentView;
    int errorCount;
}

@property (nonatomic, retain) WMFeedCell2 *templateCell;

@end

@implementation WMMiViewController

@synthesize user;
@synthesize delegate;

#define MSG_TEXT @"薇蜜，只能和闺蜜一起玩的应用，所以一定要发给你 >> http://www.weimi.com/?f=smsinv"

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NKAddFeedOKNotificationKey object:nil];
    
    [user release];
    [_templateCell release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addFeedOK:) name:NKAddFeedOKNotificationKey object:nil];
    }
    return self;
}

-(void)addFeedOK:(NSNotification*)noti{
    
    [self.dataSource insertObject:[noti object] atIndex:0];
    
    [showTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.templateCell = [[[WMFeedCell2 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil] autorelease];
    
    errorCount = 0;
    self.headBar.hidden = YES;
//    [self frinedShow];
//    self.loadingMoreView = [NKLoadingMoreView loadingMoreViewWithStyle:NKLoadingMoreViewStyleZUO];
//    loadingMoreView.target = self;
//    loadingMoreView.action = @selector(getMoreData);
    if ([user.relation isEqualToString:NKRelationFriend] || [user.mid isEqualToString: [[WMMUser me] mid]]) {
        // show content
        self.refreshHeaderView.hidden = NO;
        [self frinedShow];
        self.loadingMoreView = [NKLoadingMoreView loadingMoreViewWithStyle:NKLoadingMoreViewStyleZUO];
        loadingMoreView.target = self;
        loadingMoreView.action = @selector(getMoreData);
        [self showFooter:NO];
        showHeaderInSection = YES;
    }
    else if ([user.relation isEqualToString:NKRelationFollowing]){
        // show Follow
        //self.showTableView.hidden = YES;
        self.refreshHeaderView.hidden = YES;
        self.shouldAutoRefreshData = NO;
        showHeaderInSection = NO;
        [self showFollowView];
        
    }
    else if ([user.relation isEqualToString:NKRelationFollower]){
        // show follower Accept or something
        //self.showTableView.hidden = YES;
        self.refreshHeaderView.hidden = YES;
        self.shouldAutoRefreshData = NO;
        showHeaderInSection = NO;
        [self showFollowerView];
    }

    UIImageView *topShadow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow_top"]] autorelease];
    [self.view addSubview:topShadow];
    CGRect topShadowFrame = topShadow.frame;
    topShadowFrame.origin.y = -2;
    topShadow.frame = topShadowFrame;
    
    UIImageView *bShadow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow_bottom"]] autorelease];
    [self.view addSubview:bShadow];
    CGRect shadowFrame = bShadow.frame;
    shadowFrame.origin.y = NKContentHeight - 45 - shadowFrame.size.height;
    bShadow.frame = shadowFrame;
    
    if ([user.mid isEqualToString: [[WMMUser me] mid]]) {
        [self addHeaderView];
    }
    self.loadingMoreView = [NKLoadingMoreView loadingMoreViewWithStyle:NKLoadingMoreViewStyleZUO];
    loadingMoreView.target = self;
    loadingMoreView.action = @selector(getMoreData);
}

-(void)addHeaderView
{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)] autorelease];
    headerView.backgroundColor = [UIColor clearColor];
    self.showTableView.tableHeaderView = headerView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)addCreateFeed{
    
    WMMFeed *createFeed = [[[WMMFeed alloc] init] autorelease];
    
    createFeed.feedType = WMMFeedTypeCreate;
    createFeed.createTime = [NSDate date];
    
    NSMutableArray *array = [NSMutableArray arrayWithObject:createFeed];
    
    [array addObjectsFromArray:self.dataSource];
    
    self.dataSource = array;
    
    [showTableView reloadData];
}

-(void)frinedShow{
    
    
    showTableView.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)] autorelease];
    showTableView.tableFooterView = nil;
    [self refreshData];
    ProgressLoading;
    CGRect progressViewFrame = progressView.frame;
    progressViewFrame.origin.y -=54;
    progressView.frame = progressViewFrame;
    
    if (self.user == [WMMUser me]) {
        
        self.dataSource = [[NKDataStore sharedDataStore] cachedArrayOf:WMCachePathMyFeeds andClass:[WMMFeed class]];
        
        [self addCreateFeed];
        
        
    }
    else{


    }
    
    
}

-(void)addNewFeed:(id)sender{
    
    WMPostViewController *post = [[WMPostViewController alloc] init];
    [NKNC presentModalViewController:post animated:YES];
    [post release];
    
}

#pragma mark Relation

-(void)showFollowView{
    
    UIView *footer = [[UIView alloc] initWithFrame:showTableView.bounds];
    showTableView.tableFooterView = footer;
    [footer release];
    
    UIImageView *icon = [[[UIImageView alloc] initWithFrame:CGRectMake(135, 30, 52, 52)] autorelease];
    icon.image = [UIImage imageNamed:@"invite_icon"];
    [footer addSubview:icon];
    
    for (int i=0; i<3; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 122+i*30, 320, 20)];
        label.font = [UIFont boldSystemFontOfSize:18];
        [footer addSubview:label];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.numberOfLines = 0;
        label.textColor = [UIColor colorWithHexString:@"#7e6b5a"];
        switch (i) {
            case 0:
                label.text = @"已经发送闺蜜邀请给";
                break;
            case 1:
                label.text = [NSString stringWithFormat:@"%@", self.user.name?self.user.name:user.mobile?user.mobile:user.email];
                break;
            case 2:
                label.text = @"等待对方接受";
                break;
            default:
                break;
        }
        
        [label release];

    }
    
    if (!self.user.noSMS) {
        UIButton *noticButton = [[[UIButton alloc] initWithFrame:CGRectMake(110, 122+111, 100, 31)] autorelease];
        [noticButton setBackgroundImage:[UIImage imageNamed:@"btn_invite_notic"] forState:UIControlStateNormal];
        [noticButton setBackgroundImage:[UIImage imageNamed:@"btn_invite_notic_click"] forState:UIControlStateHighlighted];
        [noticButton setTitle:@"短信提醒她" forState:UIControlStateNormal];
        [noticButton setTitleColor:[UIColor colorWithHexString:@"#7e6b5a"] forState:UIControlStateNormal];
        noticButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [noticButton addTarget:self action:@selector(sendSMS:) forControlEvents:UIControlEventTouchUpInside];
        [footer addSubview:noticButton];
    }
    
    UILabel *unfollowLabel = [[[UILabel alloc] initWithFrame:CGRectMake(120, 122+180, 80, 14)] autorelease];
    unfollowLabel.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
    unfollowLabel.font = [UIFont systemFontOfSize:12];
    unfollowLabel.backgroundColor = [UIColor clearColor];
    unfollowLabel.text = @"取消这个申请";
    unfollowLabel.textAlignment = UITextAlignmentCenter;
    unfollowLabel.userInteractionEnabled = YES;
    [footer addSubview:unfollowLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(unfollow:)];
    [unfollowLabel addGestureRecognizer:tap];
    
}

-(void)sendSMS:(id)sender
{
    MFMessageComposeViewController *msgController = [[[MFMessageComposeViewController alloc] init] autorelease];
    if ([MFMessageComposeViewController canSendText]) {
        msgController.body = MSG_TEXT;
        if (self.user.mobile) {
            msgController.recipients = [NSArray arrayWithObject:self.user.mobile];
        }
        msgController.messageComposeDelegate = self;
        [NKNC presentModalViewController:msgController animated:YES];
    }
    
//    if (self.user.mobile) {
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",self.user.mobile?self.user.mobile:nil]]];
//    }else {
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"sms:// "]];
//    }

}

// 处理发送完的响应结果
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
    ProgressWith(@"发送中");
    if (result == MessageComposeResultCancelled) {
        NSLog(@"Message cancelled");
        ProgressSuccess(@"取消发送");;
    }else if (result == MessageComposeResultSent) {
        NSLog(@"Message sent");
        ProgressSuccess(@"发送成功");
    }else {
        ProgressFailed;
    }
    [NKNC dismissModalViewControllerAnimated:YES];
}


-(void)unfollowOK:(NKRequest*)request{

    if ([delegate respondsToSelector:@selector(controller:didUnfollowUser:)]) {
        ProgressSuccess(@"取消邀请成功");
        [[WMHoneyView shareHoneyView:CGRectZero] setCurrentIndex:0];
        [delegate controller:self didUnfollowUser:self.user];
    }
    
}
-(void)unfollowFailed:(NKRequest*)request{
    ProgressErrorDefault;
}

-(void)unfollow:(id)sender{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否确认取消这个邀请？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        ProgressWith(@"正在取消邀请");
        NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(unfollowOK:) andFailedSelector:@selector(unfollowFailed:)];
        if ([self.user.virtual_user boolValue]) {
            [[WMUserService sharedWMUserService] cancelInviteUserWithAccount:self.user.email?self.user.email:self.user.mobile andRequestDelegate:rd];
        }else {
            [[WMUserService sharedWMUserService] unFollowUserWithUID:self.user.mid andRequestDelegate:rd];
        }

    }
}

-(void)followOK:(NKRequest*)request{
    
    [self frinedShow];
    
    
}
-(void)followFailed:(NKRequest*)request{
    
}

-(void)follow:(id)sender{
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(followOK:) andFailedSelector:@selector(followFailed:)];
    [[NKUserService sharedNKUserService] followUserWithUID:self.user.mid andRequestDelegate:rd];
}

-(void)showFollowerView{
    
//    UIView *footer = [[UIView alloc] initWithFrame:showTableView.bounds];
//    showTableView.tableFooterView = footer;
//    [footer release];
    
    WMHoneyRequestViewController *honeyRequestViewController = [[WMHoneyRequestViewController alloc] initWithNibName:nil bundle:nil] ;
    honeyRequestViewController.delegate = self;
    honeyRequestViewController.user = self.user;
    honeyRequestViewController.showHeaderBar = YES;
    [self.contentView addSubview:honeyRequestViewController.view];
    
}

-(void)didFollow
{
    if ([delegate respondsToSelector:@selector(controller:didfollowUser:)]) {
        [delegate controller:self didfollowUser:self.user];
    }
}

-(void)didUnFollow
{
    if ([delegate respondsToSelector:@selector(controller:didfollowUser:)]) {
        [delegate controller:self didUnfollowUser:self.user];
    }
}

#pragma mark Data

-(void)refreshData{
    
    NKRequestDelegate *rd = [NKRequestDelegate refreshRequestDelegateWithTarget:self];
    
    [[WMFeedService sharedWMFeedService] getFeedsWithUID:self.user.mid offset:0 size:DefaultOneRequestSize andRequestDelegate:rd];

}

-(void)getMoreData
{
    [self showFooter:YES];
    gettingMoreData = YES;
    
    NKRequestDelegate *rd = [NKRequestDelegate getMoreRequestDelegateWithTarget:self];
    
    [[WMFeedService sharedWMFeedService] getFeedsWithUID:self.user.mid offset:[self.dataSource count] size:DefaultOneRequestSize andRequestDelegate:rd];
}

-(void)commentFinished
{
    [self refreshData];
}

-(void)refreshDataOK:(NKRequest *)request{
    
    [super refreshDataOK:request];
    
    if (self.user == [WMMUser me]) {
        [[NKDataStore sharedDataStore] cacheArray:self.dataSource forCacheKey:WMCachePathMyFeeds];
        if (!noContentView) {
            noContentView = [[[WMNoContentView alloc] init] autorelease];
            [self.contentView insertSubview:noContentView atIndex:0];
        }
        
        if ([self.dataSource count]==0) {
            noContentView.frame = CGRectMake(0, 130, 320, 120);
            [noContentView setText: [NSString stringWithFormat:@"%@还没有发过任何内容",self.user.name]];
            
        }else {
            if (noContentView) {
                [noContentView removeFromSuperview];
                noContentView = nil;
            }
            
        }
        [self addCreateFeed];
    }else {
        if (!noContentView) {
            noContentView = [[[WMNoContentView alloc] init] autorelease];
            [self.contentView insertSubview:noContentView atIndex:0];
        }
        if ([self.dataSource count]==0) {
            noContentView.frame = CGRectMake(0, 130, 320, 120);
            [noContentView setText: [NSString stringWithFormat:@"%@还没有发过任何内容",self.user.name]];
            
        }else {
            if (noContentView) {
                [noContentView removeFromSuperview];
                noContentView = nil;
            }
            
        }
    }
    
    
    
    
}

//-(void)refreshDataFailed:(NKRequest *)request
//{
//    NSLog(@"%@",[request.errorCode stringValue]);
//    if ([request.errorCode integerValue] == 11026 && errorCount == 0) {
//        errorCount ++;
//        if ([user.relation isEqualToString:NKRelationFriend] || [user.mid isEqualToString: [[WMMUser me] mid]]) {
//            // show content
//            
//            [self frinedShow];
//            self.loadingMoreView = [NKLoadingMoreView loadingMoreViewWithStyle:NKLoadingMoreViewStyleZUO];
//            loadingMoreView.target = self;
//            loadingMoreView.action = @selector(getMoreData);
//            [self showFooter:NO];
//        }
//        else if ([user.relation isEqualToString:NKRelationFollowing]){
//            // show Follow
//            self.shouldAutoRefreshData = NO;
//            [self showFollowView];
//        }
//        else if ([user.relation isEqualToString:NKRelationFollower]){
//            // show follower Accept or something
//            self.shouldAutoRefreshData = NO;
//            [self showFollowerView];
//        }
//        ProgressHide;
//    }else {
//        [super refreshDataFailed:request];
//    }
//    
//}

#pragma mark TableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.templateCell showForIndexPath:indexPath dataSource:self.dataSource];
    
    return self.templateCell.frame.size.height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (![self isMyPage] && section == 0 &&showHeaderInSection) {
        return 38.0f;
    }
    
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (![self isMyPage] && section == 0 && showHeaderInSection) {
        UIButton *chatView = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.bounds.size.width, 38.0f)];
        [chatView setBackgroundImage:[UIImage imageNamed:@"chat_input"] forState:UIControlStateNormal];
        [chatView addTarget:self action:@selector(chatWith:) forControlEvents:UIControlEventTouchUpInside];
        
        chatView.backgroundColor = [UIColor clearColor];
        
        unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 120.0f, 44.0f)];
        unreadLabel.backgroundColor = [UIColor clearColor];
        unreadLabel.center = CGPointMake(chatView.bounds.size.width / 2.0f+45, chatView.bounds.size.height / 2.0f);
        
        unreadLabel.textAlignment = UITextAlignmentLeft;
        unreadLabel.font = [UIFont systemFontOfSize:14];        
        [chatView addSubview:unreadLabel];
        
        msgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(unreadLabel.center.x-50-16-16, 12, 16, 16)];
        [chatView addSubview:msgIcon];
        
        unreadLabel.textColor = [UIColor colorWithHexString:@"#7c6d5d"];
        unreadLabel.text = @"开始聊天";
        msgIcon.image = [UIImage imageNamed:@"chat_msg"];
        
        [self checkNewMessage];
        
        
        return chatView;
    }
    
    return nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self checkNewMessage];
}

-(void)checkNewMessage
{
    NSDictionary *imDic = [[WMNotificationCenter sharedNKNotificationCenter] imDic];
    if ([imDic isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = [imDic valueForKey:user.mid];
//        UIAlertView *unread = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@条新消息",[dic valueForKey:@"unread"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [unread show];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            if ([[dic valueForKey:@"unread"] intValue]>0) {
                unreadLabel.textColor = [UIColor colorWithHexString:@"#e8666a"];
                unreadLabel.text = [NSString stringWithFormat:@"%@条新消息",[dic valueForKey:@"unread"]];
                msgIcon.image = [UIImage imageNamed:@"chat_new_msg"];
            }else if([[dic valueForKey:@"all"] intValue]>0){
                unreadLabel.textColor = [UIColor colorWithHexString:@"#7c6d5d"];
                unreadLabel.text = [NSString stringWithFormat:@"%@条消息",[dic valueForKey:@"all"]];
                msgIcon.image = [UIImage imageNamed:@"chat_msg"];
            }else {
                unreadLabel.textColor = [UIColor colorWithHexString:@"#7c6d5d"];
                unreadLabel.text = @"开始聊天";
                msgIcon.image = [UIImage imageNamed:@"chat_msg"];
            }
        }
    }else {
        unreadLabel.textColor = [UIColor colorWithHexString:@"#7c6d5d"];
        unreadLabel.text = @"开始聊天";
        msgIcon.image = [UIImage imageNamed:@"chat_msg"];
    }
    
    [self performSelector:@selector(checkNewMessage) withObject:nil afterDelay:15.0];
}

-(void)viewWillDisappear:(BOOL)animated
{
    //[[self class] cancelPreviousPerformRequestsWithTarget:self];
}

- (BOOL)isMyPage {
    NSString *userMid = [self.user.mid description];
    NSString *meMid = [[[WMMUser me] mid] description];
    
    return [userMid isEqualToString:meMid];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"WMFeedCellIdentifier";
    
    WMFeedCell2 *cell = (WMFeedCell2 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[WMFeedCell2 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.delegate = self;
    }
    
    [cell showForIndexPath:indexPath dataSource:dataSource];
    
    return cell;
}

-(void)createFeed
{
    WMAddMiyuViewController *addMiyu = [[WMAddMiyuViewController alloc] init];
    addMiyu.delegate = self;
    addMiyu.man = [WMMUser me];
    [NKNC pushViewController:addMiyu animated:YES];
    [addMiyu release];
}

-(void)tellReloadData
{
    [self refreshData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WMMFeed *feed = [self.dataSource objectAtIndex:indexPath.row];
    if (feed.feedType == WMMFeedTypeCreate) {
        [self createFeed];
    }else {
        WMFeedDetailViewController *feedDetalViewController = [[[WMFeedDetailViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        feedDetalViewController.feed = feed;
        feedDetalViewController.delegate = self;
        feedDetalViewController.parseIndexPath = indexPath;
        [NKNC pushViewController:feedDetalViewController animated:YES];
    }
}

-(void)deleteFeed
{
    [self frinedShow];
}

- (void)chatWith:(WMMUser *)users {
    // TODO
    WMConverstionViewController *converstionViewController = [[WMConverstionViewController alloc] initWithNibName:nil bundle:nil];
    converstionViewController.user = user;
    converstionViewController.delegate = self;
    [NKNC pushViewController:converstionViewController animated:YES];
    
    NSDictionary *imDic = [[WMNotificationCenter sharedNKNotificationCenter] imDic];
    int numOfIm = 0;
    if ([imDic isKindOfClass:[NSDictionary class]] && ![imDic isKindOfClass:[NSNull class]]) {
        if ([[imDic valueForKey:user.mid] isKindOfClass:[NSDictionary class]]) {
            if ([[[imDic valueForKey:user.mid] valueForKey:@"unread"] boolValue]) {
                numOfIm += 1;
            }
        }
    }
    int numOfNotic = [[WMNotificationCenter sharedNKNotificationCenter] numOfNotics];
    if (numOfIm < numOfNotic) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:numOfNotic-numOfIm];
    }else {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
}

-(void)updateMessageCount:(int)count
{
    unreadLabel.textColor = [UIColor colorWithHexString:@"#7c6d5d"];
    unreadLabel.text = [NSString stringWithFormat:@"%d条消息",count];
    msgIcon.image = [UIImage imageNamed:@"chat_msg"];
}

@end
