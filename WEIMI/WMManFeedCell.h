//
//  WMManFeedCell.h
//  WEIMI
//
//  Created by steve on 13-5-6.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//
#import "WMMUser.h"
#import "WMMFeed.h"

@protocol WMManFeedCellDelegate <NSObject>

@optional
-(void)avatarTaped:(WMMUser *)user;
-(void)setRate:(int)index feed:(WMMFeed *)feed;
-(void)showMoreView:(WMMFeed *)feed;

@end

#import "NKTableViewCell.h"
#import "WMAudioPlayer.h"

@interface WMManFeedCell : NKTableViewCell<UIGestureRecognizerDelegate>

@property (nonatomic, assign) NKKVOImageView *avatar,*manAvatar;
@property (nonatomic, assign) UILabel        *name,*noViewLabel,*manName;
@property (nonatomic, assign) UIImageView    *relation,*commentIcon,*pictureBack,*noneView;
@property (nonatomic, assign) UIView         *scoreView;
@property (nonatomic, assign) UILabel        *dateLabel,*commentLabel,*contentLabel,*distanceLabel;
@property (nonatomic, assign) UIButton       *rateButton,*moreButton;
@property (nonatomic, assign) NKKVOImageView *picture;
@property (nonatomic ,assign) UIImageView   *arrowImageView;
@property (nonatomic, assign) WMAudioPlayer *player;
@property (nonatomic)int index;
@property(nonatomic,assign)id<WMManFeedCellDelegate>delegate;

@end
