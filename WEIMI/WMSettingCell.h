//
//  WMSettingCell.h
//  WEIMI
//
//  Created by steve on 13-4-8.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "NKTableViewCell.h"

@interface WMSettingCell : NKTableViewCell

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath;

-(void)showIndexPath:(NSIndexPath *)indexPath dataSource:(NSArray *)dataSource hasNotification: (BOOL)hasNotification;
@end
