//
//  WMManDadenDetalViewController.m
//  WEIMI
//
//  Created by steve on 13-5-23.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMManDadenDetalViewController.h"
#import "WMFeedCell.h"
#import "WMPostViewController.h"
#import "WMFeedDetailViewController.h"
#import "WMAddRateViewController.h"
#import "WMManUserCell.h"
#import "WMGirlToManViewController.h"
#import "WMAddBaoliaoViewController.h"

#import "WMManPhotosViewController.h"
#import "WMAddTagViewController.h"

#import "WMNotificationCenter.h"

@interface WMManDadenDetalViewController ()
{
     WMMFeed *reportFeed;
}
@end

@implementation WMManDadenDetalViewController

#define SHOW_REPORT_SHEET 13062401
#define REPORT_SHEET 13062402

#define SHARETITLE @"姑娘们对 XXX 的点评，八卦 | 薇蜜"
#define WEIXINTEXT @"闺蜜姐妹专属私密分享，人物点评社区。男神渣男匿名点评，八卦爆料，男友前男友男同学男同事男上司男明星大百科，让天下没有难懂的男人"
#define WEIBOTEXT @"让天下没有难懂的男人。女生匿名对男友前男友、男明星、男同学、男同事男上司点评打分、八卦爆料的社交应用，这里有让@留几手都无法直视的气场。"
#define SMSTEXT @"薇蜜是专为闺蜜姐妹们设计的手机客户端，还有点评王子渣男功能，下载一个试试吧：http://www.weimi.com/app?from=sms"
#define QQZONETEXT @"今天开始玩薇蜜啦！/转圈 这是专为闺蜜姐妹们设计的手机客户端，还有点评王子渣男功能 /可爱 苹果手机下载：http://www.weimi.com/app?from=qzone"
#define TENCENTTEXT @"今天开始玩薇蜜啦！这是专为闺蜜姐妹们设计的手机客户端，还有点评王子渣男功能。苹果手机下载：http://www.weimi.com/app?from=tqq"
#define RENRENTEXT @"在薇蜜看到了有人对 XXX 的点评…"

-(void)dealloc{
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
    [self addBackButtonWithTitle:self.man.name];
    [self.headBar insertSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_head_back"]] autorelease] atIndex:0];
    [self addHeadShadow];
    
    [self addRightButtonWithTitle:@"+评分"];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@人评分",[self.man.scoreCount stringValue]];

    
    showTableView.frame = CGRectMake(0, 44, 320, NKMainHeight-44);
    showTableView.backgroundColor = [UIColor whiteColor];
    
    [self refreshData];
    ProgressLoading;
    
    
    self.loadingMoreView = [NKLoadingMoreView loadingMoreViewWithStyle:NKLoadingMoreViewStyleZUO];
    loadingMoreView.target = self;
    loadingMoreView.action = @selector(getMoreData);
    [self showFooter:YES];
    
    self.showTableView.backgroundColor = [UIColor colorWithHexString:@"#e1d7c8"];
}

-(void)refreshData
{
    NKRequestDelegate *rd = [NKRequestDelegate refreshRequestDelegateWithTarget:self];
    
    [[WMManService sharedWMManService] getManFeedWithMID:self.man.mid type:@"score" offset:0 size:35 andRequestDelegate:rd];
}

-(void)rightButtonClick:(id)sender
{
    WMAddRateViewController *addRate = [[WMAddRateViewController alloc] init];
    addRate.man = self.man;
    addRate.father = self;
    [NKNC pushViewController:addRate animated:YES];
    [addRate release];
}

-(void)getMoreData{
    
    
    [self showFooter:YES];
    gettingMoreData = YES;
    
    NKRequestDelegate *rd = [NKRequestDelegate getMoreRequestDelegateWithTarget:self];
    [[WMManService sharedWMManService] getManFeedWithMID:self.man.mid type:@"score" offset:[self.dataSource count] size:35 andRequestDelegate:rd];
    
}

-(void)commentFinished
{
    [self.dataSource removeAllObjects];
    [self refreshData];
     [_delegate shouldRefreshData];
}

-(void)deleteFeed
{
    [self.dataSource removeAllObjects];
    [self refreshData];
    [_delegate shouldRefreshData];
}

#pragma mark TableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [WMManFeedCell cellHeightForObject:[self.dataSource objectAtIndex:indexPath.row]];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"WMManFeedCellIdentifier";
    
    WMManFeedCell *cell = (WMManFeedCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[WMManFeedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.delegate = self;
    }
    WMMFeed *feed = [self.dataSource objectAtIndex:indexPath.row];
    cell.index = indexPath.row;
    [cell showForObject:feed];
    
    
    return cell;
}

-(void)setRate:(int)index feed:(WMMFeed *)feed
{
    [self.dataSource replaceObjectAtIndex:index withObject:feed];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WMMFeed *feed = [self.dataSource objectAtIndex:indexPath.row];
    if ([feed.purview isEqualToString:@"open"] || [feed.sender.relation isEqualToString:@"自己"]) {
        WMBaoliaoXiangqingViewController *baoliaoXiangqing = [[[WMBaoliaoXiangqingViewController alloc] init] autorelease];
        baoliaoXiangqing.man = self.man;
        baoliaoXiangqing.feed = feed;
        baoliaoXiangqing.delegate = self;
        baoliaoXiangqing.titleString = @"评分详情";
        [NKNC pushViewController:baoliaoXiangqing animated:YES];
    }else {
        ProgressFailedWith(@"只有她的姐妹闺蜜才能看哦~");
    }
    
    
}

-(void)showMoreView:(WMMFeed *)feed
{
    reportFeed = feed;
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报" otherButtonTitles:@"分享到微信/QQ", nil];
    sheet.tag = SHOW_REPORT_SHEET;
    [sheet showInView:self.view];
    [sheet release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == SHOW_REPORT_SHEET) {
        if (buttonIndex == 0) {
            [self showReportActionSheet];
        } else if (buttonIndex == 1) {
            [self share];
        }
    }else if (actionSheet.tag == REPORT_SHEET) {
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
                reportType = @"政治";
            }
                break;
                
            case 3: {
                reportType = @"反感";
            }
                break;
                
            default:
                return;
        }
        
        ProgressWith(@"举报中");
        
        [[WMFeedService sharedWMFeedService] reportFeedWithFID:reportFeed.mid andContent:reportType andRequestDelegate:rd];
    }
}

- (void)share {
    NSString *titleString = [NSString stringWithFormat:@"关于 %@…", self.man.name];
    NSString *descStrings = nil;
    
    if ([reportFeed.type isEqualToString:WMFeedTypeDafen]) {
        NSMutableArray *scoreArr = [NSMutableArray array];
        
        for (id obj in reportFeed.score[@"scores"]) {
            [scoreArr addObject:[NSString stringWithFormat:@"%@%@分", obj[@"name"], obj[@"score"]]];
        }
        
        NSString *scoreString = [scoreArr componentsJoinedByString:@"，"];
        
        descStrings = [NSString stringWithFormat:@"%@ 给 %@ %@...", reportFeed.sender.name, self.man.name, scoreString];
    } else {
        descStrings = [NSString stringWithFormat:@"%@说：%@", reportFeed.sender.name, reportFeed.content];
    }
    
    descStrings = [descStrings stringByAppendingString:@" | 点击可匿名评论"];
    
    NSData *imageData = nil;
    NSString *imageURL = self.man.avatarBigPath;
    
    WMMAttachment *attach = [reportFeed.attachments lastObject];
    
    if (attach != nil) {
        if (attach.picture != nil) {
            imageData = UIImageJPEGRepresentation(attach.picture, 1.0f);
        } else {
            imageURL = attach.pictureURL;
        }
    }
    
    if (imageData == nil) {
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    }
    
    id<ISSContent> publishContent = [ShareSDK content:descStrings
                                       defaultContent:@""
                                                image:[ShareSDK imageWithData:imageData fileName:@"avatar.jpg" mimeType:@"image/jpeg"]
                                                title:@"薇蜜"
                                                  url:@"http://www.weimi.com/app?from=weibo"
                                          description:@"薇蜜"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //定制微信好友信息
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:descStrings
                                           title:titleString
                                             url:[NSString stringWithFormat:@"http://www.weimi.com/man/%@/review/%@?from=weixinmsg",self.man.mid, reportFeed.mid]
                                           image:[ShareSDK imageWithUrl:self.man.avatarPath]
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    //定制微信朋友圈信息
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                          content:descStrings
                                            title:titleString
                                              url:[NSString stringWithFormat:@"http://www.weimi.com/man/%@/review/%@?from=moment",self.man.mid, reportFeed.mid]
                                            image:[ShareSDK imageWithUrl:self.man.avatarPath]
                                     musicFileUrl:@""
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    //定制QQ信息
    [publishContent addQQUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                              content:descStrings
                                title:titleString
                                  url:[NSString stringWithFormat:@"http://www.weimi.com/man/%@/review/%@?from=qq",self.man.mid, reportFeed.mid]
                                image:[ShareSDK imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.man.avatarBigPath]] fileName:@"avatar.jpg" mimeType:@"image/jpeg"]];
    
    [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"姑娘们对 %@ 的点评打分，八卦>>>http://http://www.weimi.com/man/%@?from=sms 【薇蜜】",self.man.name,self.man.mid]];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPhoneContainerWithViewController:self];
    
    
    
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"薇蜜分享"
                                                              oneKeyShareList:[ShareSDK getShareListWithType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeQQ, nil]
                                                               qqButtonHidden:YES
                                                        wxSessionButtonHidden:YES
                                                       wxTimelineButtonHidden:YES
                                                         showKeyboardOnAppear:NO
                                                            shareViewDelegate:nil
                                                          friendsViewDelegate:nil
                                                        picViewerViewDelegate:nil];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:[ShareSDK getShareListWithType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeQQ, nil]
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:shareOptions
                            result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}

- (void)reportOK:(NKRequest *)request {
    ProgressSuccess(@"举报成功");
}

- (void)reportFailed:(NKRequest *)request {
    
}

-(void)showReportActionSheet
{
    UIActionSheet *sheet = [[UIActionSheet alloc]
                            initWithTitle:nil
                            delegate:self
                            cancelButtonTitle:@"取消"
                            destructiveButtonTitle:nil
                            otherButtonTitles:@"广告", @"色情", @"政治", @"反感", nil];
    sheet.tag = REPORT_SHEET;
    [sheet showInView:self.view];
    [sheet release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)leftButtonClick:(id)sender
{
    [self goBack:sender];
}
@end
