//
//  WMHoneyPostTableCell.m
//  WEIMI
//
//  Created by mzj on 13-2-28.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMHoneyPostTableCell.h"

@implementation WMHoneyPostTableCell

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
    [_postButton release];
    [super dealloc];
}
@end
