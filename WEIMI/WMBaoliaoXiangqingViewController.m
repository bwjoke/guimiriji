//
//  WMBaoliaoXiangqingViewController.m
//  WEIMI
//
//  Created by King on 4/12/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMBaoliaoXiangqingViewController.h"
#import "ZUOCommentCell.h"
#import "WMManUserCell.h"
#import "WMFeedCell.h"
#import "WMManDetailBackToRootViewController.h"
#import "WMAudioPlayer.h"

@interface WMBaoliaoXiangqingViewController ()
{
    NKMUser *replyUser;
    int deleteIndex;
    WMAudioPlayer *_playerButton;
    NKKVOImageView *picture;
}
@end

@implementation WMBaoliaoXiangqingViewController

#define FEEDDELETETAG 2013060301
#define COMMENTDELETETAG 2013060302

enum {
    WMBaoliaoXiangqingViewTypeDefault,
    WMBaoliaoXiangqingViewTypeActionSheet,
    WMBaoliaoXiangqingViewTypeReport,
    WMBaoliaoXiangqingViewTypeActionSheetSelf,
};

-(void)dealloc{
    
    [_feed release];
    [_man release];
    [_manUser release];
    [_playerButton destroy];
    picture.target = nil;
    [super dealloc];
}

+(id)feedDetailWithFeed:(WMMFeed*)feed
{
    WMBaoliaoXiangqingViewController *baoliaoxiangqingViewController = [[WMBaoliaoXiangqingViewController alloc] init];
    baoliaoxiangqingViewController.feed = feed;
    [NKNC pushViewController:baoliaoxiangqingViewController animated:YES];
    return [baoliaoxiangqingViewController autorelease];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)addTableHeader{
    
    CGFloat totalHeight = 0;
    
    UIView *tableViewHeader = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    
    
    
//    WMManUserCell *muc = [[[WMManUserCell alloc] initWithFrame:CGRectMake(0, 0, 320, [WMManUserCell cellHeightForObject:nil])] autorelease];
//    [tableViewHeader addSubview:muc];
//    [muc.bottomLine removeFromSuperview];
//    [muc showForObject:self.manUser];
//    muc.accessoryView = nil;
    
    UIView *manUserView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 56)] autorelease];
    [tableViewHeader addSubview:manUserView];
    
    NKKVOImageView *avatar = [[NKKVOImageView alloc] initWithFrame:CGRectMake(18, totalHeight+10, 34, 34)];
    [manUserView addSubview:avatar];
    [avatar release];
    [avatar bindValueOfModel:self.man forKeyPath:@"avatar"];
    
    [avatar addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedAvatar:)] autorelease]];
    avatar.userInteractionEnabled = YES;
    
    UIImageView *arrowView = [[[UIImageView alloc] initWithFrame:CGRectMake(60, 20, 9, 15)] autorelease];
    arrowView.image = [UIImage imageNamed:@"arrow_left"];
    [manUserView addSubview:arrowView];
    
    NKKVOImageView *userAvatar = [[NKKVOImageView alloc] initWithFrame:CGRectMake(80, totalHeight+10, 34, 34)];
    userAvatar.layer.cornerRadius = 4.0;
    userAvatar.layer.masksToBounds = YES;
    [manUserView addSubview:userAvatar];
    [userAvatar release];
    [userAvatar bindValueOfModel:_feed.sender forKeyPath:@"avatar"];
    
    UILabel *fromLabel = [[[UILabel alloc] initWithFrame:CGRectMake(124, 11, 50, 13)] autorelease];
    fromLabel.backgroundColor = [UIColor clearColor];
    fromLabel.font = [UIFont systemFontOfSize:11];
    fromLabel.text = @"来自";
    fromLabel.textColor = [UIColor colorWithHexString:@"#A4988E"];
    [manUserView addSubview:fromLabel];
    
    UIImageView *relationIcon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"relation_self"]] autorelease];
    CGRect frame = relationIcon.frame;
    if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"sysFunction"] valueForKey:@"tab"] boolValue]) {
        frame.origin.x = 150;
    }else {
        frame.origin.x = 88;
    }
    
    frame.origin.y = 10;
    relationIcon.frame = frame;
    [manUserView addSubview:relationIcon];
    
    if ([_feed.sender.relation isEqualToString:@"自己"]) {
        relationIcon.image = [UIImage imageNamed:@"relation_self"];
    }
    else if ([_feed.sender.relation isEqualToString:@"闺蜜"]) {
        relationIcon.image = [UIImage imageNamed:@"relation_guimi"];
    }
    else if ([_feed.sender.relation isEqualToString:@"陌生人"]) {
        relationIcon.image = [UIImage imageNamed:@"relation_moshen"];
    }
    
    UILabel *nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(124, 25, 140, 20)] autorelease];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.font = [UIFont boldSystemFontOfSize:12];
    nameLabel.text = _feed.sender.name;
    nameLabel.textColor = [UIColor colorWithHexString:@"#A4988E"];
    [manUserView addSubview:nameLabel];
    
    if (![[[[NSUserDefaults standardUserDefaults] valueForKey:@"sysFunction"] valueForKey:@"tab"] boolValue])
    {
        [arrowView removeFromSuperview];
        [avatar removeFromSuperview];
        CGRect frame = userAvatar.frame;
        frame.origin.x = 18;
        userAvatar.frame = frame;
        frame = fromLabel.frame;
        frame.origin.x -= 62;
        fromLabel.frame = frame;
        frame = nameLabel.frame;
        frame.origin.x -= 62;
        nameLabel.frame = frame;
    }
    
    if ([_feed.type isEqualToString:WMFeedTypeDafen] && fabs([_feed.sender.mid floatValue]) == [[[WMMUser me] mid] floatValue] ) {
        [self addRightButtonWithFontTitle:@"● ● ●"];
    }
    
//    if ([_feed.sender.relation isEqualToString:NKRelationFriend]) {
//        UILabel *relationLabel = [[[UILabel alloc] initWithFrame:CGRectMake(270, 20, 35, 16)] autorelease];
//        [relationLabel setBackgroundColor:[UIColor colorWithHexString:@"#ed8387"]];
//        [relationLabel setText:@"闺蜜"];
//        relationLabel.textAlignment = UITextAlignmentCenter;
//        relationLabel.font = [UIFont systemFontOfSize:10];
//        relationLabel.textColor = [UIColor whiteColor];
//        relationLabel.layer.cornerRadius = 4.0;
//        [manUserView addSubview:relationLabel];
//    }
    
    UIImageView *shadow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_tableviewheader_shadow"]] autorelease];
    [manUserView addSubview:shadow];
    CGRect shadowFrame = shadow.frame;
    shadowFrame.origin.y = manUserView.frame.size.height;
    shadow.frame = shadowFrame;
    
    totalHeight += manUserView.frame.size.height;
    
    totalHeight += 11;
    
    NSString *month,*day,*time;
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    
    [dateFormatter setDateFormat:@"M月"];
    month = [dateFormatter stringFromDate:_feed.createTime];
    
    [dateFormatter setDateFormat:@"dd日"];
    day = [dateFormatter stringFromDate:_feed.createTime];
    
    [dateFormatter setDateFormat:@"HH:mm"];
    time = [dateFormatter stringFromDate:_feed.createTime];
    
    UILabel *dateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(130, 11, 180, 11)] autorelease];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textColor = [UIColor colorWithHexString:@"#A4988E"];
    dateLabel.font = [UIFont systemFontOfSize:9];
    dateLabel.textAlignment = UITextAlignmentRight;
    dateLabel.text = [NSString stringWithFormat:@"%@%@ %@",month,day,time];
    [tableViewHeader addSubview:dateLabel];
    
//    UILabel *privateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(320-15, totalHeight, 100, 320-15)] autorelease];
//    privateLabel.backgroundColor = [UIColor clearColor];
//    privateLabel.font = [UIFont systemFontOfSize:9];
//    privateLabel.textColor = [UIColor colorWithHexString:@"#A4988E"];
//    privateLabel.textAlignment = UITextAlignmentRight;
//    [tableViewHeader addSubview:privateLabel];
//    
//    if ([_feed.purview isEqualToString:@""]) {
//        privateLabel.text = @"对你可见";
//    }
    
//    totalHeight+=20;
//    
//    UIView *dateLine = [[[UIView alloc] initWithFrame:CGRectMake(0, totalHeight-1, 320, 1)] autorelease];
//    [tableViewHeader addSubview:dateLine];
//    dateLine.backgroundColor = [UIColor colorWithHexString:@"#F1ECE4"];
    
    
    //totalHeight+=15;
    
    if ([_feed.type isEqualToString:WMFeedTypeDafen]) {
        NSArray *scores = [_feed.score objectOrNilForKey:@"scores"];
        int line = [scores count]/6 + 1;
        
        self.scoreView = [[[UIView alloc] initWithFrame:CGRectMake(0, totalHeight-15, 320,54*line + 11 + 5)] autorelease];
        _scoreView.backgroundColor = [UIColor colorWithHexString:@"#F1ECE4"];
        
        [tableViewHeader addSubview:_scoreView];
        
        if (![scores isKindOfClass:[NSArray class]]) {
            return;
        }
        
        CGFloat startX = 15;
        CGFloat startY = 11;;
        UIImageView *scoreCard = nil;
        UILabel *scoreLabel = nil;
        UILabel *scoreName = nil;
        NSDictionary *scoreDic = nil;
        
        for (int i=0; i<[scores count]; i++) {
            
            scoreDic = scores[i];
            
            scoreCard = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"score_card"]] autorelease];
            CGRect scoreCardFrame = scoreCard.frame;
            scoreCardFrame.origin.x = startX;
            scoreCardFrame.origin.y =  startY;
            scoreCard.frame = scoreCardFrame;
            [_scoreView addSubview:scoreCard];
            
            scoreLabel = [[[UILabel alloc] initWithFrame:scoreCard.bounds] autorelease];
            [scoreCard addSubview:scoreLabel];
            scoreLabel.textColor = [UIColor colorWithHexString:@"#ED8387"];
            scoreLabel.textAlignment = NSTextAlignmentCenter;
            if ([[scoreDic objectOrNilForKey:@"score"] floatValue]<0) {
                scoreLabel.text = @"负分";
            }else {
                scoreLabel.text = [NSString stringWithFormat:@"%.0f", [[scoreDic objectOrNilForKey:@"score"] floatValue]];  
            }
            scoreLabel.backgroundColor = [UIColor clearColor];
            scoreLabel.font = [UIFont boldSystemFontOfSize:18];
            
            
            scoreName = [[[UILabel alloc] initWithFrame:CGRectMake(0, scoreCardFrame.size.height, scoreCardFrame.size.width, 22)] autorelease];
            [scoreCard addSubview:scoreName];
            scoreName.textColor = [UIColor colorWithHexString:@"#A6937C"];
            scoreName.textAlignment = NSTextAlignmentCenter;
            scoreName.text = [scoreDic objectOrNilForKey:@"name"];
            scoreName.backgroundColor = [UIColor clearColor];
            scoreName.font = [UIFont boldSystemFontOfSize:10];
            
            
            
            startX += 50;
            if (startX>300) {
                startX = 15;
                startY += 54;
            }
            
        }
        if ([scores count]>6 && [scores count]<12) {
            totalHeight += 108;
        }else if ([scores count]>12){
            totalHeight += 164;
        }else {
            totalHeight += 56;
        }
        
            
    }else {
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, totalHeight+2, 290, [_feed.content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(290, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height)];
        [tableViewHeader addSubview:contentLabel];
        [contentLabel release];
        contentLabel.text = _feed.content;
        contentLabel.numberOfLines = 0;
        contentLabel.textColor = [UIColor colorWithHexString:@"#A4988E"];
        contentLabel.font = [UIFont systemFontOfSize:14];
        
        totalHeight += contentLabel.frame.size.height;
        
        //UIButton *deleteButton;
        
        if ([_feed.attachments lastObject]) {
            
            UIImageView *pictureBack = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feed_cell_picture"]] autorelease];
            [tableViewHeader addSubview:pictureBack];
            pictureBack.frame = CGRectMake(11, totalHeight+9.5, pictureBack.frame.size.width, pictureBack.frame.size.height);
            
            picture = [[NKKVOImageView alloc] initWithFrame:CGRectMake(18, totalHeight+16, 75, 75)];
            [tableViewHeader addSubview:picture];
            [picture release];
            picture.target = self;
            picture.singleTapped = @selector(pictureTapped:);
            [picture bindValueOfModel:[_feed.attachments lastObject] forKeyPath:@"picture"];
            
            totalHeight += 95;
            
//            deleteButton = [[[UIButton alloc] initWithFrame:CGRectMake(289, totalHeight-20, 16, 20)] autorelease];
            totalHeight += 15;
        }else {
//            deleteButton = [[[UIButton alloc] initWithFrame:CGRectMake(289, totalHeight, 16, 20)] autorelease];
            totalHeight += 15+20;
        }
        
//        [deleteButton setBackgroundImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
//        [deleteButton addTarget:self action:@selector(deleteFeed) forControlEvents:UIControlEventTouchUpInside];
        
        
        if ([_feed.attachments lastObject]) {
            //totalHeight -= 15;
        }else {
            totalHeight -= 20;
        }
    }
    
    if (_feed.audioURLString) {
        // Audio player button {{{
        
        NSURL *amrURL = [NSURL URLWithString:_feed.audioURLString];
        int length = [_feed.audioSecond intValue];
        
        _playerButton = [[WMAudioPlayer alloc] initWithURL:amrURL length:length];
        
        CGRect frame = _playerButton.frame;
        
        frame.origin = CGPointMake(15.0f, totalHeight-6);
        
        _playerButton.frame = frame;
        
        [tableViewHeader addSubview:_playerButton];
        
        // }}}
        
        totalHeight += 33.0f;
    }
    
    //totalHeight += 15;
    UIView *line = [[[UIView alloc] initWithFrame:CGRectMake(0, totalHeight-1, 320, 1)] autorelease];
    [tableViewHeader addSubview:line];
    line.backgroundColor = [UIColor colorWithHexString:@"#F1ECE4"];
    
    tableViewHeader.frame = CGRectMake(0, 0, 320, totalHeight);
    
    self.showTableView.tableHeaderView = tableViewHeader;

    
}

- (void)tappedAvatar:(id)sender {
    WMManDetailBackToRootViewController *manDetailViewController = [[[WMManDetailBackToRootViewController alloc] init] autorelease];
    manDetailViewController.man = self.man;
    manDetailViewController.shouldGetNotification = YES;
    [NKNC pushViewController:manDetailViewController animated:YES];
}

-(void)rightButtonClick:(id)sender
{
    if (fabs([_feed.sender.mid floatValue]) == [[[WMMUser me] mid] floatValue] )
    {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@"分享到微信/QQ", nil];
        action.tag = WMBaoliaoXiangqingViewTypeActionSheetSelf;
        [action showInView:self.contentView];
    }else {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报" otherButtonTitles:@"分享到微信/QQ", nil];
        action.tag = WMBaoliaoXiangqingViewTypeActionSheet;
        [action showInView:self.contentView];
    }
    
}

- (void)deleteFeed
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要删除这条记录吗？" delegate:self cancelButtonTitle:@"不删除" otherButtonTitles:@"删除", nil];
    [alert show];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == WMBaoliaoXiangqingViewTypeActionSheet) {
        if (buttonIndex == 0) {
            [self showReportActionSheet];
        } else if (buttonIndex == 1) {
            [self share];
        }
    } else if (actionSheet.tag == COMMENTDELETETAG) {
        if (buttonIndex == 0) {
            [self deleteComment];
        }
    } else if (actionSheet.tag == WMBaoliaoXiangqingViewTypeReport) {
        
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
        
        [[WMFeedService sharedWMFeedService] reportFeedWithFID:self.feed.mid andContent:reportType andRequestDelegate:rd];
    }else if (actionSheet.tag == WMBaoliaoXiangqingViewTypeActionSheetSelf) {
        if (buttonIndex == 0) {
            [self deleteFeed];
        } else if(buttonIndex == 1){
            [self share];
        }
    }
}

- (void)share {
    
    NSString *descString = nil;
    NSString *quteString = nil;
    if ([self.feed.type isEqualToString:WMFeedTypeDafen]) {
        NSMutableArray *scoreArr = [NSMutableArray array];
        
        int i=0;
        CGFloat scoreAmount = 0;
        for (id obj in self.feed.score[@"scores"]) {
            [scoreArr addObject:[NSString stringWithFormat:@"%@%@分", obj[@"name"], obj[@"score"]]];
            scoreAmount += [obj[@"score"] integerValue];
            i++;
        }
        if (i>0) {
           quteString = [NSString stringWithFormat:@"有人打了%.1f分",scoreAmount/i];
        }else {
            quteString = [NSString stringWithFormat:@"有人打了0分"];
        }
        
        NSString *scoreString = [scoreArr componentsJoinedByString:@"，"];
        
        descString = [NSString stringWithFormat:@"%@ 给 %@ %@...", self.feed.sender.name, self.man.name, scoreString];
        
    } else {
        descString = [NSString stringWithFormat:@"%@说：%@", self.feed.sender.name, self.feed.content];
        if ([self.feed.content length]>20) {
            quteString = [NSString stringWithFormat:@"「%@」...",[self.feed.content substringWithRange:NSMakeRange(0, 20)]];
        }else {
            quteString = [NSString stringWithFormat:@"「%@」",self.feed.content];
        }
    }
    NSString *titleString = [NSString stringWithFormat:@"关于 %@…%@", self.man.name,quteString];
    
    
    
    descString = [descString stringByAppendingString:@" | 点击可匿名评论"];
    
    NSData *imageData = nil;
    NSString *imageURL = self.man.avatarBigPath;
    
    WMMAttachment *attach = [self.feed.attachments lastObject];
    
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
    
    id<ISSContent> publishContent = [ShareSDK content:descString
                                       defaultContent:@""
                                                image:[ShareSDK imageWithData:imageData fileName:@"avatar.jpg" mimeType:@"image/jpeg"]
                                                title:@"薇蜜"
                                                  url:@"http://www.weimi.com/app?from=weibo"
                                          description:@"薇蜜"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //定制微信好友信息
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:descString
                                           title:titleString
                                             url:[NSString stringWithFormat:@"http://www.weimi.com/man/%@/review/%@?from=weixinmsg",self.man.mid, self.feed.mid]
                                           image:[ShareSDK imageWithData:imageData fileName:@"avatar.jpg" mimeType:@"image/jpeg"]
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    //定制微信朋友圈信息
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                          content:descString
                                            title:titleString
                                              url:[NSString stringWithFormat:@"http://www.weimi.com/man/%@/review/%@?from=moment",self.man.mid, self.feed.mid]
                                            image:[ShareSDK imageWithData:imageData fileName:@"avatar.jpg" mimeType:@"image/jpeg"]
                                     musicFileUrl:@""
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    //定制QQ信息
    [publishContent addQQUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                              content:descString
                                title:titleString
                                  url:[NSString stringWithFormat:@"http://www.weimi.com/man/%@/review/%@?from=qq",self.man.mid, self.feed.mid]
                                image:[ShareSDK imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.man.avatarBigPath]] fileName:@"avatar.jpg" mimeType:@"image/jpeg"]];
    
    [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"姑娘们对 %@ 的点评打分，八卦>>>http://http://www.weimi.com/man/%@?from=sms 【薇蜜】",self.man.name,self.man.mid]];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    //[container setIPhoneContainerWithViewController:self];
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
    ProgressHide;
}

-(void)deleteComment
{
    if ([self.dataSource count]==0) {
        return;
    }
    NKMRecord *message = [self.dataSource objectAtIndex:deleteIndex];
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(deleteFeedCommentOK:) andFailedSelector:@selector(deleteFeedCommentFailed:)];
    [[WMFeedService sharedWMFeedService] deleteFeedCommentWithFID:message.mid andRequestDelegate:rd];
    ProgressLoading;
    
}

-(void)deleteFeedCommentOK:(NKRequest*)request
{
    [self.dataSource removeObjectAtIndex:deleteIndex];
    [self.showTableView reloadData];
    [_delegate deleteFeed];
    ProgressSuccess(@"删除成功");
}

-(void)deleteFeedCommentFailed:(NKRequest*)request
{
    ProgressFailed;
}

- (void)showReportActionSheet
{
    UIActionSheet *sheet = [[UIActionSheet alloc]
                            initWithTitle:nil
                            delegate:self
                            cancelButtonTitle:@"取消"
                            destructiveButtonTitle:nil
                            otherButtonTitles:@"广告", @"色情", @"政治", @"反感", nil];
    sheet.tag = WMBaoliaoXiangqingViewTypeReport;
    [sheet showInView:self.view];
    [sheet release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(deleteFeedOK:) andFailedSelector:@selector(deleteFeedFailed:)];
        
        [[WMFeedService sharedWMFeedService] deleteFeedWithFID:_feed.mid andRequestDelegate:rd];
    }
}

- (void)deleteFeedOK:(NKRequest*)request
{
    [_delegate deleteFeed];
    [self goBack:self];
}

- (void)deleteFeedFailed:(NKRequest*)request
{
    ProgressErrorDefault;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    [self.headBar insertSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_head_back"]] autorelease] atIndex:0];
    [self addHeadShadow];
    
    [self addBackButton];
    [self addActionButton];
    
    if ([_feed.sender.mid length]) {
        [self initMainUI];
    }else {
        [self getFeedDetail:_feed];
    }
}

-(void)initMainUI
{
    self.titleLabel.text = [_titleString length]==0?@"爆料详情":_titleString;
    
    self.showTableView.backgroundColor = [UIColor whiteColor];
    CGRect frame = self.showTableView.frame;
    frame.size.height +=20;
    self.showTableView.frame = frame;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:nil];
    [self.view addGestureRecognizer:pan];
    pan.delegate = self;
    [pan release];
    
    [self addTableHeader];
    
    self.commentView = [NKInputView inputViewWithTableView:self.showTableView dataSource:self.dataSource otherView:nil];
    [self.contentView addSubview:_commentView];
    [self.commentView.textView setDefaultPlaceHolder:@"输入评论..."];
    _commentView.target = self;
    _commentView.action = @selector(addComment:);
    
    [self refreshData];
    
    self.loadingMoreView = [NKLoadingMoreView loadingMoreViewWithStyle:NKLoadingMoreViewStyleZUO];
    loadingMoreView.target = self;
    loadingMoreView.action = @selector(getMoreData);
    [self showFooter:NO];
}

-(void)getFeedDetail:(WMMFeed *)feed
{
    ProgressLoading;
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(getDetailOK:) andFailedSelector:@selector(getDetailFailed:)];
    [[WMFeedService sharedWMFeedService] getFeedWithFID:feed.mid andRequestDelegate:rd];
}

-(void)getDetailOK:(NKRequest*)request
{
    ProgressHide;
    self.feed = [WMMFeed modelFromDic:[[request.originDic valueForKey:@"data"] valueForKey:@"value"]];
    [self initMainUI];
}

-(void)getDetailFailed:(NKRequest*)request
{
    //ProgressErrorDefault;
}

- (void)addActionButton {
    [self addRightButtonWithFontTitle:@"● ● ●"];
}

-(void)pictureTapped:(UITapGestureRecognizer*)gesture{
    
    NKPictureViewer *viewer = [NKPictureViewer pictureViewerForView:[gesture view]];
    [viewer showPictureForObject:[[_feed attachments] lastObject] andKeyPath:@"picture"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Data

-(void)refreshData{
    
    NKRequestDelegate *rd = [NKRequestDelegate refreshRequestDelegateWithTarget:self];
    
    //    [[WMFeedService sharedWMFeedService] getFeedWithFID:_feed.mid andRequestDelegate:rd];
    [[WMFeedService sharedWMFeedService] getFeedCommentsWithFID:_feed.mid offset:0 size:DefaultOneRequestSize andRequestDelegate:rd];

}

-(void)getMoreData
{
    [self showFooter:YES];
    gettingMoreData = YES;
    
    NKRequestDelegate *rd = [NKRequestDelegate getMoreRequestDelegateWithTarget:self];
    
    [[WMFeedService sharedWMFeedService] getFeedCommentsWithFID:_feed.mid offset:[self.dataSource count] size:DefaultOneRequestSize andRequestDelegate:rd];
}

-(void)setPullBackFrame{
    
    _commentView.dataSource = self.dataSource;
}

#pragma mark TableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return [ZUOCommentCell cellHeightForObject:[self.dataSource objectAtIndex:indexPath.row]];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"WMFeedCellIdentifier";
    
    ZUOCommentCell *cell = (ZUOCommentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[ZUOCommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NKMRecord *message = [self.dataSource objectAtIndex:indexPath.row];
    [cell showForObject:message];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NKMRecord *message = [self.dataSource objectAtIndex:indexPath.row];
    NKMUser *user = message.sender;
    if (fabs([message.sender.mid floatValue]) == [[[WMMUser me] mid] floatValue]) {
        deleteIndex = indexPath.row;
        UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
        actionsheet.tag = COMMENTDELETETAG;
        [actionsheet showInView:self.view];
    }else {
        replyUser = user;
        [self.commentView.textView setDefaultPlaceHolder:[NSString stringWithFormat:@"回复 %@:",message.sender.name]];
        [self.commentView.textView.internalTextView becomeFirstResponder];
    }
    
    
}



#pragma mark Add Comment

-(void)addComment:(NSString*)content{
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(addCommentOK:) andFailedSelector:@selector(addCommentFailed:)];
    
    
    [[WMFeedService sharedWMFeedService] addFeedComment:_feed.mid touser:replyUser content:content anonymous:self.commentView.gongkaiButton.hidden andRequestDelegate:rd];
    Progress(@"正在发送");
}


-(void)addCommentOK:(NKRequest*)request{
    ProgressSuccess(@"评论成功");
    [self.dataSource addObject:[request.results lastObject]];
    
    NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:[self.dataSource count]-1 inSection:0];
    
    [showTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:lastIndex] withRowAnimation:UITableViewRowAnimationFade];
    [showTableView scrollToRowAtIndexPath:lastIndex atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [self setPullBackFrame];
    replyUser = nil;
    [_commentView sendOK];
    [_delegate commentFinished];
}

-(void)addCommentFailed:(NKRequest*)request{
    
    ProgressErrorDefault;
}

#pragma mark Gesture
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    if ([[otherGestureRecognizer view] isKindOfClass:[UITableView class]]) {
        [_commentView hide];
        replyUser = nil;
        return YES;
    }
    
    return NO;
}

@end
