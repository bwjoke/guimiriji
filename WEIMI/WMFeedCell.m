//
//  WMFeedCell.m
//  WEIMI
//
//  Created by King on 11/20/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//

#import "WMFeedCell.h"

#define WMFeedContentFont [UIFont systemFontOfSize:14]
#define Yoffset 6

#define WMFeedCellNoAttachmentsMaxContentHight 140
#define WMFeedCellNoAttachmentsContentWidth 227

#define WMFeedCellHasAttachmentsMaxContentHight 80

@implementation WMFeedCell

-(void)dealloc{
    
    [_commentCount release];
    _picture.target = nil;
    [super dealloc];
}

+ (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath dataSource:(NSArray *)dataSource {
    WMMFeed *feed = dataSource[indexPath.row];
    
    if (feed.feedType == WMMFeedTypeCreate) {
        return 60;
    }
    
    if ([feed.type isEqualToString:WMFeedTypeDafen]) {
        
        NSArray *scores = [feed.score objectOrNilForKey:@"scores"];
        int line = [scores count]/6 + 1;
        
        return 54*line + 11 + 5 + ([feed.commentCount intValue]?17:0);
    } else {
        CGFloat height = 0;
        // Comment Button Origin
        if ([feed.attachments count]) {
            height = 75;
        } else {
            height = [feed.content sizeWithFont:WMFeedContentFont constrainedToSize:CGSizeMake(WMFeedCellNoAttachmentsContentWidth, WMFeedCellNoAttachmentsMaxContentHight) lineBreakMode:NSLineBreakByWordWrapping].height + 2 + 10;
        }
        
        if ([feed.comments count] && [feed.attachments count]) {
            height += 15;
        }
        
        if ([feed.comments count]) {
            CGFloat _height = 0.0f;
            
            for (WMMComment *comment in feed.comments) {
                NSString *text = [NSString stringWithFormat:@"%@：%@",comment.sender.name, comment.content];
                if ([comment.prefix length]) {
                    text = [NSString stringWithFormat:@"%@回复%@：%@",comment.sender.name,comment.prefix, comment.content_orgin];
                }
                LWVMRichTextContent *postContent = [[[LWVMRichTextContent alloc] initWithContent:text
                                                                                        withType:LWVMRichTextShowContentTypeFeed] autorelease];
                
                _height = MAX(postContent.height, 20.0f);
                if (_height > 20.0f) {
                    _height += 3.0f;
                }
                
                height += _height;
            }
            
            if ([feed.attachments count]) {
                height += 15;
            } else {
                height += 5;
            }
            
        } else if ([feed.attachments count] > 0) {
            height += 15;
        }
        
        height+=12;
        
        if (![feed.comments count] && ![[feed attachments] count] && [self shouldShowDayAtIndexPath:indexPath dataSource:dataSource]) {
            height += 15.0f;
        }
        
        return MAX(Yoffset+29+10, height);
    }
    
    return 100;
}

+ (BOOL)shouldShowDayAtIndexPath:(NSIndexPath *)indexPath dataSource:(NSArray *)dataSource {
    WMMFeed *feed = dataSource[indexPath.row];
    
    BOOL shoulShowDay = YES;
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
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
        self.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#FFF4F4"];
        
        CGFloat startY = Yoffset;
        
        self.feedback = [[[UIImageView alloc] initWithImage:nil highlightedImage:[[UIImage imageNamed:@"redfeed"] resizeImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]] autorelease];
        [self.contentView addSubview:_feedback];
        _feedback.frame = CGRectMake(76, startY+1, 207+8+16, 0);
        
        
        
        self.pictureBack = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feed_cell_picture"]] autorelease];
        [self.contentView addSubview:_pictureBack];
        _pictureBack.frame = CGRectMake(74, startY+0, _pictureBack.frame.size.width, _pictureBack.frame.size.height);
        _pictureBack.userInteractionEnabled = YES;
        
        self.picture = [[[NKKVOImageView alloc] initWithFrame:CGRectMake(7, 6.5, 75, 75)] autorelease];
        _picture.target = self;
        _picture.singleTapped = @selector(pictureTapped:);
        [self.pictureBack addSubview:_picture];
        
        self.day = [[[UILabel alloc] initWithFrame:CGRectMake(15, startY+2, 52, 28)] autorelease];
        [self.contentView addSubview:_day];
        _day.backgroundColor = [UIColor clearColor];
        _day.font = [UIFont boldSystemFontOfSize:27];
        _day.textColor = [UIColor colorWithHexString:@"#7E6B5A"];
        
        self.month = [[[UILabel alloc] initWithFrame:CGRectMake(46, startY+15, 25, 11)] autorelease];
        [self.contentView addSubview:_month];
        _month.backgroundColor = [UIColor clearColor];
        _month.font = [UIFont boldSystemFontOfSize:10];
        _month.textColor = [UIColor colorWithHexString:@"#A6937C"];
        
        self.time = [[[UILabel alloc] initWithFrame:CGRectMake(38, startY+12, 30, 13)] autorelease];
        [self.contentView addSubview:_time];
        _time.backgroundColor = [UIColor clearColor];
        _time.font = [UIFont systemFontOfSize:11];
        _time.textColor = [UIColor colorWithHexString:@"#A6937C"];
        
        self.createButton = [[[UIButton alloc] initWithFrame:CGRectMake(79, startY+0, 227, 50)] autorelease];
        [_createButton setImage:[UIImage imageNamed:@"miyu_create_normal"] forState:UIControlStateNormal];
        [_createButton setImage:[UIImage imageNamed:@"miyu_create_click"] forState:UIControlStateHighlighted];
        [_createButton addTarget:self action:@selector(createFeed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_createButton];
        
        self.content = [[[UILabel alloc] initWithFrame:CGRectMake(0, startY+0, 30, 13)] autorelease];
        [self.contentView addSubview:_content];
        _content.numberOfLines = 0;
        _content.backgroundColor = [UIColor clearColor];
        _content.font = WMFeedContentFont;
        _content.textColor = [UIColor colorWithHexString:@"#7E6B5A"];
        _content.lineBreakMode = UILineBreakModeTailTruncation;
        
        self.commentCount = [[[UILabel alloc] initWithFrame:CGRectMake(206, startY+40, 100, 17)] autorelease];
        [self.contentView addSubview:_commentCount];
        _commentCount.backgroundColor = [UIColor clearColor];
        _commentCount.font = [UIFont systemFontOfSize:10];
        _commentCount.textColor = [UIColor colorWithHexString:@"#D1C0A5"];
        _commentCount.textAlignment = UITextAlignmentRight;
        
        self.commentContainer = [[[UIView alloc] initWithFrame:CGRectMake(88, startY+100, 228, 66)] autorelease];
        //self.commentContainer.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_commentContainer];
        
        [self.bottomLine removeFromSuperview];
        self.bottomLine = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 84, 320, 1)] autorelease];
        self.bottomLine.image = [UIImage imageNamed:@"men_cell_sep"];
        [self addSubview:self.bottomLine];
        
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
    self.showedObject = dataSource[indexPath.row];
    WMMFeed *feed = self.showedObject;
    
    self.createButton.hidden = !(feed.feedType == WMMFeedTypeCreate);
    self.commentButton.hidden = (feed.feedType == WMMFeedTypeCreate);
    self.pictureBack.hidden = ![feed.attachments count];
    
    [self.scoreView removeFromSuperview];
    self.scoreView = nil;
    
    
    CGRect feedbackFrame = _feedback.frame;
    feedbackFrame.size.height = [WMFeedCell cellHeightForIndexPath:indexPath dataSource:dataSource] - 10;
    //feedbackFrame.origin.y +=8;
    //_feedback.backgroundColor = [UIColor greenColor];
    _feedback.frame = feedbackFrame;
    
    self.commentCount.text = [feed.commentCount intValue]?[NSString stringWithFormat:@"%@条评论", feed.commentCount]:nil;
    
    
    if ([feed.type isEqualToString:WMFeedTypeDafen]) {
        
        
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.scoreView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [WMFeedCell cellHeightForIndexPath:indexPath dataSource:dataSource])] autorelease];
        _scoreView.backgroundColor = [UIColor colorWithHexString:@"#F1ECE4"];
        
        [self.contentView addSubview:_scoreView];
        
        NSArray *scores = [feed.score objectOrNilForKey:@"scores"];
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
            scoreCardFrame.origin.y = startY;
            scoreCard.frame = scoreCardFrame;
            [_scoreView addSubview:scoreCard];
            
            scoreLabel = [[[UILabel alloc] initWithFrame:scoreCard.bounds] autorelease];
            [scoreCard addSubview:scoreLabel];
            scoreLabel.textColor = [UIColor colorWithHexString:@"#ED8387"];
            scoreLabel.textAlignment = NSTextAlignmentCenter;
            scoreLabel.text = [NSString stringWithFormat:@"%.0f", [[scoreDic objectOrNilForKey:@"score"] floatValue]];
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
            
            if (startX > 300) {
                startX = 15;
                startY += 54;
            }
        }
        
        [self.scoreView addSubview:self.commentCount];
        CGRect commentButtonFrame = _commentCount.frame;
        commentButtonFrame.origin.y = _scoreView.frame.size.height-20;
        _commentCount.frame = commentButtonFrame;
        
        
        return;
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    [self.contentView addSubview:_commentCount];
    
    [_picture bindValueOfModel:[feed.attachments lastObject] forKeyPath:@"thumbnail"];
    
    self.content.text = feed.content;
    if ([feed.attachments count]) {
        self.content.frame = CGRectMake(168, 4+Yoffset, 140, [feed.content sizeWithFont:self.content.font constrainedToSize:CGSizeMake(140, WMFeedCellHasAttachmentsMaxContentHight) lineBreakMode:UILineBreakModeTailTruncation].height);
        CGRect commentButtonFrame = _commentCount.frame;
        commentButtonFrame.origin.y = 68+Yoffset;
        _commentCount.frame = commentButtonFrame;
        _commentCount.hidden = YES;
        
        CGRect commentContainerFrame = _commentContainer.frame;
        commentContainerFrame.origin.y = _commentCount.frame.origin.y + _commentCount.frame.size.height + 20;
        commentContainerFrame.origin.x = 79;
        _commentContainer.frame = commentContainerFrame;
    }
    else{
        
        self.content.frame = CGRectMake(79, 4+Yoffset, WMFeedCellNoAttachmentsContentWidth, [feed.content sizeWithFont:self.content.font constrainedToSize:CGSizeMake(WMFeedCellNoAttachmentsContentWidth, WMFeedCellNoAttachmentsMaxContentHight) lineBreakMode:UILineBreakModeTailTruncation].height);
        
        CGRect commentButtonFrame = _commentCount.frame;
        //        commentButtonFrame.origin.y = self.content.frame.size.height+self.content.frame.origin.y+10;
        commentButtonFrame.origin.y = self.content.frame.size.height+self.content.frame.origin.y - 18.0f;
        
        _commentCount.frame = commentButtonFrame;
        _commentCount.hidden = YES;
        
        CGRect commentContainerFrame = _commentContainer.frame;
        commentContainerFrame.origin.y = _commentCount.frame.origin.y + _commentCount.frame.size.height + 15;
        commentContainerFrame.origin.x = 79;
        _commentContainer.frame = commentContainerFrame;
    }
    
    if (_contentSep) {
        [_contentSep removeFromSuperview];
        _contentSep = nil;
    }
    
    [_commentContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat offsetY = 0.0f;
    CGFloat contentHeight = 0.0f;
    
    for (int i=0; i<[feed.comments count]; i++) {
        
        WMMComment *comment = [feed.comments objectAtIndex:i];
        
        NSString *text = [NSString stringWithFormat:@"%@：%@",comment.sender.name, comment.content];
        if ([comment.prefix length]) {
            text = [NSString stringWithFormat:@"%@回复%@：%@",comment.sender.name,comment.prefix, comment.content_orgin];
        }
        LWRichTextContentView *commentEmojo = [[[LWRichTextContentView alloc] initWithFrame:CGRectMake(0, offsetY, _commentContainer.frame.size.width, 14) withFont:[UIFont systemFontOfSize:12] withTextColor:[UIColor colorWithHexString:@"#A6937C"] withTextShadowColor:nil withTextShadowOffSet:CGSizeZero] autorelease];
//        [commentEmojo setKeyWordTextArray:[NSArray arrayWithObject:comment.sender.name] WithFont:[UIFont systemFontOfSize:12] AndColor:[UIColor redColor]];
        [_commentContainer addSubview:commentEmojo];
        
        [commentEmojo setBackgroundColor:[UIColor clearColor]];
        
        LWVMRichTextContent *postContent = [[[LWVMRichTextContent alloc] initWithContent:text
                                                                                withType:LWVMRichTextShowContentTypeFeed] autorelease];
        
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
    
    self.bottomLine.hidden = NO;
    self.bottomLine.frame = CGRectMake(0, [WMFeedCell cellHeightForIndexPath:indexPath dataSource:dataSource] - 1, 320, 1);
    
    if ([feed.comments count]>0) {
        
        if ([feed.comments count]>2) {
            CGRect commentContainerFrame = _commentContainer.frame;
            commentContainerFrame.origin.y = _commentCount.frame.origin.y + _commentCount.frame.size.height + 18;
            _commentContainer.frame = commentContainerFrame;
        }
        
        _contentSep = [[[UIImageView alloc] initWithFrame:CGRectMake(0.5, 0-8, 226, 1)] autorelease];
        _contentSep.backgroundColor = [UIColor colorWithHexString:@"#EAE0D1"];
        [_commentContainer addSubview:_contentSep];
        
    } else if (!self.createButton.hidden) {
        self.bottomLine.hidden = YES;
    }
    
    BOOL shouldShowDate = [[self class] shouldShowDayAtIndexPath:indexPath dataSource:dataSource];
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"dd"];
    [self showDate:shouldShowDate dateFormatter:formatter];
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
