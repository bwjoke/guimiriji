//
//  WMHoneyListCell.h
//  WEIMI
//
//  Created by steve on 13-4-9.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "NKTableViewCell.h"
#import "WMMUser.h"

@protocol WMHoneyListCellDelegate <NSObject>

@optional
-(void)unfollow:(NSIndexPath *)indexPath;

@end

@interface WMHoneyListCell : NKTableViewCell<UIAlertViewDelegate>
{
    NSIndexPath *currentIndexPath;
}

@property (nonatomic, assign) NKKVOImageView *avatar;

@property(nonatomic,assign)UILabel *name;
@property(nonatomic,assign)UILabel *request;

@property(nonatomic,assign)UIButton *button;

@property(nonatomic,assign)id<WMHoneyListCellDelegate>delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
indexPath:(NSIndexPath *)indexPath;
@end
