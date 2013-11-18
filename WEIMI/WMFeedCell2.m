//
//  WMFeedCell2.m
//  WEIMI
//
//  Created by King on 11/20/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//

#import "WMFeedCell2.h"
#import "WMAudioPlayer.h"

#define WMFeedContentFont [UIFont systemFontOfSize:14]
#define Yoffset 6

#define WMFeedCell2NoAttachmentsMaxContentHight 140
#define WMFeedCell2NoAttachmentsContentWidth 227

#define WMFeedCell2HasAttachmentsMaxContentHight 80

@implementation WMFeedCell2 {
    WMAudioPlayer *_playerButton;
}

-(void)dealloc
{
    _picture.target = nil;
}

+ (BOOL)shouldShowDayAtIndexPath:(NSIndexPath *)indexPath dataSource:(NSArray *)dataSource {
    WMMFeed *feed = dataSource[indexPath.row];
    
    BOOL shoulShowDay = YES;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd"];
    
    NSString *day = [dateFormatter stringFromDate:feed.createTime];
    
    if (indexPath.row==0) {
        shoulShowDay = YES;
    } else {
        WMMFeed *preFeed = [dataSource objectAtIndex:indexPath.row-1];
        NSString *preDay = [dateFormatter stringFromDate:preFeed.createTime];
        shoulShowDay = ![preDay isEqualToString:day];
    }
    
    return shoulShowDay;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#FFF4F4"];
        
        CGFloat startY = Yoffset;
        
        UIImageView *pictureBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feed_cell_picture"]];
        [self.contentView addSubview:pictureBack];
        pictureBack.frame = CGRectMake(75, startY+0, pictureBack.frame.size.width, pictureBack.frame.size.height);
        pictureBack.userInteractionEnabled = YES;
        self.pictureBack = pictureBack;
        
        NKKVOImageView *picture = [[NKKVOImageView alloc] initWithFrame:CGRectMake(7, 6.5, 75, 75)];
        picture.target = self;
        picture.singleTapped = @selector(pictureTapped:);
        [self.pictureBack addSubview:picture];
        self.picture = picture;
        
        UILabel *day = [[UILabel alloc] initWithFrame:CGRectMake(15, startY+2, 52, 28)];
        [self.contentView addSubview:day];
        day.backgroundColor = [UIColor clearColor];
        day.font = [UIFont boldSystemFontOfSize:27];
        day.textColor = [UIColor colorWithHexString:@"#7E6B5A"];
        self.day = day;
        
        UILabel *month = [[UILabel alloc] initWithFrame:CGRectMake(46, startY+15, 25, 11)];
        [self.contentView addSubview:month];
        month.backgroundColor = [UIColor clearColor];
        month.font = [UIFont boldSystemFontOfSize:10];
        month.textColor = [UIColor colorWithHexString:@"#A6937C"];
        self.month = month;
        
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(38, startY+12, 30, 13)];
        [self.contentView addSubview:time];
        time.backgroundColor = [UIColor clearColor];
        time.font = [UIFont systemFontOfSize:11];
        time.textColor = [UIColor colorWithHexString:@"#A6937C"];
        self.time = time;
        
        UIButton *createButton = [[UIButton alloc] initWithFrame:CGRectMake(79, startY+0, 227, 50)];
        [createButton setImage:[UIImage imageNamed:@"miyu_create_normal"] forState:UIControlStateNormal];
        [createButton setImage:[UIImage imageNamed:@"miyu_create_click"] forState:UIControlStateHighlighted];
        [createButton addTarget:self action:@selector(createFeed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:createButton];
        self.createButton = createButton;
        
//        UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(0, startY+0, 30, 13)];
//        [self.contentView addSubview:content];
//        content.numberOfLines = 0;
//        content.backgroundColor = [UIColor clearColor];
//        content.font = WMFeedContentFont;
//        content.textColor = [UIColor colorWithHexString:@"#7E6B5A"];
//        content.lineBreakMode = UILineBreakModeTailTruncation;
//        self.content = content;
        
        LWRichTextContentView *content = [[LWRichTextContentView alloc] initWithFrame:CGRectMake(0, startY+0, 30, 13) withFont:WMFeedContentFont withTextColor:[UIColor colorWithHexString:@"#7E6B5A"] withTextShadowColor:nil withTextShadowOffSet:CGSizeZero];
        [self.contentView addSubview:content];
        [content setBackgroundColor:[UIColor clearColor]];
        self.content = content;
        
        UILabel *commentCount = [[UILabel alloc] initWithFrame:CGRectMake(206, startY+40, 100, 17)];
        [self.contentView addSubview:commentCount];
        commentCount.backgroundColor = [UIColor clearColor];
        commentCount.font = [UIFont systemFontOfSize:10];
        commentCount.textColor = [UIColor colorWithHexString:@"#D1C0A5"];
        commentCount.textAlignment = UITextAlignmentRight;
        self.commentCount = commentCount;
        
        UIView *commentContainer = [[UIView alloc] initWithFrame:CGRectMake(88, startY+100, 228, 66)];
        [self.contentView addSubview:commentContainer];
        self.commentContainer = commentContainer;
        
        [self.bottomLine removeFromSuperview];
        
        UIImageView *bottomLine_ = [[UIImageView alloc] initWithFrame:CGRectMake(0, 84, 320, 1)];
        bottomLine_.image = [UIImage imageNamed:@"men_cell_sep"];
        [self addSubview:bottomLine_];
        self.bottomLine = bottomLine_;
        
    }
    return self;
}

-(void)createFeed:(id)sender
{
    [_delegate createFeed];
}

-(void)pictureTapped:(UITapGestureRecognizer*)gesture{
    
    
    if ([[[self.showedObject attachments] lastObject] thumbnail]) {
        NKPictureViewer *viewer = [NKPictureViewer pictureViewerForView:self.picture];
        [viewer showPictureForObject:[[self.showedObject attachments] lastObject] andKeyPath:@"picture"];
    }
    
}

- (void)showForIndexPath:(NSIndexPath *)indexPath dataSource:(NSArray *)dataSource {
    CGFloat cellHeight = 0.0f;
    self.showedObject = dataSource[indexPath.row];
    WMMFeed *feed = self.showedObject;
    
    self.createButton.hidden = !(feed.feedType == WMMFeedTypeCreate);
    self.commentButton.hidden = (feed.feedType == WMMFeedTypeCreate);
    self.pictureBack.hidden = ![feed.attachments count];
    
    [self.scoreView removeFromSuperview];
    self.scoreView = nil;
    
    self.commentCount.text = [feed.commentCount intValue]?[NSString stringWithFormat:@"%@条评论", feed.commentCount]:nil;
    
    if ([feed.type isEqualToString:WMFeedTypeDafen]) {
        
        NSArray *scores = [feed.score objectOrNilForKey:@"scores"];
        int line = [scores count]/6 + 1;
        
        cellHeight = 54*line + 11 + 5 + ([feed.commentCount intValue] ? 17 : 0);
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.scoreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, cellHeight)];
        _scoreView.backgroundColor = [UIColor colorWithHexString:@"#F1ECE4"];
        
        [self.contentView addSubview:_scoreView];
        
        if (![scores isKindOfClass:[NSArray class]]) {
            return;
        }
        
        CGFloat startX = 15;
        CGFloat startY = 11;
        UIImageView *scoreCard = nil;
        UILabel *scoreLabel = nil;
        UILabel *scoreName = nil;
        NSDictionary *scoreDic = nil;
        
        for (int i=0; i<[scores count]; i++) {
            
            scoreDic = scores[i];
            
            scoreCard = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"score_card"]];
            CGRect scoreCardFrame = scoreCard.frame;
            scoreCardFrame.origin.x = startX;
            scoreCardFrame.origin.y = startY;
            scoreCard.frame = scoreCardFrame;
            [_scoreView addSubview:scoreCard];
            
            scoreLabel = [[UILabel alloc] initWithFrame:scoreCard.bounds];
            [scoreCard addSubview:scoreLabel];
            scoreLabel.textColor = [UIColor colorWithHexString:@"#ED8387"];
            scoreLabel.textAlignment = NSTextAlignmentCenter;
            scoreLabel.text = [NSString stringWithFormat:@"%.0f", [[scoreDic objectOrNilForKey:@"score"] floatValue]];
            scoreLabel.backgroundColor = [UIColor clearColor];
            scoreLabel.font = [UIFont boldSystemFontOfSize:18];
            
            scoreName = [[UILabel alloc] initWithFrame:CGRectMake(0, scoreCardFrame.size.height, scoreCardFrame.size.width, 22)];
            [scoreCard addSubview:scoreName];
            scoreName.textColor = [UIColor colorWithHexString:@"#A6937C"];
            scoreName.textAlignment = NSTextAlignmentCenter;
            scoreName.text = [scoreDic objectOrNilForKey:@"name"];
            scoreName.backgroundColor = [UIColor clearColor];
            scoreName.font = [UIFont boldSystemFontOfSize:10];
            
            startX += 50;
            
            if (startX > 300) {
                startX = 15;
                startY += 54;
            }
        }
        
        [self.scoreView addSubview:self.commentCount];
        CGRect commentButtonFrame = _commentCount.frame;
        commentButtonFrame.origin.y = _scoreView.frame.size.height-20;
        _commentCount.frame = commentButtonFrame;
        
        CGRect frame = self.frame;
        frame.size.height = cellHeight;
        self.frame = frame;
        
        return;
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    [self.contentView addSubview:_commentCount];
    
//    self.content.text = feed.content;
    
    CGRect contentFrame = CGRectZero;
    
    if ([feed.attachments count]) {
        [_picture bindValueOfModel:[feed.attachments lastObject] forKeyPath:@"thumbnail"];
        
        LWVMRichTextContent *postContent = [[LWVMRichTextContent alloc] initWithContent:feed.content
                                                                               withType:LWVMRichTextTypeFeedListWithAttachment];
        [postContent resetNodeFrameWithOriginX:0 withOriginY:0];
        
        self.content.richTextContent = postContent;
        
        contentFrame = CGRectMake(168, 4+Yoffset, 140, postContent.height);
        
        self.content.frame = contentFrame;
        
        [self.content setNeedsDisplay];
        
        CGRect commentButtonFrame = _commentCount.frame;
        commentButtonFrame.origin.y = 68+Yoffset;
        _commentCount.frame = commentButtonFrame;
        _commentCount.hidden = YES;
        
        CGRect commentContainerFrame = _commentContainer.frame;
        commentContainerFrame.origin.y = _commentCount.frame.origin.y + _commentCount.frame.size.height + 10;
        commentContainerFrame.origin.x = 79;
        _commentContainer.frame = commentContainerFrame;
    }
    
    else{
        
        LWVMRichTextContent *postContent = [[LWVMRichTextContent alloc] initWithContent:feed.content
                                                                               withType:LWVMRichTextTypeFeedList];
        [postContent resetNodeFrameWithOriginX:0 withOriginY:0];
        
        self.content.richTextContent = postContent;
        
        contentFrame = CGRectMake(79, 4+Yoffset, WMFeedCell2NoAttachmentsContentWidth, postContent.height);
        
        self.content.frame = contentFrame;
        
        [self.content setNeedsDisplay];
        
        CGRect commentButtonFrame = _commentCount.frame;
        commentButtonFrame.origin.y = self.content.frame.size.height+self.content.frame.origin.y - 18.0f;
        
        _commentCount.frame = commentButtonFrame;
        _commentCount.hidden = YES;
        
        CGRect commentContainerFrame = _commentContainer.frame;
        commentContainerFrame.origin.y = _commentCount.frame.origin.y + _commentCount.frame.size.height + 8;
        commentContainerFrame.origin.x = 79;
        _commentContainer.frame = commentContainerFrame;
    }
    
    if (_playerButton) {
        [_playerButton destroy];
        [_playerButton removeFromSuperview];
        _playerButton = nil;
    }
    
    if (feed.audioURLString) {
        // Audio player button {{{
        
        NSURL *amrURL = [NSURL URLWithString:feed.audioURLString];
        int length = [feed.audioSecond intValue];
        
        _playerButton = [[WMAudioPlayer alloc] initWithURL:amrURL length:length];
        
        CGRect frame = _playerButton.frame;
        
        frame.origin = CGPointMake(79.0f, _commentContainer.frame.origin.y - 3);
        
        _playerButton.frame = frame;
        
        [self addSubview:_playerButton];
        
        // }}}
        
        // Adjust the _commentContainer.y
        
        CGRect commentContainerFrame = _commentContainer.frame;
        commentContainerFrame.origin.y += _playerButton.frame.size.height + 5;
        _commentContainer.frame = commentContainerFrame;
        
    }
    
    [_commentContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGRect commentContainerFrame = _commentContainer.frame;
    commentContainerFrame.size.height = 0;
    _commentContainer.frame = commentContainerFrame;
    
    self.bottomLine.hidden = NO;
    
    if ([feed.comments count] > 0) {
        
        UIImageView *contentSep = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.commentContainer.frame.size.width, 1)];
        contentSep.backgroundColor = [UIColor colorWithHexString:@"#EAE0D1"];
        [self.commentContainer addSubview:contentSep];
        self.contentSep = contentSep;
        
        CGFloat offsetY = 10.0f;
        CGFloat contentHeight = 0.0f;
        
        for (int i=0; i<[feed.comments count]; i++) {
            
            WMMComment *comment = [feed.comments objectAtIndex:i];
            
            NSString *text = [NSString stringWithFormat:@"%@:%@",comment.sender.name, comment.content];
            if ([comment.prefix length]) {
                text = [NSString stringWithFormat:@"%@回复%@:%@",comment.sender.name,comment.prefix, comment.content_orgin];
            }
            LWRichTextContentView *commentEmojo = [[LWRichTextContentView alloc] initWithFrame:CGRectMake(0, offsetY, _commentContainer.frame.size.width, 14) withFont:[UIFont systemFontOfSize:12] withTextColor:[UIColor colorWithHexString:@"#A6937C"] withTextShadowColor:nil withTextShadowOffSet:CGSizeZero];
            [_commentContainer addSubview:commentEmojo];
            
            [commentEmojo setBackgroundColor:[UIColor clearColor]];
            
            LWVMRichTextContent *postContent = [[LWVMRichTextContent alloc] initWithContent:text
                                                                                   withType:LWVMRichTextShowContentTypeFeed];
            
            [postContent resetNodeFrameWithOriginX:0 withOriginY:0];
            
            CGRect contentFrame = commentEmojo.frame;
            contentFrame.size.height = postContent.height;
            commentEmojo.frame = contentFrame;
            commentEmojo.richTextContent = postContent;
            [commentEmojo setNeedsDisplay];
            
            contentHeight = MAX(commentEmojo.frame.size.height, 20.0f);
            
            if (contentHeight > 20.0f) {
                contentHeight += 3.0f;
            }
            
            offsetY += contentHeight;
        }
        
        commentContainerFrame = _commentContainer.frame;
        commentContainerFrame.size.height = offsetY;
        _commentContainer.frame = commentContainerFrame;
        
    }
    
    if (!self.createButton.hidden) {
        self.bottomLine.hidden = YES;
    }
    
    CGFloat commentHeight = _commentContainer.frame.size.height;
    
    cellHeight = _commentContainer.frame.origin.y + commentHeight;
    
    if (commentHeight > 0) {
        cellHeight += 7;
    }
    
    // Should show date {{{
    BOOL shouldShowDate = [[self class] shouldShowDayAtIndexPath:indexPath dataSource:dataSource];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd"];
    [self showDate:shouldShowDate dateFormatter:formatter];
    
    if (![feed.comments count] && ![[feed attachments] count] && [[self class] shouldShowDayAtIndexPath:indexPath dataSource:dataSource]) {
        cellHeight += 20.0f;
    }
    // }}}
    
    self.bottomLine.frame = CGRectMake(0, cellHeight - 1, 320, 1);
    
    if (feed.feedType == WMMFeedTypeCreate) {
        CGRect frame = self.frame;
        frame.size.height = 60;
        self.frame = frame;
        return;
    }
    
    CGRect frame = self.frame;
    frame.size.height = cellHeight;
    self.frame = frame;
}

-(void)showDate:(BOOL)shoulShowDay dateFormatter:(NSDateFormatter*)dateFormatter{
    
    WMMFeed *feed = self.showedObject;
    
    NSString *day = [dateFormatter stringFromDate:feed.createTime];
    
    if (shoulShowDay) {
        self.day.hidden = NO;
        self.month.hidden = NO;
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        
        NSInteger today = [[dateFormatter stringFromDate:[NSDate date]] integerValue];
        NSInteger feedDay = [[dateFormatter stringFromDate:feed.createTime] integerValue];
        
        _day.font = [UIFont systemFontOfSize:26];
        
        if (today == feedDay) {
            day = @"今天";
            self.month.hidden = YES;
        }
        else if (today-feedDay==1){
            day = @"昨天";
            self.month.hidden = YES;
        }
        else{
            _day.font = [UIFont boldSystemFontOfSize:26];
        }
        
        self.day.text = day;
        
        CGRect timeFrame = _time.frame;
        timeFrame.origin.y = 29+Yoffset;
        _time.frame = timeFrame;
        
        
        [dateFormatter setDateFormat:@"MM月"];
        
        self.month.text = [dateFormatter stringFromDate:feed.createTime];
        
        
    }
    
    else{
        self.day.hidden = YES;
        self.month.hidden = YES;
        
        
        CGRect timeFrame = _time.frame;
        timeFrame.origin.y = 6+Yoffset;
        _time.frame = timeFrame;
        
        
    }
    
    
    [dateFormatter setDateFormat:@"HH:mm"];
    self.time.text = [dateFormatter stringFromDate:feed.createTime];
    
    self.time.hidden = (feed.feedType == WMMFeedTypeCreate)? YES:NO;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
