//
//  WMDiscussCommentCell.m
//  WEIMI
//
//  Created by steve on 13-7-9.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMDiscussCommentCell.h"
#import "UIColor+HexString.h"
#import "NKDateUtil.h"
#import "WMTopicContentView.h"
#import "WMAudioPlayer.h"

@implementation WMDiscussCommentCell

+(CGFloat)cellHeightForObject:(id)object
{
    WMMTopicComment *comment = object;
    CGFloat totalHeight = 0;//昵称+间距
    if ([comment.prefix length]) {
        totalHeight = 33;
        NSString *replyStr = [NSString stringWithFormat:@"%@:%@",comment.prefix,comment.reply_comment];
        CGFloat height = [replyStr sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(264, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height;
        totalHeight += height;
        totalHeight += 12;//转发内容间距
    }else {
        totalHeight = 29;
    }
    CGFloat height = 2;
    for (int i=0; i<[comment.content count]; i++) {
        if (i>0) {
            height +=10;
        }
        WMMTopicCotent *content = [comment.content objectAtIndex:i];
        height += [WMTopicContentView heightForContent:content supportEmojo:YES];
    }
    totalHeight += height;
    if (comment.audioURLString) {
        totalHeight += 33;
    }
    totalHeight += 30;
    return totalHeight;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        _nameLabel = [[WMCustomLabel alloc] initWithFrame:CGRectMake(13, 10, 294, 16) font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHexString:@"#F096A0"]];
        [self addSubview:_nameLabel];
        _replyContentLabel = [[WMCustomLabel alloc] initWithFrame:CGRectMake(36, 33, 264, 13) font:[UIFont systemFontOfSize:11] textColor:[UIColor colorWithHexString:@"#A6937C"]];
        _replyContentLabel.numberOfLines = 0;
        [self addSubview:_replyContentLabel];
        _replySep = [[UIImageView alloc] initWithFrame:CGRectMake(25, 32, 1, 12)];
        _replySep.backgroundColor = [UIColor colorWithHexString:@"#e9ddca"];
        [self addSubview:_replySep];
        
        _contentLabel = [[WMCustomLabel alloc] initWithFrame:CGRectMake(13, 29, 287, 15) font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHexString:@"#A6937C"]];
        _contentLabel.numberOfLines = 0;
        [self addSubview:_contentLabel];
        
        commentContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 29, 287, 15)];
        [self addSubview:commentContentView];
        
        _dateLabel = [[WMCustomLabel alloc] initWithFrame:CGRectMake(13, 45, 200, 12) font:[UIFont systemFontOfSize:11] textColor:[UIColor colorWithHexString:@"#A6937C"]];
        [self addSubview:_dateLabel];
        _commentIcon = [[UIButton alloc] initWithFrame:CGRectMake(294, 41, 14, 14)];
        [_commentIcon setBackgroundImage:[UIImage imageNamed:@"reply_topic_icon"] forState:UIControlStateNormal];
        [_commentIcon addTarget:self action:@selector(reply) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_commentIcon];
        _cellSep = [[UIImageView alloc] initWithFrame:CGRectMake(13, 65, 294, 1)];
        _cellSep.backgroundColor = [UIColor colorWithHexString:@"#e9ddca"];
        [self addSubview:_cellSep];
        
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#ffe0e1"];
    }
    return self;
}

-(void)showForObject:(id)object
{
    [player removeFromSuperview];
    player = nil;
    
    _showComment = object;
    NSString *title ;
    if ([_showComment.sender.topicName length]) {
        title = [NSString stringWithFormat:@"%d楼 %@",_orderNew?( _commentCount - _currentIndex):(_currentIndex+1),_showComment.sender.topicName];
    }else {
        title = [NSString stringWithFormat:@"%d楼 %@",_orderNew?( _commentCount - _currentIndex):(_currentIndex+1),_showComment.sender.name];
    }
    _nameLabel.text = title;
    
    CGFloat totalHeight = 0;
    CGRect frame = self.frame;
    
    if ([_showComment.prefix length]) {
        totalHeight = 33;
        _replyContentLabel.hidden = NO;
        _replySep.hidden = NO;
        NSString *replyStr = [NSString stringWithFormat:@"%@ %@",_showComment.prefix,_showComment.reply_comment];
        CGFloat height = [replyStr sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(264, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height;
        frame = _replyContentLabel.frame;
        frame.size.height = height;
        _replyContentLabel.frame = frame;
        _replyContentLabel.text = replyStr;
        [_replyContentLabel setTextColor:[UIColor colorWithHexString:@"#F096A0"] range:NSMakeRange(0, _showComment.prefix.length)];
        frame = _replySep.frame;
        frame.size.height = height+2;
        _replySep.frame = frame;
        totalHeight += height;
        totalHeight += 12;
        
    }else {
        totalHeight = 29;
        _replyContentLabel.hidden = YES;
        _replySep.hidden = YES;
    }
    for (UIView *view in commentContentView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat height = 2;
    for (int i=0; i<[_showComment.content count]; i++) {
        if (i>0) {
            height += 10;
        }
        WMMTopicCotent *content = [_showComment.content objectAtIndex:i];
        UIView *containView = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, [WMTopicContentView heightForContent:content supportEmojo:YES])];
        [commentContentView addSubview:containView];
        WMTopicContentView *topicContentView = [[WMTopicContentView alloc] initWithContent:content supportEmojo:YES];
        [containView addSubview:topicContentView];
        height += [WMTopicContentView heightForContent:content supportEmojo:YES];
        
    }
    frame = commentContentView.frame;
    frame.origin.y = totalHeight;
    frame.size.height = height;
    commentContentView.frame = frame;
    
    totalHeight += height;
    
    if (_showComment.audioURLString) {
        
        totalHeight += 33.0f;
        NSURL *URL = [NSURL URLWithString:_showComment.audioURLString];
        int seconds = [_showComment.audioSecond intValue];
        player = [[WMAudioPlayer alloc] initWithURL:URL length:seconds];
        
        CGRect frame = player.frame;
        frame.origin = CGPointMake(13.0f, totalHeight - 23.0f);
        player.frame = frame;
        
        [self addSubview:player];
        
        //_playerButton = player;
    }
    
    frame = _dateLabel.frame;
    frame.origin.y = totalHeight + 10;
    _dateLabel.frame = frame;
    _dateLabel.text = [NKDateUtil intervalSinceNowWithDateDetail:_showComment.createTime];
    
    frame = _commentIcon.frame;
    frame.origin.y = totalHeight + 8;
    _commentIcon.frame = frame;
    
    totalHeight += 30;
    frame = _cellSep.frame;
    frame.origin.y = totalHeight-1;
    _cellSep.frame = frame;
    
}

-(void)reply
{
    [_delegate replyTopic:_currentIndex];
}

@end
