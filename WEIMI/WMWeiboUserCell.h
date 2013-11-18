//
//  WMWeiboUserCell.h
//  WEIMI
//
//  Created by steve on 13-5-27.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

@protocol WMWeiboUserDelegate <NSObject>

@optional
-(void)inviteButtonClicked:(int)index;

@end

#import "NKTableViewCell.h"

@interface WMWeiboUserCell : NKTableViewCell

@property (nonatomic, assign) NKKVOImageView *avatar;

@property (nonatomic, assign) UILabel        *name;

@property (nonatomic, assign) UIButton       *button;

@property (nonatomic) int index;

@property (nonatomic, assign)id<WMWeiboUserDelegate>delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier index:(int)index;

@end
