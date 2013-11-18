//
//  WMPersonalCell.h
//  WEIMI
//
//  Created by steve on 13-4-8.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//
@protocol WMPersonalCellDelegate <NSObject>

@optional
-(void)switchValueChange:(UISwitch *)switchButton;
-(void)setNoNotification:(UISwitch *)switchButton;
@end

#import "NKUI.h"
#import "NKTableViewCell.h"
#import "KKPasscodeViewController.h"

@interface WMPersonalCell : NKTableViewCell

@property(nonatomic,assign)id<WMPersonalCellDelegate>delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)refreshWithIndexPath:(NSIndexPath *)indexPath;

@end
