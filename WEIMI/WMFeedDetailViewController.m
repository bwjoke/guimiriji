//
//  WMFeedDetailViewController.m
//  WEIMI
//
//  Created by King on 11/21/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//

#import "WMFeedDetailViewController.h"
#import "ZUOCommentCell.h"
#import "WMAudioPlayer.h"

@interface WMFeedDetailViewController ()
{
    NKMUser *replyUser;
    int deleteIndex;
    NKKVOImageView *picture;
}
@end

@implementation WMFeedDetailViewController {
    WMAudioPlayer *_playerButton;
}

@synthesize record;
@synthesize commentView;

#define FEEDDELETETAG 2013060401
#define COMMENTDELETETAG 2013060402

#define ME_SHEET 2013070201
#define OTHER_SHEET 2013070202
#define REPORT_SHEET 2013070203
#define NOREPORT_SHEET 2013070204

-(void)dealloc{
    
    [_feed release];
    [record release];
    picture.target = nil;
    [_playerButton destroy];
    
    [super dealloc];
}

+(id)feedDetailWithFeed:(WMMFeed*)feed{
    WMFeedDetailViewController *feedDetail = [[self alloc] init];
    feedDetail.feed = feed;
    feedDetail.parseIndexPath = 0;
    [NKNC pushViewController:feedDetail animated:YES];
    return [feedDetail autorelease];
}

+(id)feedDetailWithRecord:(NKMRecord*)theRecord{
    
    WMFeedDetailViewController *feedDetail = [[self alloc] init];
    feedDetail.record = theRecord;
    [NKNC pushViewController:feedDetail animated:YES];
    return [feedDetail autorelease];
    
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)headTapp:(UIGestureRecognizer*)gesture{
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self goBack:nil];
    }
    
}

-(void)addTimeLabel{
    CGFloat dayX = 258;
    CGFloat dayY = 19;
    
    self.day = [[[UILabel alloc] initWithFrame:CGRectMake(dayX, dayY, 52, 24)] autorelease];
    [self.headBar addSubview:_day];
    _day.backgroundColor = [UIColor clearColor];
    _day.font = [UIFont boldSystemFontOfSize:22];
    _day.textColor = [UIColor colorWithHexString:@"#7E6B5A"];
    
    self.month = [[[UILabel alloc] initWithFrame:CGRectMake(dayX+28, dayY+10, 25, 11)] autorelease];
    [self.headBar addSubview:_month];
    _month.backgroundColor = [UIColor clearColor];
    _month.font = [UIFont boldSystemFontOfSize:10];
    _month.textColor = [UIColor colorWithHexString:@"#A6937C"];
    
    self.time = [[[UILabel alloc] initWithFrame:CGRectMake(dayX+20, dayY+12, 30, 13)] autorelease];
    [self.headBar addSubview:_time];
    _time.backgroundColor = [UIColor clearColor];
    _time.font = [UIFont systemFontOfSize:11];
    _time.textColor = [UIColor colorWithHexString:@"#A6937C"];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"dd"];
    
    WMMFeed *feed = self.feed;
    
    NSString *day = [dateFormatter stringFromDate:feed.createTime];
    
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    NSInteger today = [[dateFormatter stringFromDate:[NSDate date]] integerValue];
    NSInteger feedDay = [[dateFormatter stringFromDate:feed.createTime] integerValue];
    
    _day.font = [UIFont systemFontOfSize:23];
    
    if (today == feedDay) {
        day = @"今天";
        self.month.hidden = YES;
    }
    else if (today-feedDay==1){
        day = @"昨天";
        self.month.hidden = YES;
    }
    else{
        _day.font = [UIFont boldSystemFontOfSize:22];
    }
    
    self.day.text = day;
    
    CGRect timeFrame = _time.frame;
    timeFrame.origin.y = dayY+24;
    _time.frame = timeFrame;
    
    
    [dateFormatter setDateFormat:@"MM月"];
    
    self.month.text = [dateFormatter stringFromDate:feed.createTime];
    
    [dateFormatter setDateFormat:@"HH:mm"];
    self.time.text = [dateFormatter stringFromDate:feed.createTime];
    
    self.time.hidden = (feed.feedType == WMMFeedTypeCreate)? YES:NO;
    

}

-(void)addTableHeader{
    
    CGFloat totalHeight = 0;
    
    UIView *tableViewHeader = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    totalHeight+=15;
    
    LWRichTextContentView *contentEmojo = [[[LWRichTextContentView alloc] initWithFrame:CGRectMake(15, totalHeight+2, 290, 16) withFont:[UIFont systemFontOfSize:14] withTextColor:[UIColor colorWithHexString:@"#7E6B5A"] withTextShadowColor:nil withTextShadowOffSet:CGSizeZero] autorelease];
    [tableViewHeader addSubview:contentEmojo];
    [contentEmojo setBackgroundColor:[UIColor clearColor]];
    LWVMRichTextContent *postContent = [[[LWVMRichTextContent alloc] initWithContent:_feed.content
                                                                            withType:LWVMRichTextShowContentTypeMiyuDetail] autorelease];
    
    [postContent resetNodeFrameWithOriginX:0 withOriginY:0];
    contentEmojo.richTextContent = postContent;
    CGRect contentsFrame = contentEmojo.frame;
    contentsFrame.size.height = postContent.height;
    contentEmojo.frame = contentsFrame;
    
    [contentEmojo setNeedsDisplay];
    
    totalHeight += postContent.height;
    
//    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, totalHeight+2, 290, [_feed.content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(290, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height)];
//    [tableViewHeader addSubview:contentLabel];
//    [contentLabel release];
//    contentLabel.text = _feed.content;
//    contentLabel.numberOfLines = 0;
//    contentLabel.textColor = [UIColor colorWithHexString:@"#7E6B5A"];
//    contentLabel.font = [UIFont systemFontOfSize:14];
//    //contentLabel.backgroundColor = [UIColor greenColor];
//    
//    totalHeight += [_feed.content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(290, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
    
    
    
    UIButton *deleteButton;
    
    if ([_feed.attachments lastObject]) {
        
        UIImageView *pictureBack = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feed_cell_picture"]] autorelease];
        [tableViewHeader addSubview:pictureBack];
        pictureBack.frame = CGRectMake(11, totalHeight+2.5, pictureBack.frame.size.width, pictureBack.frame.size.height);
        
        picture = [[NKKVOImageView alloc] initWithFrame:CGRectMake(18, totalHeight+9, 75, 75)];
        [tableViewHeader addSubview:picture];
        [picture release];
        picture.target = self;
        picture.singleTapped = @selector(pictureTapped:);
        [picture bindValueOfModel:[_feed.attachments lastObject] forKeyPath:@"picture"];
        
        totalHeight += 88;
        
        totalHeight += 15;
        
    }else {
        totalHeight += 15+20;
    }
    
    if (_feed.audioURLString) {
        
        if ([_feed.attachments lastObject]) {
            totalHeight += 23.0f;
        } else {
            totalHeight += 3.0f;
        }
        
        NSURL *URL = [NSURL URLWithString:_feed.audioURLString];
        int seconds = [_feed.audioSecond intValue];
        
        WMAudioPlayer *player = [[[WMAudioPlayer alloc] initWithURL:URL length:seconds] autorelease];
        
        CGRect frame = player.frame;
        frame.origin = CGPointMake(15.0f, totalHeight - 33.0f);
        player.frame = frame;
        
        [tableViewHeader addSubview:player];
        
        _playerButton = player;
    }
    
    deleteButton = [[[UIButton alloc] initWithFrame:CGRectMake(259, totalHeight - 27, 40, 20)] autorelease];
    
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"btn_more_normal"] forState:UIControlStateNormal];
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"btn_more_click"] forState:UIControlStateHighlighted];
    [deleteButton addTarget:self action:@selector(showMoreView:) forControlEvents:UIControlEventTouchUpInside];
    [tableViewHeader addSubview:deleteButton];
//    if ([_feed.sender.mid isEqualToString:[[WMMUser me] mid]]) {
//        
//    }else {
//        if ([_feed.attachments lastObject]) {
//            //totalHeight -= 15;
//        }else {
//            totalHeight -= 20;
//        }
//    }
    
    
    
    UIView *line = [[[UIView alloc] initWithFrame:CGRectMake(0, totalHeight-1, 320, 1)] autorelease];
    [tableViewHeader addSubview:line];
    line.backgroundColor = [UIColor colorWithHexString:@"#F1ECE4"];
    
    tableViewHeader.frame = CGRectMake(0, 0, 320, totalHeight);
    
    self.showTableView.tableHeaderView = tableViewHeader;
    [tableViewHeader release];

}

-(void)showMoreView:(id)sender
{
    if ([_feed.sender.mid isEqualToString:[[WMMUser me] mid]]) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@"评论", nil];
        sheet.tag = ME_SHEET;
        [sheet showInView:self.view];
    }else {
        if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"sysFunction"] valueForKey:@"miyureport"] boolValue])  {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报" otherButtonTitles:@"评论", nil];
            sheet.tag = OTHER_SHEET;
            [sheet showInView:self.view];
        }else {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"评论", nil];
            sheet.tag = NOREPORT_SHEET;
            [sheet showInView:self.view];
        }
        
        
    }
}

- (void)deleteFeed
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要删除这条记录吗？" delegate:self cancelButtonTitle:@"不删除" otherButtonTitles:@"删除", nil];
    [alert show];
    
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
    self.headBar.frame = CGRectMake(0, 0, 320, 70);
    UIImageView *headImage = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feed_detail_head"]] autorelease];
    [self.headBar insertSubview:headImage atIndex:0];
    
    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTapp:)] autorelease];
    [self.headBar addGestureRecognizer:tap];
    self.showTableView.frame = CGRectMake(0, self.headBar.frame.size.height, 320, NKContentHeight );
    self.showTableView.backgroundColor = [UIColor whiteColor];
    if ([_feed.sender.mid length]) {
        [self initMainUI];
    }else {
        [self getFeedDetail:_feed];
        //[self initMainUI];
    }
}

-(void)initMainUI
{
    NKKVOImageView *avatar = [[NKKVOImageView alloc] initWithFrame:CGRectMake(15, 10, 50, 50)];
    [self.headBar insertSubview:avatar atIndex:0];
    [avatar release];
    [avatar bindValueOfModel:self.feed.sender forKeyPath:@"avatar"];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 23, 180, 26)];
    [self.headBar addSubview:nameLabel];
    [nameLabel release];
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor colorWithHexString:@"#7E6B5A"];
    nameLabel.font = [UIFont systemFontOfSize:24];
    nameLabel.text = _feed.sender.name;
    
    
    [self addTimeLabel];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:nil];
    [self.view addGestureRecognizer:pan];
    pan.delegate = self;
    [pan release];
    
    [self addTableHeader];
    
    self.commentView = [NKInputView inputViewWithTableView:self.showTableView dataSource:self.dataSource otherView:nil];
    [self.contentView addSubview:commentView];
    self.commentView.target = self;
    self.commentView.action = @selector(addComment:);
    self.commentView.nimingButton.hidden = YES;
    self.commentView.enableSendButton = YES;
    
    
    CGRect emojoFrame = commentView.emojoButton.frame;
    emojoFrame.origin.x = 4;
    commentView.emojoButton.frame = emojoFrame;
    commentView.jianpanButton.frame = emojoFrame;
    
    CGFloat xOff = 30;
    
    CGRect textFrame = commentView.textView.frame;
    textFrame.origin.x -= xOff;
    textFrame.size.width += xOff;
    commentView.textView.frame = textFrame;
    
    CGRect textBackFrame = commentView.textViewBack.frame;
    textBackFrame.origin.x -= xOff;
    textBackFrame.size.width += xOff;
    commentView.textViewBack.frame = textBackFrame;
    
    [self refreshData];
    
    self.loadingMoreView = [NKLoadingMoreView loadingMoreViewWithStyle:NKLoadingMoreViewStyleZUO];
    loadingMoreView.target = self;
    loadingMoreView.action = @selector(getMoreData);
    [self showFooter:NO];
}

-(void)getMoreData
{
    [self showFooter:YES];
    gettingMoreData = YES;
    
    NKRequestDelegate *rd = [NKRequestDelegate getMoreRequestDelegateWithTarget:self];
    
    [[WMFeedService sharedWMFeedService] getFeedCommentsWithFID:_feed.mid offset:[self.dataSource count] size:DefaultOneRequestSize andRequestDelegate:rd];
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

-(void)setPullBackFrame{
    
    commentView.dataSource = self.dataSource;
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


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 && actionSheet.tag == COMMENTDELETETAG) {
        [self deleteComment];
    }else if (actionSheet.tag == ME_SHEET) {
        if (buttonIndex == 0) {
            [self deleteFeed];
        }else if(buttonIndex == 1) {
            [self.commentView.textView becomeFirstResponder];
        }
    }else if (actionSheet.tag == OTHER_SHEET) {
        if (buttonIndex == 0) {
            [self showReportActionSheet];
        }else if(buttonIndex == 1){
            [self.commentView.textView becomeFirstResponder];
        }
    }else if (actionSheet.tag == NOREPORT_SHEET) {
        if(buttonIndex == 0){
            [self.commentView.textView becomeFirstResponder];
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
        
        [[WMFeedService sharedWMFeedService] reportFeedWithFID:self.feed.mid andContent:reportType andRequestDelegate:rd];
    }
}

- (void)reportOK:(NKRequest *)request {
    ProgressSuccess(@"举报成功");
}

- (void)reportFailed:(NKRequest *)request {
    ProgressHide;
}

- (void)showReportActionSheet
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
     ProgressErrorDefault;
}

#pragma mark Add Comment

-(void)addComment:(NSString*)content{
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(addCommentOK:) andFailedSelector:@selector(addCommentFailed:)];
    

    [[WMFeedService sharedWMFeedService] addFeedComment:_feed.mid touser:replyUser content:content anonymous:0 andRequestDelegate:rd];
}


-(void)addCommentOK:(NKRequest*)request{
    ProgressSuccess(@"OK");
    [self.dataSource addObject:[request.results lastObject]];
    
    NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:[self.dataSource count]-1 inSection:0];
    
    [showTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:lastIndex] withRowAnimation:UITableViewRowAnimationFade];
    [showTableView scrollToRowAtIndexPath:lastIndex atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [self setPullBackFrame];
    [self.commentView.textView setDefaultPlaceHolder:@""];
    replyUser = nil;
    [commentView sendOK];
    [_delegate commentFinished];
}

-(void)addCommentFailed:(NKRequest*)request{
    
    ProgressErrorDefault;
}

#pragma mark Gesture
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    if ([[otherGestureRecognizer view] isKindOfClass:[UITableView class]]) {
        [self.commentView.textView setDefaultPlaceHolder:nil];
        [commentView hide];
        replyUser = nil;
        return YES;
    }
    
    return NO;
}

@end
