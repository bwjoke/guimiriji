//
//  WMHoneyPersonFeedCell.m
//  WEIMI
//
//  Created by mzj on 13-2-28.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMHoneyPersonFeedCell.h"

@implementation WMHoneyPersonFeedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_dayLabel release];
    [_monthLabel release];
    [_timeLabel release];
    [_contentLabel release];
    [_commentImageView release];
    [_commentCountLabel release];
    [_feedPictureImageView release];
    [super dealloc];
}
@end
