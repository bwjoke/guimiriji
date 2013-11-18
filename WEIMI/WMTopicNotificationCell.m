//
//  WMTopicNotificationCell.m
//  WEIMI
//
//  Created by ZUO on 6/27/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMTopicNotificationCell.h"
#import "UIColor+HexString.h"
#import "WMMarginLabel.h"
#import "WMMTopic.h"
#import "NKDateUtil.h"

@interface WMTopicNotificationCell ()

+ (CGFloat)cellHeightForObject:(id)object;

@property (nonatomic, retain) UILabel *nickLabel;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *replyLabel;

@end

@implementation WMTopicNotificationCell

+ (CGFloat)cellHeightForObject:(id)object {
    
    WMMTopicNotification *model = (WMMTopicNotification *)object;
    
    CGSize size = [model.reply sizeWithFont:[UIFont systemFontOfSize:14.0f]
                          constrainedToSize:CGSizeMake(295.0f, 50.0f)
                              lineBreakMode:NSLineBreakByCharWrapping];
    
    // The reply will be at most two lines
    return size.height > 25.0f ? 136.0f : 116.0f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#FFF6F6"];
        
        // Bottom line
        self.bottomLine.image = [UIImage imageNamed:@"men_cell_sep"];
        
        // Nick name label
        UILabel *nickLabel = [[UILabel alloc] init];
        nickLabel.frame = CGRectMake(12.5f, 12.0f, 200.0f, 20.0f);
        nickLabel.backgroundColor = [UIColor clearColor];
        nickLabel.font = [UIFont systemFontOfSize:12.0f];
        nickLabel.textColor = [UIColor colorWithHexString:@"#a6937c"];
        [self.contentView addSubview:nickLabel];
        self.nickLabel = nickLabel;
        [nickLabel release];
        
        // Date label
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.frame = CGRectMake(230.0f, 12.0f, 80.0f, 20.0f);
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.font = [UIFont systemFontOfSize:12.0f];
        dateLabel.textAlignment = UITextAlignmentRight;
        dateLabel.textColor = [UIColor colorWithHexString:@"#a6937c"];
        [self.contentView addSubview:dateLabel];
        self.dateLabel = dateLabel;
        [dateLabel release];
        
        // Title label
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(12.5f, 39.0f, 295.0f, 20.0f);
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:16.0f];
        titleLabel.textColor = [UIColor colorWithHexString:@"#59493f"];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        [titleLabel release];
        
        // Reply label
        WMMarginLabel *replyLabel = [[WMMarginLabel alloc] init];
        replyLabel.margin = 10.0f;
        replyLabel.numberOfLines = 2;
        replyLabel.frame = CGRectMake(12.5f, 70.5f, 295.0f, 32.0f);
        replyLabel.backgroundColor = [UIColor colorWithHexString:@"f1ece4"];
        replyLabel.font = [UIFont systemFontOfSize:14.0f];
        replyLabel.textColor = [UIColor colorWithHexString:@"#a6937c"];
        [self.contentView addSubview:replyLabel];
        self.replyLabel = replyLabel;
        [replyLabel release];
        
    }
    return self;
}

- (void)showForObject:(id)object {
    [super showForObject:object];
    
    WMMTopicNotification *model = (WMMTopicNotification *)object;
    
    // Show nick name
    self.nickLabel.text = [model.nick description];
    
    // Show date
    self.dateLabel.text = [NKDateUtil intervalSinceNowWithDateDetail:model.createTime];
    
    // Show content
    self.titleLabel.text = [model.content description];
    
    // Reply
    self.replyLabel.text = model.message;
    
    if ([[self class] cellHeightForObject:model] > 116.0f) {
        CGRect frame = self.replyLabel.frame;
        frame.size.height = 52.0f;
        self.replyLabel.frame = frame;
    }
    
    // Place bottom line to bottom of cell {{{
    CGFloat lineHeight = self.bottomLine.image.size.height;
    CGFloat cellHeight = [[self class] cellHeightForObject:object];
    self.bottomLine.frame = CGRectMake(0.0f, cellHeight - lineHeight, 320.0f, lineHeight);
    // }}}
}

- (void)dealloc {
    
    [_nickLabel release];
    [_dateLabel release];
    [_titleLabel release];
    [_replyLabel release];
    
    [super dealloc];
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.replyLabel.backgroundColor = [UIColor colorWithHexString:@"f1ece4"];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.replyLabel.backgroundColor = [UIColor colorWithHexString:@"f1ece4"];
    }
}

@end
