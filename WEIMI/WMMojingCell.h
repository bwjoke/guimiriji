//
//  WMMojingCell.h
//  WEIMI
//
//  Created by SteveMa on 13-10-25.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "NKTableViewCell.h"

@interface WMMojingCell : NKTableViewCell
{
    UILabel *titileLabel,*countLabel;
    UIImageView *topicBadge;
    NKKVOImageView  *iconView;
}

-(void)showIndexPath:(NSIndexPath *)indexPath dataSource:(NSArray *)dataSource hasNotification: (BOOL)hasNotification;
@end
