//
//  WMDiscussBoardsCell.h
//  WEIMI
//
//  Created by steve on 13-6-28.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "NKTableViewCell.h"
#import "WMCustomLabel.h"
#import "NKBadgeView.h"

@interface WMDiscussBoardsCell : NKTableViewCell
{
    NKKVOImageView *iconView;
    WMCustomLabel *titleLabel,*tLabelOne,*tLabelTwo;
    NKBadgeView *badgeView;
}
@end
