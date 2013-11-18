//
//  WMDiscussCell.m
//  WEIMI
//
//  Created by steve on 13-7-1.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMDiscussCell.h"
#import "UIColor+HexString.h"
#import "NKDateUtil.h"

#define WMDiscussCellTitleLabelFont [UIFont boldSystemFontOfSize:15]
#define WMDiscussCellContentLabelFont [UIFont systemFontOfSize:15]
#define WMDiscussCellFromLabelFont [UIFont systemFontOfSize:12]
#define WMDiscussCellDateLabelFont WMDiscussCellFromLabelFont
#define WMDiscussCellNumberCommentLabelFont WMDiscussCellDateLabelFont

@implementation WMDiscussCell

+(CGFloat)cellHeightForObject:(id)object
{
    WMMTopic *topic = object;
    CGFloat totalHeight = 0;
    if ([topic.is_top boolValue]) {
        NSString *str = [NSString stringWithFormat:@"    %@",topic.title];
        CGFloat height = [str sizeWithFont:WMDiscussCellTitleLabelFont constrainedToSize:CGSizeMake(300, 56) lineBreakMode:NSLineBreakByCharWrapping].height;
        return 24+MIN(height, 56);
    }else {
        CGFloat height = [topic.title sizeWithFont:WMDiscussCellTitleLabelFont constrainedToSize:CGSizeMake(300, 56) lineBreakMode:NSLineBreakByCharWrapping].height;
        totalHeight += height;
        totalHeight += 30 + 24;
        
//        height = [topic.desc sizeWithFont:WMDiscussCellContentLabelFont constrainedToSize:CGSizeMake(300, 96) lineBreakMode:NSLineBreakByCharWrapping].height;
//        height = MIN(height, 96);
        
        LWVMRichTextContent *postContent = [[LWVMRichTextContent alloc] initWithContent:topic.desc
                                                                               withType:LWVMRichTextShowContentTypeFeedDetail];
        
        [postContent resetNodeFrameWithOriginX:0 withOriginY:0];
        height = postContent.height;
        height = MIN(height, 100);
        totalHeight += height;
        
        totalHeight += 12+12;
        return totalHeight;
    }
    
    return totalHeight;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        _titleLabel = [[[WMCustomLabel alloc] initWithFrame:CGRectMake(10, 12, 300, 18) font:WMDiscussCellTitleLabelFont textColor:[UIColor colorWithHexString:@"#59493F"]] autorelease];
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];
        
        _topIcon = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 16, 15)] autorelease];
        _topIcon.image = [UIImage imageNamed:@"topic_top_icon"];
        [self addSubview:_topIcon];
        
        _fromLabel = [[[WMCustomLabel alloc] initWithFrame:CGRectZero font:WMDiscussCellFromLabelFont textColor:[UIColor colorWithHexString:@"#EB6877"]] autorelease];
        [self addSubview:_fromLabel];
        
//        _contentLabel = [[[WMCustomLabel alloc] initWithFrame:CGRectMake(10, 10, 300, 10) font:WMDiscussCellContentLabelFont textColor:[UIColor colorWithHexString:@"#7E6B5A"]] autorelease];
//        _contentLabel.numberOfLines = 0;
//        [self addSubview:_contentLabel];
        
        contentEmojo = [[[LWRichTextContentView alloc] initWithFrame:CGRectMake(10, 0, 300, self.frame.size.height) withFont:[UIFont systemFontOfSize:14] withTextColor:[UIColor colorWithHexString:@"#7E6B5A"] withTextShadowColor:nil withTextShadowOffSet:CGSizeZero] autorelease];
        [self addSubview:contentEmojo];
        
        _dateLabel = [[[WMCustomLabel alloc] initWithFrame:CGRectZero font:WMDiscussCellDateLabelFont textColor:[UIColor colorWithHexString:@"#A6937C"]] autorelease];
        [self addSubview:_dateLabel];
        
        _picIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [self addSubview:_picIcon];
        
        _voiceIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [self addSubview:_voiceIcon];
        
        _commentIcon = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)] autorelease];
        _commentIcon.image = [UIImage imageNamed:@"man_comment_icon"];
        [self addSubview:_commentIcon];
        
        _commentNumLabel = [[[WMCustomLabel alloc] initWithFrame:CGRectZero font:WMDiscussCellNumberCommentLabelFont textColor:[UIColor colorWithHexString:@"#A6937C"]] autorelease];
        _commentNumLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_commentNumLabel];
        
        _sepLine = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)] autorelease];
        _sepLine.backgroundColor = [UIColor colorWithHexString:@"#e9ddca"];
        [self addSubview:_sepLine];
        
        self.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#ffe0e1"];
        
    }
    
    return self;
}

-(void)showForObject:(id)object
{
    WMMTopic *topic = object;
    CGFloat totalHeight = 12;
    if ([topic.is_top boolValue]) {
        _topIcon.hidden = NO;
        //_contentLabel.hidden = YES;
        contentEmojo.hidden = YES;
        _dateLabel.hidden = YES;
        _commentNumLabel.hidden = YES;
        _commentIcon.hidden = YES;
        _fromLabel.hidden = YES;
        _picIcon.hidden = YES;
        _voiceIcon.hidden = YES;
        NSString *titleStr = [NSString stringWithFormat:@"    %@",topic.title];
        CGFloat height = [titleStr sizeWithFont:WMDiscussCellTitleLabelFont constrainedToSize:CGSizeMake(300, 56) lineBreakMode:NSLineBreakByCharWrapping].height;
        CGRect frame = _titleLabel.frame;
        frame.size.height = MIN(height, 56);
        _titleLabel.frame = frame;
        height = MIN(height, 56);
        _titleLabel.text = titleStr;
        totalHeight += height+12;
        
    }else {
        _topIcon.hidden = YES;
        //_contentLabel.hidden = NO;
        contentEmojo.hidden = NO;
        _dateLabel.hidden = NO;
        _commentNumLabel.hidden = NO;
        _commentIcon.hidden = NO;
        _fromLabel.hidden = NO;
        CGFloat height = [topic.title sizeWithFont:WMDiscussCellTitleLabelFont constrainedToSize:CGSizeMake(300, 56) lineBreakMode:NSLineBreakByCharWrapping].height;
        CGRect frame = _titleLabel.frame;
        frame.size.height = MIN(height, 56);
        _titleLabel.frame = frame;
        height = MIN(height, 56);
        _titleLabel.text = topic.title;
        totalHeight += height;
        totalHeight += 8;
        
        _fromLabel.frame = CGRectMake(10, totalHeight, 300, 13);
        _fromLabel.text = [NSString stringWithFormat:@"来自 %@",topic.sender.name];
        
        totalHeight += 13 + 6;
        
//        frame = _contentLabel.frame;
//        frame.origin.y = totalHeight;
//        frame.size.height = MIN([topic.desc sizeWithFont:WMDiscussCellContentLabelFont constrainedToSize:CGSizeMake(300, 96) lineBreakMode:NSLineBreakByCharWrapping].height, 96);
//        _contentLabel.frame = frame;
//        _contentLabel.text = topic.desc;
        
        [contentEmojo setBackgroundColor:[UIColor clearColor]];
        LWVMRichTextContent *postContent = [[LWVMRichTextContent alloc] initWithContent:topic.desc
                                                                               withType:LWVMRichTextShowContentTypeFeedDetail];
        
        [postContent resetNodeFrameWithOriginX:0 withOriginY:0];
        
        CGRect contentsFrame = contentEmojo.frame;
        contentsFrame.size.height = MIN(postContent.height, 100);
        contentsFrame.origin.y = totalHeight;
        contentEmojo.frame = contentsFrame;
        contentEmojo.richTextContent = postContent;
        [contentEmojo setNeedsDisplay];
        
        totalHeight += contentEmojo.frame.size.height+12;
        
        _dateLabel.frame = CGRectMake(10, totalHeight, 150, 12);
        _dateLabel.text = [NKDateUtil intervalSinceNowWithDateDetail:topic.createTime];
        _picIcon.hidden = YES;
        _voiceIcon.hidden = YES;
        if ([topic.hasPic boolValue]) {
            _picIcon.hidden = NO;
            CGFloat dateWidth  = [_dateLabel.text sizeWithFont:WMDiscussCellDateLabelFont constrainedToSize:CGSizeMake(150, 12) lineBreakMode:NSLineBreakByCharWrapping].width;
            _picIcon.image = [UIImage imageNamed:@"topic_pic_icon"];
            _picIcon.frame = CGRectMake(10+dateWidth+10, totalHeight, 10, 10);
            
        }
        
        if ([topic.audioURLString length]>0) {
            if ([topic.hasPic boolValue]) {
                _voiceIcon.hidden = NO;
                CGFloat dateWidth  = [_dateLabel.text sizeWithFont:WMDiscussCellDateLabelFont constrainedToSize:CGSizeMake(150, 12) lineBreakMode:NSLineBreakByCharWrapping].width;
                _voiceIcon.image = [UIImage imageNamed:@"topic_voice_icon"];
                _voiceIcon.frame = CGRectMake(10+dateWidth+10+20, totalHeight, 10, 10);
                
            }else {
                _voiceIcon.hidden = NO;
                CGFloat dateWidth  = [_dateLabel.text sizeWithFont:WMDiscussCellDateLabelFont constrainedToSize:CGSizeMake(150, 12) lineBreakMode:NSLineBreakByCharWrapping].width;
                _voiceIcon.image = [UIImage imageNamed:@"topic_voice_icon"];
                _voiceIcon.frame = CGRectMake(10+dateWidth+10, totalHeight, 10, 10);
            }
        }
        
        
        
        
        _commentNumLabel.frame = CGRectMake(265, totalHeight, 40, 12);
        _commentNumLabel.text = [topic.comment_count stringValue];
        
        CGFloat width = [[topic.comment_count stringValue] sizeWithFont:WMDiscussCellNumberCommentLabelFont constrainedToSize:CGSizeMake(41, 12) lineBreakMode:NSLineBreakByCharWrapping].width;
        
        frame = _commentIcon.frame;
        frame.origin.x = 310-width-20;
        frame.origin.y = totalHeight+1;
        _commentIcon.frame = frame;
        
        totalHeight += 12+12;

    }
    
    CGRect frame = _sepLine.frame;
    frame.origin.y = [WMDiscussCell cellHeightForObject:object]-1;
    _sepLine.frame = frame;
    
    
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
