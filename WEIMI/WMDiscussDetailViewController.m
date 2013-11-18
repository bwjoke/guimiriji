//
//  WMDiscussDetailViewController.m
//  WEIMI
//
//  Created by ZUO on 6/28/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMDiscussDetailViewController.h"
#import "WMCustomLabel.h"
#import "WMTopicContentView.h"
#import "WMAudioPlayer.h"
#import <objc/runtime.h>

enum tWMDiscussDetailViewTag {
    kWMDiscussDetailViewTagConfirmDelete = 1
};

@interface WMDiscussDetailViewController ()
{
    NSString *orderBy;
    NSString *reportCommentId;
}
@end

@implementation WMDiscussDetailViewController

@synthesize showTopic;

#define MORE_SHEET 13070201
#define REPORT_SHEET 13070202
#define REPORT_COMMENT_SHEET 13102101
#define LZ_ACTION_SHEET 13100803

+(id)topicDetailWithTopicid:(NSString *)topic_id
{
    WMDiscussDetailViewController *vc = [[WMDiscussDetailViewController alloc] init];
    vc.topic_id = topic_id;
    [NKNC pushViewController:vc animated:YES];
    return vc;
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
    
    orderBy = @"ASC";
    
    self.titleLabel.text = @"话题";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#cd6050"];
    
    [self.headBar insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-shit"]] atIndex:0];
    [self addHeadShadow];
    [self addBackButton];
    
    //self.showTableView.backgroundColor = [UIColor whiteColor];
    self.showTableView.frame = CGRectMake(0, 44, 320, NKMainHeight-44);
    
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#f5eee3"];
    
    [self addRightButtonWithFontTitle:@"● ● ●"];
    
    UIButton *replyBtn = [self addRightButtonWithTitle:@"回复"];
    CGRect frame = replyBtn.frame;
    frame.origin.x -= 52;
    replyBtn.frame = frame;
    [replyBtn removeTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [replyBtn addTarget:self action:@selector(reply:) forControlEvents:UIControlEventTouchUpInside];
    
    self.loadingMoreView = [NKLoadingMoreView loadingMoreViewWithStyle:NKLoadingMoreViewStyleZUO];
    loadingMoreView.target = self;
    loadingMoreView.action = @selector(getMoreData);
    [self showFooter:NO];
    
    CGRect loadingMoreViewFrame = self.loadingMoreView.infoLabel.frame;
    //loadingMoreViewFrame.origin.x -= 25;
    self.loadingMoreView.infoLabel.frame = loadingMoreViewFrame;
    
    [self refreshData];
}

-(void)viewWillAppear:(BOOL)animated
{
    
}


- (void)refreshData {
    ProgressLoading;
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(getDetailOK:) andFailedSelector:@selector(getDetailFailed:)];
    if (_topic_id) {
        [[WMTopicService sharedWMTopicService] getTopicDetail:rd withTopicID:_topic_id];
    }else if (_topic) {
        [[WMTopicService sharedWMTopicService] getTopicDetail:rd withTopicID:_topic.mid];
    }
    
}

- (void)getDetailOK:(NKRequest *)request {
    //ProgressHide;
    self.showTopic = [request.results lastObject];
    [self addHeaderView];
    [self getComments];
}

-(void)getComments
{
    NKRequestDelegate *rd = [NKRequestDelegate refreshRequestDelegateWithTarget:self];
    [[WMTopicService sharedWMTopicService] getTopicCommentList:showTopic.mid offset:0 size:DefaultOneRequestSize order_by:orderBy andRequestDelegate:rd];
}

-(void)getMoreData
{
    ProgressLoading;
    NKRequestDelegate *rd = [NKRequestDelegate getMoreRequestDelegateWithTarget:self];
    [[WMTopicService sharedWMTopicService] getTopicCommentList:showTopic.mid offset:[self.dataSource count] size:DefaultOneRequestSize order_by:orderBy andRequestDelegate:rd];
}

-(void)getMoreDataOK:(NKRequest *)request
{
    [super getMoreDataOK:request];
    ProgressHide;
}

-(void)getMoreDataFailed:(NKRequest *)request
{
    [super getMoreDataFailed:request];
    ProgressErrorDefault;
}

- (void)getDetailFailed:(NKRequest *)request {
    ProgressErrorDefault;
}

-(void)refreshDataOK:(NKRequest *)request
{
    [super refreshDataOK:request];
    ProgressHide;
}

-(void)refreshDataFailed:(NKRequest *)request
{
    [super refreshDataFailed:request];
    ProgressErrorDefault
    
}

-(void)addHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    CGFloat totalHeight = 0;
    CGFloat height = 0;
    height = [showTopic.title sizeWithFont:[UIFont boldSystemFontOfSize:15] constrainedToSize:CGSizeMake(294, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height;
    WMCustomLabel *titleLab = [[WMCustomLabel alloc] initWithFrame:CGRectMake(13, 15, 297, height) font:[UIFont boldSystemFontOfSize:15] textColor:[UIColor colorWithHexString:@"#59493F"]] ;
    titleLab.numberOfLines = 0;
    titleLab.text = showTopic.title;
    [headerView addSubview:titleLab];
    totalHeight = totalHeight + 15+height;
    totalHeight += 8;
    WMCustomLabel *fromLabel = [[WMCustomLabel alloc] initWithFrame:CGRectMake(13, totalHeight, 297, 14) font:[UIFont systemFontOfSize:12] textColor:[UIColor colorWithHexString:@"#EB6877"]];
    fromLabel.text = [NSString stringWithFormat:@"来自 %@",showTopic.sender.name];
    [headerView addSubview:fromLabel];
    
    totalHeight += 12+8;
    for (int i=0; i<[showTopic.content count]; i++) {
        if (i>0) {
            totalHeight += 10;
        }
        WMMTopicCotent *content = [showTopic.content objectAtIndex:i];
        UIView *containView = [[UIView alloc] initWithFrame:CGRectMake(0, totalHeight, 320, [WMTopicContentView heightForContent:content supportEmojo:NO])];
        [headerView addSubview:containView];
        WMTopicContentView *topicContentView = [[WMTopicContentView alloc] initWithContent:content supportEmojo:YES];
        [containView addSubview:topicContentView];
        totalHeight += [WMTopicContentView heightForContent:content supportEmojo:YES];
        
    }
    
    totalHeight += 15;
    
    if (showTopic.audioURLString) {
        totalHeight += 23.0f;
        NSURL *URL = [NSURL URLWithString:showTopic.audioURLString];
        int seconds = [showTopic.audioSecond intValue];
        
        WMAudioPlayer *player = [[WMAudioPlayer alloc] initWithURL:URL length:seconds];
        
        CGRect frame = player.frame;
        frame.origin = CGPointMake(13.0f, totalHeight - 33.0f);
        player.frame = frame;
        
        [headerView addSubview:player];
    }
    
    WMCustomLabel *dateLabel = [[WMCustomLabel alloc] initWithFrame:CGRectMake(13, totalHeight, 150, 12) font:[UIFont systemFontOfSize:12] textColor:[UIColor colorWithHexString:@"#A6937C"]];
    dateLabel.text = [NKDateUtil intervalSinceNowWithDateDetail:showTopic.createTime];
    [headerView addSubview:dateLabel];
    
    CGFloat dateWidth = [dateLabel.text sizeWithFont:[UIFont systemFontOfSize:12] forWidth:150 lineBreakMode:NSLineBreakByCharWrapping].width;
    
    // Baobao {{{
    
    UIButton *baobao = [[UIButton alloc] initWithFrame:CGRectMake(dateWidth+20, totalHeight - 7.0f, 70.5f, 25.0f)];
    
    if ([self.showTopic.prised boolValue]) {
        [baobao setBackgroundImage:[UIImage imageNamed:@"baobao-highlight"] forState:UIControlStateNormal];
        [baobao setBackgroundImage:[UIImage imageNamed:@"baobao-highlight"] forState:UIControlStateHighlighted];
        [baobao setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [baobao setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    } else {
        [baobao setBackgroundImage:[UIImage imageNamed:@"baobao-normal"] forState:UIControlStateNormal];
        [baobao setBackgroundImage:[UIImage imageNamed:@"baobao-normal"] forState:UIControlStateHighlighted];
        [baobao setTitleColor:[UIColor colorWithHexString:@"#A6937C"] forState:UIControlStateNormal];
        [baobao setTitleColor:[UIColor colorWithHexString:@"#A6937C"] forState:UIControlStateHighlighted];
    }
    
    [baobao.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [baobao setTitle:[NSString stringWithFormat:@"      %d", [self.showTopic.prise intValue]] forState:UIControlStateNormal];
    
    [baobao addTarget:self action:@selector(baobao:) forControlEvents:UIControlEventTouchUpInside];
    
    [headerView addSubview:baobao];
    
    // }}}
    
    CGFloat width = [[showTopic.comment_count stringValue] sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(41, 12) lineBreakMode:NSLineBreakByCharWrapping].width;
    
    UIImageView *commentIcon = [[UIImageView alloc] initWithFrame:CGRectMake(310-width-16, totalHeight, 10, 10)];
    commentIcon.image = [UIImage imageNamed:@"man_comment_icon"];
    [headerView addSubview:commentIcon];
    
    WMCustomLabel *commentNumLabel = [[WMCustomLabel alloc] initWithFrame:CGRectMake(270, totalHeight, 41, 12) font:[UIFont systemFontOfSize:12] textColor:[UIColor colorWithHexString:@"#A6937C"]] ;
    commentNumLabel.textAlignment = NSTextAlignmentRight;
    commentNumLabel.text = [showTopic.comment_count stringValue];
    [headerView addSubview:commentNumLabel];
    
    totalHeight +=27;
    
    UIImageView *sepLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, totalHeight-1, 320, 1)];
    sepLine.backgroundColor = [UIColor colorWithHexString:@"#e9ddca"];
    [headerView addSubview:sepLine];
    
    CGRect frame = headerView.frame;
    frame.size.height = totalHeight;
    headerView.frame = frame;
    
    
    // Recieve the tap action {{{
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLZMenu)];
    [headerView addGestureRecognizer:tapGesture];
    
    // }}}
    
    
    self.showTableView.tableHeaderView = headerView;
    
}

- (void)baobao:(id)sender {
    UIButton *baobao = (UIButton *)sender;
    
    if ([self.showTopic.prised boolValue]) {
        self.showTopic.prised = @(NO);
        
        [baobao setBackgroundImage:[UIImage imageNamed:@"baobao-normal"] forState:UIControlStateNormal];
        [baobao setBackgroundImage:[UIImage imageNamed:@"baobao-normal"] forState:UIControlStateHighlighted];
        [baobao setTitleColor:[UIColor colorWithHexString:@"#A6937C"] forState:UIControlStateNormal];
        [baobao setTitleColor:[UIColor colorWithHexString:@"#A6937C"] forState:UIControlStateHighlighted];
        
        self.showTopic.prise = @([self.showTopic.prise intValue] - 1);
    } else {
        self.showTopic.prised = @(YES);
        [baobao setBackgroundImage:[UIImage imageNamed:@"baobao-highlight"] forState:UIControlStateNormal];
        [baobao setBackgroundImage:[UIImage imageNamed:@"baobao-highlight"] forState:UIControlStateHighlighted];
        [baobao setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [baobao setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        self.showTopic.prise = @([self.showTopic.prise intValue] + 1);
    }
    
    [baobao setTitle:[NSString stringWithFormat:@"      %d", [self.showTopic.prise intValue]] forState:UIControlStateNormal];
    
    [self toggleBaobao];
}

- (void)toggleBaobao {
    NSString *topicID = self.showTopic.mid;
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(baobaoOK:) andFailedSelector:@selector(baobaoFailed:)];
    
    [[WMTopicService sharedWMTopicService] toggleBaobaoWithID:topicID andRequestDelegate:rd];
}

- (void)baobaoOK:(NKRequest *)request {
    NSLog(@">>>>:%@",request.originDic);
    // TODO
}

- (void)baobaoFailed:(NKRequest *)request {
    // TODO
}

- (void)showLZMenu {
    UIActionSheet *topicShet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报" otherButtonTitles:@"加她为闺蜜",@"回复", nil];
    topicShet.tag = LZ_ACTION_SHEET;
    [topicShet showInView:NKNC.view];
}

#pragma mark TableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [WMDiscussCommentCell cellHeightForObject:[self.dataSource objectAtIndex:indexPath.row]];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"WMMTopicListCellIdentifier";
    
    WMDiscussCommentCell *cell = (WMDiscussCommentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[WMDiscussCommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [cell setCurrentIndex:indexPath.row];
    cell.delegate = self;
    if (self.showTopic) {
        [cell setOrderNew:[orderBy isEqualToString:@"DESC"]?YES:NO];
        [cell setCommentCount:[self.showTopic.comment_count integerValue]];
    }
    
    WMMTopicComment *topicComment = [self.dataSource objectAtIndex:indexPath.row];
    [cell showForObject:topicComment];
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WMMTopicComment *topicComment = [self.dataSource objectAtIndex:indexPath.row];
    reportCommentId = topicComment.mid;
    UIActionSheet *topicShet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报" otherButtonTitles:@"加她为闺蜜",@"回复", nil];
    topicShet.tag = indexPath.row;
    [topicShet showInView:NKNC.view];
}

-(void)replyTopic:(int)index
{
    NSInteger row = index;
    WMMTopicComment *topicComment = [self.dataSource objectAtIndex:index];
    
    WMReplyTopicViewController *vc = [[WMReplyTopicViewController alloc] init];
    vc.model = topicComment;
    vc.userInfo = @{@"floor": @(row + 1), @"topic": showTopic};
    vc.delegate = self;
    [NKNC pushViewController:vc animated:YES];
}


-(void)replyTopicDidSuccess
{
    [self refreshData];
}

-(void)reply:(id)sender
{
    WMReplyTopicViewController *vc = [[WMReplyTopicViewController alloc] init];
    vc.model = showTopic;
    vc.delegate = self;
    [NKNC pushViewController:vc animated:YES];
}

-(void)rightButtonClick:(id)sender
{
    NSInteger senderID = [showTopic.sender.mid integerValue];
    NSInteger meID = [[[WMMUser me] mid] integerValue];
    NSString *destructiveString = ABS(senderID) == ABS(meID) ? @"删除" : @"举报";
    
    UIActionSheet *action;
    if ([showTopic.fav boolValue]) {
        action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:destructiveString otherButtonTitles:@"新回复在前面",@"旧回复在前面",@"取消收藏",nil];
    }else {
        action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:destructiveString otherButtonTitles:@"新回复在前面",@"旧回复在前面",@"收藏",nil];
    }
    
    action.tag = MORE_SHEET;
    [action showInView:self.contentView];
}

-(void)addFav:(NSString *)topic_id
{
    ProgressWith(@"正在收藏");
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(addFavOK:) andFailedSelector:@selector(addFavFailed:)];
    [[WMTopicService sharedWMTopicService] addTopicFavWithID:topic_id andRequestDelegate:rd];
}

-(void)addFavOK:(NKRequest *)request
{
    showTopic.fav = [NSNumber numberWithBool:YES];
    ProgressSuccess(@"收藏成功");
}

-(void)addFavFailed:(NKRequest *)request
{
    ProgressErrorDefault;
}

-(void)delFav:(NSString *)topic_id
{
    ProgressWith(@"正在取消收藏");
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(delFavOK:) andFailedSelector:@selector(delFavFailed:)];
    [[WMTopicService sharedWMTopicService] delTopicFavWithID:topic_id andRequestDelegate:rd];
}

-(void)delFavOK:(NKRequest *)request
{
    showTopic.fav = [NSNumber numberWithBool:NO];
    ProgressSuccess(@"取消收藏成功");
}

-(void)delFavFailed:(NKRequest *)request
{
    ProgressErrorDefault;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == MORE_SHEET) {
        NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        
        if ([buttonTitle isEqualToString:@"举报"]) {
            [self showReportActionSheet];
        } else if ([buttonTitle isEqualToString:@"删除"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = kWMDiscussDetailViewTagConfirmDelete;
            [alert show];
        }else if (buttonIndex == 1) {
            NSLog(@"新回复在前面");
            orderBy = @"DESC";
            [self getComments];
        }else if (buttonIndex == 2){
            NSLog(@"旧回复在前面");
            orderBy = @"ASC";
            [self getComments];
        }else if (buttonIndex ==3) {
            if ([showTopic.fav boolValue]) {
                [self delFav:showTopic.mid];
            }else {
                [self addFav:showTopic.mid];
            }
        }
    }else if (actionSheet.tag == REPORT_SHEET || actionSheet.tag == REPORT_COMMENT_SHEET) {
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
                reportType = @"反感";
            }
                break;
                
            case 3: {
                reportType = @"人妖男人";
            }
                break;
                
            default:
                return;
        }
        
        ProgressWith(@"举报中");
        
        if (actionSheet.tag == REPORT_SHEET) {
            if (_topic_id) {
                [[WMTopicService sharedWMTopicService] reportTopic:_topic_id content:reportType andRequestDelegate:rd];
            }else {
                [[WMTopicService sharedWMTopicService] reportTopic:_topic.mid content:reportType andRequestDelegate:rd];
            }
        }else if (actionSheet.tag == REPORT_COMMENT_SHEET) {
            if (reportCommentId) {
                [[WMTopicService sharedWMTopicService] reportTopicComment:reportCommentId content:reportType andRequestDelegate:rd];
            }
        }
    } else if (actionSheet.tag == LZ_ACTION_SHEET) {
        if (buttonIndex == 0) {
            UIActionSheet *sheet = [[UIActionSheet alloc]
                                    initWithTitle:nil
                                    delegate:self
                                    cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                    otherButtonTitles:@"广告", @"色情", @"反感",@"人妖男人", nil];
            sheet.tag = REPORT_SHEET;
            [sheet showInView:self.view];
        }else if (buttonIndex == 1) {
            ProgressWith(@"正在发送好友请求");
            float user_id = fabs([showTopic.sender.mid doubleValue]);
            NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(addFriendOK:) andFailedSelector:@selector(addFriendFailed:)];
            [[WMUserService sharedWMUserService] addFriend:[NSString stringWithFormat:@"%f",user_id] from:@"topic" andRequestDelegate:rd];
        }else if (buttonIndex == 2) {
            [self reply:nil];
        }
    } else {
        if (buttonIndex == 0) {
            UIActionSheet *sheet = [[UIActionSheet alloc]
                                    initWithTitle:nil
                                    delegate:self
                                    cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                    otherButtonTitles:@"广告", @"色情", @"反感",@"人妖男人", nil];
            sheet.tag = REPORT_COMMENT_SHEET;
            [sheet showInView:self.view];
        }else if (buttonIndex == 1) {
            ProgressWith(@"正在发送好友请求");
            WMMTopicComment *topicComment = [self.dataSource objectAtIndex:actionSheet.tag];
            float user_id = fabs([topicComment.sender.mid doubleValue]);
            NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(addFriendOK:) andFailedSelector:@selector(addFriendFailed:)];
            [[WMUserService sharedWMUserService] addFriend:[NSString stringWithFormat:@"%f",user_id] from:@"topic" andRequestDelegate:rd];
        }else if (buttonIndex == 2) {
            [self replyTopic:actionSheet.tag];
        }
    }
}

-(void)addFriendOK:(NKRequest*)request
{
    ProgressSuccess(@"添加成功，等待对方接受");
}

-(void)addFriendFailed:(NKRequest*)request
{
    ProgressErrorDefault;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kWMDiscussDetailViewTagConfirmDelete) {
        if (buttonIndex == 1) {
            [self deleteCurrentTopic];
        }
    }
}

- (void)reportOK:(NKRequest *)request {
    ProgressSuccess(@"举报成功");
}

- (void)reportFailed:(NKRequest *)request {
    ProgressErrorDefault;
}

- (void)deleteCurrentTopic {
    ProgressWith(@"删除中");
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(deleteOK:) andFailedSelector:@selector(deleteFailed:)];
    NSString *mid = [showTopic.mid description];
    [[WMTopicService sharedWMTopicService] deleteTopic:mid andRequestDelegate:rd];
}

- (void)deleteOK:(NKRequest *)request {
    [NKNC popViewControllerAnimated:YES];
    ProgressSuccess(@"删除成功");
}

- (void)deleteFailed:(NKRequest *)request {
    ProgressErrorDefault;
}

- (void)showReportActionSheet
{
    UIActionSheet *sheet = [[UIActionSheet alloc]
                            initWithTitle:nil
                            delegate:self
                            cancelButtonTitle:@"取消"
                            destructiveButtonTitle:nil
                            otherButtonTitles:@"广告", @"色情", @"反感",@"人妖男人", nil];
    sheet.tag = REPORT_SHEET;
    [sheet showInView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
